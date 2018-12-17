# Health: Number Killed or Seriously Injured on the roads, 2017 #

# Source: Transport for Greater Manchester
# URL: https://data.gov.uk/dataset/25170a92-0736-4090-baea-bf6add82d118/gm-road-casualty-accidents-full-stats19-data
# Licence: Open Government Licence
# Method: https://www.trafforddatalab/open_data/road_casualties/2017/pre-processing.R

library(tidyverse) ; library(sf)

wards <- st_read("https://opendata.arcgis.com/datasets/07194e4507ae491488471c84b23a90f2_0.geojson") %>% 
  filter(wd17cd %in% paste0("E0", seq(5000819, 5000839, 1))) %>%
  select(area_code = wd17cd, area_name = wd17nm) 

df <- read_csv("https://github.com/traffordDataLab/open_data/raw/master/road_casualties/2017/STATS19_casualty_data_2017.csv") %>% 
  filter(area_name == "Trafford",
         severity != "Slight") %>% 
  select(AREFNO, lng, lat) %>% 
  st_as_sf(crs = 4326, coords = c("lng", "lat")) %>% 
  st_intersection(wards) %>% 
  st_set_geometry(value = NULL) %>% 
  group_by(area_code, area_name) %>% 
  summarise(value = n()) %>% 
  mutate(period = "2017",
         indicator = "Killed or Seriously Injured",
         measure = "count",
         unit = "casualties") %>% 
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../ksi.csv")

  
  


