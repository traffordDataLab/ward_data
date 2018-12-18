# Environment: Area covered by greenspace, 2018 #

# Source: OS Open Greenspace, Ordnance Survey
# URL: https://www.ordnancesurvey.co.uk/business-and-government/products/os-open-greenspace.html?utm_source=Greenspace%2520OS%2520openspace%2520-%2520%252Fopengreenspace&utm_campaign=Greenspace%20
# Licence: Open Government Licence. OS data © Crown copyright and database right 2018.
# Method: https://www.trafforddatalab.io/open_data/greenspaces/pre-processing.R

library(tidyverse) ; library(sf) ; library(units)

wards <- st_read("https://opendata.arcgis.com/datasets/07194e4507ae491488471c84b23a90f2_0.geojson") %>% 
  filter(wd17cd %in% paste0("E0", seq(5000819, 5000839, 1))) %>%
  select(area_code = wd17cd, area_name = wd17nm) %>% 
  mutate(area = as.numeric(set_units(st_area(.), km^2)))

greenspace <- st_read("https://github.com/traffordDataLab/open_data/raw/master/greenspaces/trafford_greenspace_sites.geojson") %>% 
  select(id, site_type)

df <- greenspace %>% 
  st_intersection(wards) %>% 
  mutate(greenspace = as.numeric(set_units(st_area(.), km^2))) %>% 
  group_by(area_code, area_name, area) %>% 
  summarise(greenspace = sum(greenspace)) %>% 
  ungroup() %>% 
  mutate(value = round((greenspace/area)*100, 1),
         period = "2018",
         indicator = "Area covered by greenspace",
         measure = "percent",
         unit = "persons") %>% 
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../greenspace.csv")
