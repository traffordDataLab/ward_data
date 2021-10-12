# Demographics: old-age dependency ratio, 2020 #

# Source: ONS 2020 Mid-Year Population Estimates
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(tidyverse)

row <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2010_1.data.csv?geography=1656750701...1656750715,1656750717,1656750716,1656750718...1656750721&date=latest&gender=0&c_age=101...191&measures=20100") 

df <- row %>%
  select(area_code = "GEOGRAPHY_CODE", area_name = "GEOGRAPHY_NAME", age = C_AGE_SORTORDER, Count = OBS_VALUE) %>%
  mutate(age = as.integer(age),
         ageband = cut(age,
                       breaks = c(16,65,120),
                       labels = c("working_age","state_pension_age"),
                       right = FALSE)) %>%
  filter(!is.na(ageband)) %>%
  group_by(area_code, area_name, ageband) %>%
  summarise(Count = sum(Count)) %>%
  select(area_code, area_name, ageband, Count) %>%
  spread(ageband, Count) %>%
  mutate(value = round((state_pension_age/working_age)*100, 1),
         period = as.Date("2020-06-30", format = '%Y-%m-%d'),
         indicator = "Old-age dependency ratio",
         measure = "Ratio",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/old_age_dependency_ratio.csv")  
