# Health: Low birth weight, 2011-2015 #

# Source: Office for National Statistics
# URL: http://www.localhealth.org.uk
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("LocalHealth_All_indicators_Ward_data.csv") %>%
  filter(`Parent Name` == "Trafford",
         `Indicator Name` == "Low birth weight of term babies, five year aggregate") %>%
  select(area_code = `Area Code`,
         area_name = `Area Name`,
         value = Value) %>%
  mutate(period = "2011 to 2015",
         indicator = "Low birth weight",
         measure = "percentage",
         unit = "persons",
         value = round(value, 1)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/low_birth_weight.csv")
