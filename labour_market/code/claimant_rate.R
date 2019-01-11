# Labour Market: Claimant rate, latest #

# Source: Claimant count by sex and age
# URL: https://www.nomisweb.co.uk/datasets/ucjsa
# Licence: Open Government Licence
# NB Claimants as a proportion of residents aged 16-64

library(tidyverse) ; library(zoo)

df <-read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_162_1.data.csv?geography=E05000819...E05000839&date=latest&gender=0&age=0&measure=2&measures=20100&select=date_name,geography_name,geography_code,gender_name,age_name,measure_name,measures_name,obs_value,obs_status_name") %>%
  select(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         period = DATE_NAME,
         value = OBS_VALUE) %>%
  mutate(period = as.Date(as.yearmon(period, "%B %Y")),
         indicator = "Claimant rate",
         measure = "proportion",
         unit = "persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/claimant_rate.csv")
