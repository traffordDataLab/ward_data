# Community Safety: Burglary, last 12 months #

# Source: Home Office
# URL: https://data.police.uk/
# Licence: Open Government Licence
# Method: Rate per 1,000 households

library(tidyverse) ; library(sf) ; library(readxl)

wards <- st_read("https://opendata.arcgis.com/datasets/07194e4507ae491488471c84b23a90f2_0.geojson") %>%
  filter(wd17cd %in% paste0("E0", seq(5000819, 5000839, 1))) %>%
  select(area_code = wd17cd, area_name = wd17nm)

households <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_619_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&cell=0&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,cell_name,measures_name,obs_value,obs_status_name") %>%
  select(area_code = GEOGRAPHY_CODE, households = OBS_VALUE)

df <- dir(pattern = "*.csv") %>%
  map(read_csv) %>%
  reduce(rbind) %>%
  filter(`Crime type` == "Burglary",
         grepl("Trafford", `LSOA name`)) %>%
  select(`Crime type`, Longitude, Latitude) %>%
  st_as_sf(crs = 4326, coords = c("Longitude", "Latitude")) %>%
  st_intersection(wards) %>%
  st_set_geometry(value = NULL) %>%
  group_by(area_code, area_name) %>%
  summarise(n = n()) %>%
  left_join(households, by = "area_code") %>%
  mutate(value = round((n/households)*1000, 1),
         period = "2017-10 to 2018-11",
         indicator = "Burglary",
         measure = "rate",
         unit = "crimes") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/burglary.csv")
