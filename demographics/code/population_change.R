# Demographics: Population change, 2009 to 2019 #

# Source: ONS 2009 and 2019 Mid-Year Population Estimates
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(tidyverse) ; library(readxl)

# mid-2009
url <- "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fpopulationandmigration%2fpopulationestimates%2fdatasets%2fwardlevelmidyearpopulationestimatesexperimental%2fmid2009quinarye_esfor2009wards/mid-2009-quinary-estimates-for-2009-wards%20%281%29.zip"
download.file(url, dest = "mid-2009-quinary-estimates-for-2009-wards%20%281%29.zip")
unzip("mid-2009-quinary-estimates-for-2009-wards%20%281%29.zip", exdir = ".")
file.remove("mid-2009-quinary-estimates-for-2009-wards%20%281%29.zip")

df_2009 <- read_excel("mid-2009_ward_2009_quinary.xls", sheet = 2, skip = 3) %>%
  filter(`Local Authority` == 'Trafford') %>%
  select(area_code = `New Code`,
         area_name = `Ward Name`,
         pop_09 = `All Ages`) %>%
  mutate(pop_09 = as.integer(pop_09))

# mid-2019
url <- "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fpopulationandmigration%2fpopulationestimates%2fdatasets%2fwardlevelmidyearpopulationestimatesexperimental%2fmid2019sape22dt8a/sape22dt8amid2019ward2019on2019and2020lasyoaestimatesunformatted.zip"
download.file(url, dest = "sape22dt8amid2019ward2019on2019and2020lasyoaestimatesunformatted.zip")
unzip("sape22dt8amid2019ward2019on2019and2020lasyoaestimatesunformatted.zip", exdir = ".")
file.remove("sape22dt8amid2019ward2019on2019and2020lasyoaestimatesunformatted.zip")

df_2019 <- read_excel("SAPE22DT8a-mid-2019-ward-2019-on-2019 and 2020-LA-syoa-estimates-unformatted.xlsx", sheet = 4, skip = 4) %>%
  filter(`LA name (2019 boundaries)` == 'Trafford') %>%
  select(area_code = `Ward Code 1`,
         pop_19 = `All Ages`)

# bind
df <- left_join(df_2009, df_2019, by = "area_code") %>%
  mutate(value = round((pop_19-pop_09)/pop_09*100, 1),
         period = "2009 to 2019",
         indicator = "Population change (2009 to 2019)",
         measure = "Percentage",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/population_change.csv")
