# Demographics: Median age, 2017 #

# Source: ONS 2017 Mid-Year Population Estimates
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(tidyverse) ; library(readxl)

url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2017sape20dt8/sape20dt8mid2017ward2017syoaestimatesunformatted1.zip"
download.file(url, dest = "sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")
unzip("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip", exdir = ".")
file.remove("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")

df <- read_excel("SAPE20DT8-mid-2017-ward-2017-syoa-estimates-unformatted.xls",
                 sheet = 4, skip = 3) %>%
  filter(`Local Authority` == 'Trafford') %>%
  rename(`90` = `90+`) %>%
  select(area_code = `Ward Code 1`, area_name = `Ward Name 1`, everything(), -`Local Authority`, -`All Ages`) %>%
  gather(age, n, -area_code, -area_name) %>%
  mutate(age = as.integer(age)) %>%
  group_by(area_code, area_name, age) %>%
  summarise(n = sum(n)) %>%
  summarise(value = age[max(which(cumsum(n)/sum(n) <= 0.5))]) %>%
  mutate(period = as.Date("2017-06-30", format = '%Y-%m-%d'),
         indicator = "Median age",
         measure = "median",
         unit = "persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/median_age.csv")
