# Health: Number Killed or Seriously Injured on the roads, 2020 #

# Source: Transport for Greater Manchester
# URL: https://data.gov.uk/dataset/25170a92-0736-4090-baea-bf6add82d118/gm-road-casualty-accidents-full-stats19-data
# Licence: Open Government Licence
# Method: https://www.trafforddatalab/open_data/road_casualties/2017/pre-processing.R

library(tidyverse) ; library(sf)

ward_codes <- fromJSON("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD20_LAD20_CTY20_OTH_UK_LU_v2/FeatureServer/0/query?where=LAD20NM%20%3D%20'TRAFFORD'&outFields=*&outSR=4326&f=json") %>% 
  pluck("features", "attributes") %>%
  pull(WD20CD)

wards <- st_read(paste0("https://ons-inspire.esriuk.com/arcgis/rest/services/Administrative_Boundaries/Wards_December_2018_Boundaries_V3/MapServer/2/query?where=", 
                        URLencode(paste0("wd18cd IN (", paste(shQuote(ward_codes), collapse = ", "), ")")), 
                        "&outFields=wd18cd,wd18nm,long,lat&outSR=4326&f=geojson")) %>% 
  select(area_code = wd18cd, area_name = wd18nm, long, lat)


sf <- read_csv("https://github.com/traffordDataLab/open_data/raw/master/road_casualties/STATS19_road_casualties_2010-2020.csv") %>%
  filter(area_name == "Trafford",
         casualty_severity != "Slight",
         year == 2020) %>%
  select(AREFNO, lon, lat) %>%
  st_as_sf(crs = 4326, coords = c("lon", "lat")) %>%
  st_intersection(wards) %>%
  st_set_geometry(value = NULL) %>%
  group_by(area_code, area_name) %>%
  summarise(value = n())

df <- wards %>% 
  st_set_geometry(value = NULL) %>% 
  left_join(sf) %>% 
  mutate(value = replace_na(value, 0),
         period = "2020",
         indicator = "Killed or Seriously Injured",
         measure = "Count",
         unit = "Casualties") %>%
  select(area_code, area_name, indicator, period, measure, unit, value) %>%
  arrange(area_code)

write_csv(df, "../data/ksi.csv")
