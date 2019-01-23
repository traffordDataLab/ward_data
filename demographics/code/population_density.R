# Demographics: Population density per km sq, 2017 #

# Source: ONS 2017 Mid-Year Population Estimates
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(tidyverse) ; library(sf) ; library(units) ; library(readxl)

sf <- st_read("https://opendata.arcgis.com/datasets/07194e4507ae491488471c84b23a90f2_0.geojson") %>%
  filter(wd17cd %in% paste0("E0", seq(5000819, 5000839, 1))) %>%
  mutate(area = as.numeric(set_units(st_area(.), km^2))) %>%
  select(area_code = wd17cd, area)

url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2017sape20dt8/sape20dt8mid2017ward2017syoaestimatesunformatted1.zip"
download.file(url, dest = "sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")
unzip("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip", exdir = ".")
file.remove("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")

df <- read_excel("SAPE20DT8-mid-2017-ward-2017-syoa-estimates-unformatted.xls",
                 sheet = 4, skip = 3) %>%
  filter(`Local Authority` == 'Trafford') %>%
  select(area_code = `Ward Code 1`,
         area_name = `Ward Name 1`,
         `All Ages`) %>%
  left_join(sf, by = "area_code") %>%
  mutate(value = round(`All Ages`/area, 1),
         period = as.Date("2017-06-30", format = '%Y-%m-%d'),
         indicator = "Population density per km sq",
         measure = "Density",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/population_density.csv")
