# Demographics: old-age dependency ratio, 2017 #

# Source: ONS 2017 Mid-Year Population Estimates
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(tidyverse) ; library(readxl)

url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2017sape20dt8/sape20dt8mid2017ward2017syoaestimatesunformatted1.zip"
download.file(url, dest = "sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")
unzip("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip", exdir = ".")
file.remove("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")

df <- read_excel("SAPE20DT8-mid-2017-ward-2017-syoa-estimates-unformatted.xls", sheet = 4, skip = 3) %>%
  filter(`Local Authority` == 'Trafford') %>%
  select(-c(`Local Authority`, `All Ages`)) %>%
  rename(area_code = `Ward Code 1`, area_name = `Ward Name 1`, `90` = `90+`) %>%
  select(area_code, area_name, everything()) %>%
  gather(age, n, -c(area_name, area_code)) %>%
  mutate(age = as.integer(age),
         ageband = cut(age,
                       breaks = c(16,65,120),
                       labels = c("working_age","state_pension_age"),
                       right = FALSE)) %>%
  filter(!is.na(ageband)) %>%
  group_by(area_code, area_name, ageband) %>%
  summarise(n = sum(n)) %>%
  select(area_code, area_name, ageband, n) %>%
  spread(ageband, n) %>%
  mutate(value = round((state_pension_age/working_age)*100, 1),
         period = as.Date("2017-06-30", format = '%Y-%m-%d'),
         indicator = "Old-age dependency ratio",
         measure = "ratio",
         unit = "persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/old_age_dependency_ratio.csv")  
