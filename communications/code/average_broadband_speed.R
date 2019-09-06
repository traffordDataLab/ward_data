## Average broadband speed (Mbit/s), May/June 2018 ##

# Source: Connected Nations, Ofcom
# URL: https://www.ofcom.org.uk/research-and-data/multi-sector-research/infrastructure-research/connected-nations-2018/data-downloads
# Licence: Open Government Licence
# Method: Median of mean postcode centroid download speed.

library(tidyverse) ; library(jsonlite) ; library(sf)

url <- "https://www.ofcom.org.uk/__data/assets/file/0011/131042/201809_fixed_pc_r03.zip"
download.file(url, dest = "201809_fixed_pc_r03.zip")
unzip("201809_fixed_pc_r03.zip", exdir = ".")
file.remove("201809_fixed_pc_r03.zip")

postcodes <- read_csv("https://github.com/traffordDataLab/spatial_data/raw/master/postcodes/trafford_postcodes.csv") %>%
  select(postcode_space = postcode, lon, lat)

codes <- fromJSON(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD18_LAD18_UK_LU/FeatureServer/0/query?where=LAD18NM%20like%20'%25", URLencode(toupper("Trafford"), reserved = TRUE), "%25'&outFields=WD18CD,LAD18NM&outSR=4326&f=json"), flatten = TRUE) %>% 
  pluck("features") %>% 
  as_tibble() %>% 
  distinct(attributes.WD18CD) %>% 
  pull(attributes.WD18CD) 

wards <- st_read(paste0("https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Wards_December_2018_Boundaries_V3/MapServer/2/query?where=", 
                        URLencode(paste0("wd18cd IN (", paste(shQuote(codes), collapse = ", "), ")")), 
                        "&outFields=wd18cd,wd18nm&outSR=4326&f=geojson")) %>%
  select(area_code = wd18cd, area_name = wd18nm)

df <- bind_rows(read_csv("201805_fixed_pc_performance_r03.csv"),
                read_csv("201809_fixed_pc_coverage_r01.csv")) %>%
  left_join(., postcodes, by = "postcode_space") %>%
  filter(!is.na(lon)) %>%
  st_as_sf(crs = 4326, coords = c("lon", "lat")) %>%
  st_join(wards) %>%
  mutate(mean_download_speed = as.double(`Average download speed (Mbit/s)`)) %>%
  filter(mean_download_speed != "N/A") %>%
  group_by(area_code, area_name) %>%
  summarize(value = round(median(mean_download_speed, na.rm = TRUE), 1)) %>%
  st_set_geometry(value = NULL) %>%
  mutate(period = "2018-05",
         indicator = "Average download speed",
         measure = "Bandwidth",
         unit = "Mbps") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/average_broadband_speed.csv")
