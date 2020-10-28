# Environment: Area covered by greenspace, 2020 #

# Source: OS Open Greenspace, Ordnance Survey
# URL: https://www.ordnancesurvey.co.uk/business-and-government/products/os-open-greenspace.html?utm_source=Greenspace%2520OS%2520openspace%2520-%2520%252Fopengreenspace&utm_campaign=Greenspace%20
# Licence: Open Government Licence. OS data © Crown copyright and database right 2020.
# Method: https://www.trafforddatalab.io/open_data/greenspaces/pre-processing.R

library(tidyverse) ; library(sf) ; library(units)

wards <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_December_2019_Boundaries_UK_BFC_v2/FeatureServer/0/query?where=", 
                        URLencode(paste0("wd19cd IN (", paste(shQuote(paste0("E0", seq(5000819, 5000839, 1))), collapse = ", "), ")")), 
                        "&outFields=wd19cd,wd19nm&outSR=4326&f=geojson")) %>%
  mutate(area = as.numeric(set_units(st_area(.), km^2))) %>%
  select(area_code = WD19CD, area_name = WD19NM, area)

url <- "https://api.os.uk/downloads/v1/products/OpenGreenspace/downloads?area=SJ&format=ESRI%C2%AE+Shapefile&redirect"
download.file(url, dest = "opgrsp_essh_sj.zip")
unzip("opgrsp_essh_sj.zip", exdir = ".")
file.remove("opgrsp_essh_sj.zip")

greenspace <- read_sf("OS Open Greenspace (ESRI Shape File) SJ/data/SJ_GreenspaceSite.shp") %>% 
  st_transform(crs = 4326) %>% 
  st_zm() %>% 
  mutate(site_type = factor(`function.`)) %>% 
  select(id, site_type)

df <- greenspace %>%
  st_intersection(wards) %>%
  mutate(greenspace = as.numeric(set_units(st_area(.), km^2))) %>%
  st_set_geometry(value = NULL) %>%
  group_by(area_code, area_name, area) %>%
  summarise(greenspace = sum(greenspace)) %>%
  ungroup() %>%
  mutate(value = round((greenspace/area)*100, 1),
         period = "2020",
         indicator = "Area covered by greenspace",
         measure = "Percentage",
         unit = "Area sq km") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)
 
write_csv(df, "../data/greenspace.csv")