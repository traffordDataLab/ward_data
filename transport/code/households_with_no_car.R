# Households with no car #

# Source: Table KS404EW, Census 2011
# URL: https://www.nomisweb.co.uk/census/2011/ks404ew
# Licence: Open Government Licence

library(tidyverse) 

df <-read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_621_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&cell=1&measures=20301&select=date_name,geography_name,geography_code,rural_urban_name,cell_name,measures_name,obs_value,obs_status_name") %>% 
  select(area_code = GEOGRAPHY_CODE, 
         area_name = GEOGRAPHY_NAME, 
         period = DATE_NAME,
         value = OBS_VALUE) %>% 
  mutate(period = "2011",
         indicator = "Households with no car",
         measure = "percent",
         unit = "households") %>% 
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../households_with_no_car.csv")
