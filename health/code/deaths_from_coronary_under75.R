# Health: Deaths from coronary heart disease amongst those aged under 75 years, 2013-17 #

# Source: Public Health England
# URL: https://fingertips.phe.org.uk/
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=93256&child_area_type_id=8&parent_area_type_id=101&parent_area_code=E08000009") %>%  
  filter(`Parent Name` == "Trafford") %>%
  select(area_code = `Area Code`,
         area_name = `Area Name`,
         value = Value) %>% 
  mutate(period = "2013 to 2017",
         indicator = "Deaths from coronary heart disease amongst those aged under 75 years",
         measure = "SMR",
         unit = "Persons",
         value = round(value, 1)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/deaths_from_coronary_under75.csv")
