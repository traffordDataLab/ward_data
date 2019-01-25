# Health: Deaths from coronary heart disease amongst those aged under 75 years, 2011-15 #

# Source: Public Health England, produced from ONS data Copyright 2017
# URL: http://www.localhealth.org.uk/
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("LocalHealth_All_indicators_Ward_data.csv") %>% 
  filter(`Parent Name` == "Trafford",
         `Indicator Name` == "Deaths from coronary heart disease, under 75 years, standardised mortality ratio") %>% 
  select(area_code = `Area Code`,
         area_name = `Area Name`,
         value = Value) %>% 
  mutate(period = "2011 to 2015",
         indicator = "Deaths from coronary heart disease amongst those aged under 75 years",
         measure = "SMR",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "deaths_from_coronary_under75.csv")



