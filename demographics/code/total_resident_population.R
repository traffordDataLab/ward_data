# Demographics: Total resident population, 2021 #

# Source: Census 2021
# URL: https://www.nomisweb.co.uk/datasets/c2021ts001
# Licence: Open Government Licence

library(tidyverse)
library(jsonlite)

# OA to ward lookup #

# Source: ONS Open Geography Portal 
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0

# Best-fit lookup between OAs and wards

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
  summarise(value = sum(value)) %>%
  mutate(indicator = "Total resident population (from best-fit OAs)",
         measure = "Count",
         unit = "Persons") %>%
 select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/total_resident_population.csv")
