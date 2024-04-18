# Demographics: Population density per km sq, 2022 #

# Source: Mid-year estimates 2022. Ward-level population estimates (official statistics in development
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(httr) ; library(readxl) ; library(tidyverse)
library(sf) ; library(jsonlite)

# Ward areas km2#

# Source: ONS Open Geography Portal 
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0


codes <- fromJSON(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD23_LAD23_UK_LU_DEC/FeatureServer/0/query?where=LAD23NM%20%3D%20'", URLencode(toupper("Trafford"), reserved = TRUE), "'&outFields=WD23CD,WD23NM,LAD23CD,LAD23NM&outSR=4326&f=json"), flatten = TRUE) %>% 
  pluck("features") %>% 
  as_tibble() %>% 
  distinct(attributes.WD23CD) %>% 
  pull(attributes.WD23CD) 


wards <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_December_2023_Boundaries_UK_BFE/FeatureServer/0/query?where=", 
                        URLencode(paste0("WD23CD IN (", paste(shQuote(codes), collapse = ", "), ")")), 
                        "&outFields=WD23CD,WD23NM,Shape__Area&outSR=4326&f=json")) %>%
  mutate(area = Shape__Area) %>%
  select(area_code = WD23CD, area)

tmp <- tempfile(fileext = ".xlsx")


GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2021andmid2022/sapewardstablefinal.xlsx",
    write_disk(tmp))

df <- read_xlsx(tmp, sheet = 8, skip = 3) %>%
  filter(`LAD 2023 Code` == "E08000009") %>%
  rename(area_code = `Ward 2023 Code`, area_name = `Ward 2023 Name`) %>%
  left_join(wards, by = "area_code") %>%
  mutate(period = as.Date("2022-06-30"),
         value = round((Total/area)*1000000, 0),
         indicator = "Population density per km sq",
         measure = "Density",
         unit = "persons/km^2") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/population_density.csv")
