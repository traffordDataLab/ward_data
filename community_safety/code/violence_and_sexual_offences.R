# Community Safety: Violence and sexual offences, last 12 months #

# Source: Home Office
# URL: https://data.police.uk/
# Licence: Open Government Licence
# Method: Rate per 1,000 residents

library(tidyverse) ; library(sf) ; library(readxl)

wards <- st_read("https://opendata.arcgis.com/datasets/07194e4507ae491488471c84b23a90f2_0.geojson") %>% 
  filter(wd17cd %in% paste0("E0", seq(5000819, 5000839, 1))) %>%
  select(area_code = wd17cd, area_name = wd17nm) 

url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2017sape20dt8/sape20dt8mid2017ward2017syoaestimatesunformatted1.zip"
download.file(url, dest = "sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")
unzip("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip", exdir = ".")
file.remove("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")

residents <- read_excel("SAPE20DT8-mid-2017-ward-2017-syoa-estimates-unformatted.xls", sheet = 4, skip = 3) %>% 
  filter(`Local Authority` == 'Trafford') %>% 
  select(area_code = `Ward Code 1`, residents = `All Ages`)

df <- dir(pattern = "*.csv") %>% 
  map(read_csv) %>%
  reduce(rbind) %>% 
  filter(`Crime type` == "Violence and sexual offences",
         grepl("Trafford", `LSOA name`)) %>% 
  select(`Crime type`, Longitude, Latitude) %>% 
  st_as_sf(crs = 4326, coords = c("Longitude", "Latitude")) %>% 
  st_intersection(wards) %>% 
  st_set_geometry(value = NULL) %>% 
  group_by(area_code, area_name) %>% 
  summarise(n = n()) %>% 
  left_join(residents, by = "area_code") %>% 
  mutate(value = round((n/residents)*1000, 1),
         period = "2017-10 to 2018-11",
         indicator = "Violence and sexual offences",
         measure = "rate",
         unit = "crimes") %>% 
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../violence_and_sexual_offences.csv")

