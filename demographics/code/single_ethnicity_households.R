# Demographics: Single ethnicity households, 2011 #

# Source: Table QS202EW, 2011 Census
# URL: https://www.nomisweb.co.uk/census/2011/qs202ew
# Licence: Open Government Licence

library(tidyverse)

households <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_619_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&cell=0&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,cell_name,measures_name,obs_value,obs_status_name") %>%
  select(area_code = GEOGRAPHY_CODE, households = OBS_VALUE)

df <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_523_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&c_meighuk11=2&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,c_meighuk11_name,measures_name,obs_value,obs_status_name") %>%
  select(area_code = GEOGRAPHY_CODE, area_name = GEOGRAPHY_NAME, single_ethnicity = OBS_VALUE) %>%
  left_join(., households, by = "area_code") %>%
  mutate(value = round((single_ethnicity/households)*100, 1),
         period = "2011",
         indicator = "Single ethnicity households",
         measure = "percentage",
         unit = "households") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/single_ethnicity_households.csv")
