# Demographics: Total resident population, 2020 #

# Source: ONS 2020 Mid-Year Population Estimates. Ward-level population estimates (Experimental Statistics)
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2010_1.data.csv?geography=1656750701...1656750715,1656750717,1656750716,1656750718...1656750721&date=latest&gender=0&c_age=200&measures=20100") %>%
  mutate(period = as.Date("2020-06-30", format = '%Y-%m-%d'),
         indicator = "Total resident population",
         measure = "Count",
         unit = "Persons") %>%
  select(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         indicator, period, measure, unit,
         value = OBS_VALUE)

write_csv(df, "../data/total_resident_population.csv")
