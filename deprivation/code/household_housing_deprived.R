# Deprivation: Household deprivation - housing, 2021 #

# Source: Census 2021
# URL: https://www.ons.gov.uk/census/census2021dictionary/variablesbytopic/demographyvariablescensus2021/householddeprivedinthehousingdimension
# Licence: Open Government Licence

library(tidyverse)
library(jsonlite)
library(httr)

# OA to ward lookup #

# Source: ONS Open Geography Portal 
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0

# Best-fit lookup between OAs and wards

lookup <- fromJSON("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/OA21_WD23_LAD23_EW_LU/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=*&outSR=4326&f=json", flatten = TRUE) %>% 
  pluck("features") %>% 
  as_tibble() %>% 
  select(OA21CD = attributes.OA21CD, area_code = attributes.WD23CD, area_name = attributes.WD23NM)

df <- data.frame()

for(i in 1:21) {
  
  ward_oas <- lookup %>%
    filter(area_code == unique(lookup$area_code)[i])
  
  url <- paste0("https://api.beta.ons.gov.uk/v1/population-types/HH/census-observations?area-type=oa,",  URLencode(paste0(paste(ward_oas %>% pull(OA21CD), collapse = ","))), "&dimensions=hh_deprivation_housing")
  
  responseONS <- fromJSON(url) 
  
  data_raw <- enframe(unlist(responseONS))
  
  df_ward <- data.frame("area_name" = filter(data_raw, name == "observations.dimensions.option1") %>% pull(value), "category" = filter(data_raw, name == "observations.dimensions.option2") %>% pull(value), "value" = filter(data_raw, grepl("observations.observation", name, ignore.case=TRUE)) %>% pull(value))
  
  
  df <-  df %>%
    bind_rows(df_ward)
  
}

df_dep_hg<- df %>%
  mutate(value = as.numeric(value)) %>%
  left_join(lookup, by = c("area_name" = "OA21CD")) %>%
  select(area_code, area_name = area_name.y, category, value) %>%
  group_by(area_code, area_name, category) %>%
  summarise(value = sum(value)) %>%
  ungroup() %>%
  group_by(area_name, area_code) %>%
  mutate(Percentage = round(value *100/sum(value),1)) %>%
  filter(category == "Household is deprived in the housing dimension") %>%
  mutate(period = "2021",
         indicator = "Household is deprived in housing (from best-fit OAs)",
         measure = "Percentage",
         unit = "Households") %>%
  arrange(desc(measure)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value = Percentage)


write_csv(df_dep_hg, "../data/household_housing_deprived.csv")  
