# Demographics: Population density per km sq, 2020 #

# Source: ONS 2020 Mid-Year Population Estimates
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(tidyverse) ; library(sf) ; library(lwgeom) ; library(units) ; library(readxl) ; library(jsonlite)

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

df <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2010_1.data.csv?geography=1656750701...1656750715,1656750717,1656750716,1656750718...1656750721&date=latest&gender=0&c_age=200&measures=20100") %>%
  select(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         `All Ages` = OBS_VALUE) %>%
  left_join(wards, by = "area_code") %>%
  mutate(value = round(`All Ages`/area, 1),
         period = as.Date("2020-06-30", format = '%Y-%m-%d'),
         indicator = "Population density per km sq",
         measure = "Density",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/population_density.csv")
