## Health: Male life expectancy at birth, 2011-2015 ##

# Source: ONS
# URL: http://www.localhealth.org.uk/
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("LocalHealth_All_indicators_Ward_data.csv") %>%
  filter(`Indicator Name` == "Life expectancy at birth, (upper age band 90+)",
         Sex == "Male") %>%
  select(area_code = `Area Code`,
         area_name = `Area Name`,
         value = Value) %>%
  mutate(period = "2011 to 2015",
         indicator = "Male life expectancy at birth",
         measure = "years",
         unit = "persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/male_life_expectancy.csv")
