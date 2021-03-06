## Health: Male life expectancy at birth, 2013-2017 ##

# Source: ONS
# URL: https://fingertips.phe.org.uk/
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=93283&child_area_type_id=8&parent_area_type_id=101&parent_area_code=E08000009") %>%  
  filter(`Parent Name` == "Trafford") %>%
  filter(Sex == "Male") %>%
  select(area_code = `Area Code`,
         area_name = `Area Name`,
         value = Value) %>%
  mutate(period = "2013 to 2017",
         indicator = "Male life expectancy at birth",
         measure = "Years",
         unit = "Males") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/male_life_expectancy.csv")
