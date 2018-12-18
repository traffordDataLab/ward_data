# Health: Obese adults, 2006-2008 #

# Source: Office for National Statistics
# URL: http://www.localhealth.org.uk
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("LocalHealth_All_indicators_Ward_data.csv") %>% 
  filter(`Parent Name` == "Trafford",
         `Indicator Name` == "Obese adults, modelled estimate") %>%
  select(area_code = `Area Code`,
         area_name = `Area Name`,
         value = Value) %>% 
  mutate(period = "2006-08",
         indicator = "Adults classified as obese",
         measure = "percent",
         unit = "persons") %>% 
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../obese_adults.csv")