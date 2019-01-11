# Health: Percentage of measured children in Reception Year (aged 4-5 years) who were classified as obese, 2014/15 to 2016/17 #

# Source: National Child Measurement Programme (NCMP)
# URL: https://www.gov.uk/government/statistics/child-obesity-and-excess-weight-small-area-level-data
# Licence: Open Government Licence

library(tidyverse) ; library(readxl)

df <- read_excel("https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/701874/NCMP_data_Ward_update_2018.xlsx",
                 sheet = 2, skip = 3) %>%
  filter(`LA name` == "Trafford") %>%
  select(area_code = `Ward code`,
         area_name = `Ward name`,
         value = `%..38`) %>%
  mutate(period = "2014/15 to 2016/17",
         indicator = "Percentage of measured children in Reception Year who were classified as obese",
         measure = "percentage",
         unit = "persons",
         value = round(as.double(value), 1)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/obese_children_reception.csv")
