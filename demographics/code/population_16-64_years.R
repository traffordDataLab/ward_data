# Demographics: Percentage of population aged 16-64 years, 2019 #

# Source: ONS 2019 Mid-Year Population Estimates
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(tidyverse) ; library(readxl)

url <- "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fpopulationandmigration%2fpopulationestimates%2fdatasets%2fwardlevelmidyearpopulationestimatesexperimental%2fmid2019sape22dt8a/sape22dt8amid2019ward2019on2019and2020lasyoaestimatesunformatted.zip"
download.file(url, dest = "sape22dt8amid2019ward2019on2019and2020lasyoaestimatesunformatted.zip")
unzip("sape22dt8amid2019ward2019on2019and2020lasyoaestimatesunformatted.zip", exdir = ".")
file.remove("sape22dt8amid2019ward2019on2019and2020lasyoaestimatesunformatted.zip")

df <- read_excel("SAPE22DT8a-mid-2019-ward-2019-on-2019 and 2020-LA-syoa-estimates-unformatted.xlsx", sheet = 4, skip = 4) %>%
  filter(`LA name (2019 boundaries)` == 'Trafford') %>%
  mutate(Percentage = round(rowSums(select(., `16`:`64`)/`All Ages`)*100, 1),
         Count = rowSums(select(., `16`:`64`))) %>%
  select(area_code = `Ward Code 1`,
         area_name = `Ward Name 1`,
         Percentage,Count) %>%
  gather(measure, value, Percentage, Count) %>%
  mutate(period = as.Date("2019-06-30", format = '%Y-%m-%d'),
         indicator = "Population aged 16-64 years",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/population_16-64_years.csv")
