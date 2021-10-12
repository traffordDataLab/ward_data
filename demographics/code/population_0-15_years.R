# Demographics: Percentage of population aged 0-15 years, 2020 #

# Source: ONS 2020 Mid-Year Population Estimates
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(tidyverse)

row <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2010_1.data.csv?geography=1656750701...1656750715,1656750717,1656750716,1656750718...1656750721&date=latest&gender=0&c_age=200,201&measures=20100") 

df <- row %>%
  select(area_code = "GEOGRAPHY_CODE", area_name = "GEOGRAPHY_NAME", age = C_AGE_NAME, Count = OBS_VALUE) %>%
  pivot_wider (names_from = age, values_from = Count) %>%
  mutate(Percentage = round(`Aged 0 to 15`/`All Ages`*100, 1)) %>% 
  select(area_code, area_name, Percentage, Count = `Aged 0 to 15`) %>%
  gather(measure, value, Percentage, Count) %>%
  mutate(period = as.Date("2020-06-30", format = '%Y-%m-%d'),
         indicator = "Population aged 0-15 years",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/population_0-15_years.csv")
