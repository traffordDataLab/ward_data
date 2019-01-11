# Travel to work by bicycle #

# Source: Table QS701EW, Census 2011
# URL: https://www.nomisweb.co.uk/census/2011/qs701ew
# Licence: Open Government Licence

library(tidyverse)

df <-read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_568_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&cell=0,9&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,cell_name,measures_name,obs_value,obs_status_name") %>%
  spread(CELL_NAME, OBS_VALUE) %>%
  mutate(value = round((Bicycle/`All categories: Method of travel to work`)*100,1)) %>%
  select(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         period = DATE_NAME,
         value) %>%
  mutate(indicator = "Travel to work by bicycle",
         measure = "percentage",
         unit = "persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/travel_to_work_by_bike.csv")
