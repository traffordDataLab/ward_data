# Households with 3 or more cars #

# Source: TS045 - Car or van availability
# URL: https://www.nomisweb.co.uk/datasets/c2021ts045
# Licence: Open Government Licence

# OA to ward lookup #

# Source: ONS Open Geography Portal 
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0

# Best-fit lookup between LSOAs and wards

library("tidyverse")
library("jsonlite")

lookup <- fromJSON("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/OA21_WD23_LAD23_EW_LU/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=*&outSR=4326&f=json", flatten = TRUE) %>%   pluck("features") %>% 
  as_tibble() %>% 
  select(OA21CD = attributes.OA21CD, area_code = attributes.WD23CD, area_name = attributes.WD23NM)


df <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2063_1.data.csv?date=latest&geography=629174437...629175131,629304895...629304912,629315184...629315186,629315192...629315198,629315220,629315233,629315244,629315249,629315255,629315263,629315265,629315274,629315275,629315278,629315281,629315290,629315295,629315317,629315327&c2021_cars_5=0,4&measures=20100") %>%
  select(period = DATE_NAME,
         OA21CD = GEOGRAPHY_CODE,
         category = C2021_CARS_5_NAME,
         value = OBS_VALUE) %>%
  left_join(lookup, by = "OA21CD") %>%
  select(period,area_code, area_name, category, value) %>%
  group_by(period,area_code, area_name, category) %>%
  summarise(value = sum(value)) %>%
  mutate(Percentage = round(value *100/value[2],1)) %>%
  ungroup() %>%
  filter(category == "3 or more cars or vans in household") %>%
  mutate(indicator = "Households with 3 or more cars (from best-fit OAs)",
         measure = "Percentage",
         unit = "Households") %>%
  arrange(desc(measure)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value = Percentage)

write_csv(df, "../data/households_three_or_more_cars.csv")
