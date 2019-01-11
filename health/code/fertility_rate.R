# Health: Crude fertility rate, 2011-2015 #

# Source: Office for National Statistics
# URL: http://www.localhealth.org.uk
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("LocalHealth_All_indicators_Ward_data.csv") %>%
  filter(`Parent Name` == "Trafford",
         `Indicator Name` == "Crude fertility rate: live births per 1,000 women aged 15-44 years. five year aggregate") %>%
  select(area_code = `Area Code`,
         area_name = `Area Name`,
         value = Value) %>%
  mutate(period = "2011 to 2015",
         indicator = "Crude fertility rate",
         measure = "rate",
         unit = "per 1000",
         value = round(value, 1)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/fertility_rate.csv")
