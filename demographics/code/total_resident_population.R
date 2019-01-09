# Demographics: Total resident population, 2017 #

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
  mutate(period = as.Date("2017-06-30", format = '%Y-%m-%d'),
         indicator = "Total resident population",
         measure = "count",
         unit = "persons") %>%
  select(area_code = `Ward Code 1`,
         area_name = `Ward Name 1`,
         indicator, period, measure, unit,
         value = `All Ages`)

write_csv(df, "../data/total_resident_population.csv")
