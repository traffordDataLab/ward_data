# Labour market: Percentage of dependent children (0-18) in out-of-work households, 2017 #

# Source: HM Revenue and Customs
# URL: https://www.gov.uk/government/collections/children-in-out-of-work-benefit-households--2
# Licence: Open Government Licence

library(tidyverse) ; library(readODS) ; library(readxl)

url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2017sape20dt8/sape20dt8mid2017ward2017syoaestimatesunformatted1.zip"
download.file(url, dest = "sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")
unzip("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip", exdir = ".")
file.remove("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")

pop <- read_excel("SAPE20DT8-mid-2017-ward-2017-syoa-estimates-unformatted.xls",
                  sheet = 4, skip = 3) %>%
  filter(`Local Authority` == 'Trafford') %>%
  mutate(total = rowSums(select(., `0`:`18`))) %>%
  select(area_code = `Ward Code 1`, total)

df <- read_ods("children-in-out-of-work-households-by-ward-may-2017.ods", sheet = 3, skip = 7) %>%
  filter(X3 == "Trafford") %>%
  select(area_code = X4, area_name = X5, group = `Age 0-18`) %>%
  left_join(., pop, by = "area_code") %>%
  group_by(area_code, area_name) %>%
  summarise(value = round((group/total)*100,1)) %>%
  mutate(period = "2017",
         indicator = "Percentage of dependent children (0-18) in out-of-work households",
         measure = "Percentage",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/children_in_out_of_work_households.csv")
