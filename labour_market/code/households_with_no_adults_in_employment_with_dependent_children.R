# Labour market: Households with no adults in employment with dependent children, 2011 #

# Source: Table KS106EW, Census 2011
# URL: https://www.nomisweb.co.uk/census/2011/ks106ew
# Licence: Open Government Licence

library(tidyverse)

df <-read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_606_1.data.csv?date=latest&geography=1237320482...1237320496,1237320498,1237320497,1237320499...1237320502&rural_urban=0&cell=1&measures=20301&select=date_name,geography_name,geography_code,rural_urban_name,cell_name,measures_name,obs_value,obs_status_name") %>%
  select(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         period = DATE_NAME,
         value = OBS_VALUE) %>%
  mutate(period = "2011",
         indicator = "Households with no adults in employment with dependent children",
         measure = "percentage",
         unit = "households") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/households_with_no_adults_in_employment_with_dependent_children.csv")
