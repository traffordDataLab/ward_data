# Economy: Economically inactive, 2011

# Source: Table KS601EW, Census 2011
# URL: https://www.nomisweb.co.uk/census/2011/ks601ew
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_624_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&c_sex=0&cell=300&measures=20301&select=date_name,geography_name,geography_code,rural_urban_name,c_sex_name,cell_name,measures_name,obs_value,obs_status_name") %>%
  select(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         value = OBS_VALUE) %>%
  mutate(period = "2011",
         indicator = "Adults aged 16-74 who are economically inactive",
         measure = "Proportion",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/economically_inactive.csv")
