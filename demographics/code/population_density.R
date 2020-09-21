# Demographics: Population density per km sq, 2019 #

# Source: ONS 2019 Mid-Year Population Estimates
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(tidyverse) ; library(sf) ; library(lwgeom) ; library(units) ; library(readxl) 

codes <- fromJSON(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD19_LAD19_UK_LU/FeatureServer/0/query?where=LAD19NM%20like%20'%25", URLencode(toupper("Trafford"), reserved = TRUE), "%25'&outFields=WD19CD,LAD19NM&outSR=4326&f=json"), flatten = TRUE) %>% 
  pluck("features") %>% 
  as_tibble() %>% 
  distinct(attributes.WD19CD) %>% 
  pull(attributes.WD19CD) 

wards <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_December_2019_Boundaries_UK_BFC_v2/FeatureServer/0/query?where=", 
                        URLencode(paste0("wd19cd IN (", paste(shQuote(codes), collapse = ", "), ")")), 
                        "&outFields=wd19cd,wd19nm&outSR=4326&f=geojson")) %>%
  mutate(area = as.numeric(set_units(st_area(.), km^2))) %>%
  select(area_code = WD19CD, area)

url <- "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fpopulationandmigration%2fpopulationestimates%2fdatasets%2fwardlevelmidyearpopulationestimatesexperimental%2fmid2019sape22dt8a/sape22dt8amid2019ward2019on2019and2020lasyoaestimatesunformatted.zip"
download.file(url, dest = "sape22dt8amid2019ward2019on2019and2020lasyoaestimatesunformatted.zip")
unzip("sape22dt8amid2019ward2019on2019and2020lasyoaestimatesunformatted.zip", exdir = ".")
file.remove("sape22dt8amid2019ward2019on2019and2020lasyoaestimatesunformatted.zip")

df <- read_excel("SAPE22DT8a-mid-2019-ward-2019-on-2019 and 2020-LA-syoa-estimates-unformatted.xlsx", sheet = 4, skip = 4) %>%
  filter(`LA name (2019 boundaries)` == 'Trafford') %>%
  select(area_code = `Ward Code 1`,
         area_name = `Ward Name 1`,
         `All Ages`) %>%
  left_join(wards, by = "area_code") %>%
  mutate(value = round(`All Ages`/area, 1),
         period = as.Date("2019-06-30", format = '%Y-%m-%d'),
         indicator = "Population density per km sq",
         measure = "Density",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/population_density.csv")
