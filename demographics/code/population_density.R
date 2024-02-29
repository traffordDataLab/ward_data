# Demographics: Population density per km sq, 2021 #

# Source: Census 2021
# URL: https://www.nomisweb.co.uk/datasets/c2021ts001
# Licence: Open Government Licence

library(tidyverse) ; library(sf) ; library(jsonlite)

# OA to ward lookup #

# Source: ONS Open Geography Portal 
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0

# Best-fit lookup between OAs and wards


codes <- fromJSON(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD23_LAD23_UK_LU_DEC/FeatureServer/0/query?where=LAD23NM%20%3D%20'", URLencode(toupper("Trafford"), reserved = TRUE), "'&outFields=WD23CD,WD23NM,LAD23CD,LAD23NM&outSR=4326&f=json"), flatten = TRUE) %>% 
  pluck("features") %>% 
  as_tibble() %>% 
  distinct(attributes.WD23CD) %>% 
  pull(attributes.WD23CD) 


wards <- st_read(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/Wards_December_2023_Boundaries_UK_BFE/FeatureServer/0/query?where=", 
                        URLencode(paste0("WD23CD IN (", paste(shQuote(codes), collapse = ", "), ")")), 
                        "&outFields=WD23CD,WD23NM,Shape__Area&outSR=4326&f=json")) %>%
  #mutate(area = as.numeric(set_units(st_area(.), km^2))) %>%
  mutate(area = Shape__Area) %>%
  select(area_code = WD23CD, area)


lookup <- fromJSON("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/OA21_WD23_LAD23_EW_LU/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=*&outSR=4326&f=json", flatten = TRUE) %>% 
  pluck("features") %>% 
  as_tibble() %>% 
  select(OA21CD = attributes.OA21CD, area_code = attributes.WD23CD, area_name = attributes.WD23NM)


df <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2021_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_restype_3=0&measures=20100") %>%
  left_join(lookup, by = c("GEOGRAPHY_CODE" = "OA21CD")) %>%
  select(period = DATE_NAME,
         area_code, area_name,
         value = OBS_VALUE) %>%
  group_by(period, area_code, area_name) %>%
  summarise(pop = sum(value)) %>%
  ungroup() %>%
  left_join(wards, by = "area_code") %>%
  mutate(value = round((pop/area)*1000000, 0),
         indicator = "Population density per km sq",
         measure = "Density",
         unit = "persons/km^2") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/population_density.csv")
