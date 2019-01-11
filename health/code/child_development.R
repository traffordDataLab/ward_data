# Education : Child Development at age 5, 2013/14 #

# Source: Office for National Statistics
# URL: http://www.localhealth.org.uk
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("LocalHealth_All_indicators_Ward_data.csv") %>%
  filter(`Parent Name` == "Trafford",
         `Indicator Name` == "Child Development at age 5 (%)") %>%
  select(area_code = `Area Code`,
         area_name = `Area Name`,
         value = Value) %>%
  mutate(period = "2013/14",
         indicator = "Child development at age 5",
         measure = "percentage",
         unit = "persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/child_development.csv")
