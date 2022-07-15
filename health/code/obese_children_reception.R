# Health: Percentage of measured children in Reception Year (aged 4-5 years) who were classified as obese, 2017/18 to 2019/20 #

# Source: National Child Measurement Programme
# URL: https://fingertips.phe.org.uk/
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("https://fingertips.phe.org.uk/api/all_data/csv/by_indicator_id?indicator_ids=93105&child_area_type_id=8&parent_area_type_id=101&parent_area_code=E08000009") %>%  
  filter(`Parent Name` == "Trafford",
         `Time period` == "2017/18 - 19/20") %>%
  select(area_code = `Area Code`,
         area_name = `Area Name`,
         value = Value) %>%
  mutate(period = "2017/18 to 2019/20",
         indicator = "Children in Reception Year who were classified as obese",
         measure = "Percentage",
         unit = "Persons",
         value = round(as.double(value), 1)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/obese_children_reception.csv")
