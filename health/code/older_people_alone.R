# Health: Older people living alone, 2011 #

# Source: Table QS114EW, Census 2011
# URL: https://www.nomisweb.co.uk/census/2011/qs114ew
# Licence: Open Government Licence

library(tidyverse)

pop <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_145_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&cell=13...16&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,cell_name,measures_name,obs_value,obs_status_name") %>% 
  group_by(GEOGRAPHY_CODE) %>% 
  summarise(pop = sum(OBS_VALUE))

df <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_514_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&c_ahchuk11=2&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,c_ahchuk11_name,measures_name,obs_value,obs_status_name") %>% 
  left_join(pop, by = "GEOGRAPHY_CODE") %>% 
  mutate(value = round((OBS_VALUE/pop)*100,1)) %>% 
  select(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         value) %>% 
  mutate(period = "2011",
         indicator = "Percentage of older people living alone",
         measure = "Percentage",
         unit = "Persons",
         value = round(value, 1)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "older_people_alone.csv")