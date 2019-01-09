# Average broadband speed (Mbit/s), May/June 2017 #

# Source: Connected Nations, Ofcom
# URL: https://www.ofcom.org.uk/research-and-data/multi-sector-research/infrastructure-research/connected-nations-2017/data-downloads
# Licence: Open Government Licence
# Method: Median of mean postcode centroid download speed.

library(tidyverse); library(sf)

url <- "https://www.ofcom.org.uk/static/research/connected-nations2017/fixed-postcode-2017.zip"
download.file(url, dest = "fixed-postcode-data.zip")
unzip("fixed-postcode-data.zip", exdir = ".")
file.remove("fixed-postcode-data.zip")

postcodes <- read_csv("http://geoportal.statistics.gov.uk/datasets/75edec484c5d49bcadd4893c0ebca0ff_0.csv") %>%
  filter(oslaua == "E08000009") %>%
  select(postcode_space = pcds, lon = long, lat)

wards <- st_read("https://opendata.arcgis.com/datasets/07194e4507ae491488471c84b23a90f2_0.geojson") %>%
  filter(wd17cd %in% paste0("E0", seq(5000819, 5000839, 1))) %>%
  select(area_code = wd17cd, area_name = wd17nm)

df <- bind_rows(read_csv("2017_fixed_pc_r02_M.csv"),
                read_csv("2017_fixed_pc_r02_WA.csv")) %>%
  left_join(., postcodes, by = "postcode_space") %>%
  filter(!is.na(lon)) %>%
  st_as_sf(crs = 4326, coords = c("lon", "lat")) %>%
  st_join(wards) %>%
  mutate(mean_download_speed = as.double(`Average download speed (Mbit/s)`)) %>%
  filter(mean_download_speed != "N/A") %>%
  group_by(area_code, area_name) %>%
  summarize(value = round(median(mean_download_speed, na.rm = TRUE), 1)) %>%
  st_set_geometry(value = NULL) %>%
  mutate(period = "2017-05",
         indicator = "Average download speed",
         measure = "Bandwidth",
         unit = "Mbps") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/average_broadband_speed.csv")
