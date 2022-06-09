# Health: Low birth weight, 2015 - 2019 #

# Source: Office for National Statistics
# URL: https://fingertips.phe.org.uk/
# Licence: Open Government Licence

library(tidyverse) 

df <- read_csv("https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=93092&child_area_type_id=8&parent_area_type_id=101&parent_area_code=E08000009") %>%  
  filter(`Parent Name` == "Trafford") %>%
  select(area_code = `Area Code`,
         area_name = `Area Name`,
         period = `Time period`,
         value = Value) %>%
  mutate(indicator = "Low birth weight",
         measure = "Percentage",
         unit = "Babies",
         value = round(value, 1)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/low_birth_weight.csv")
