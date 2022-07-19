# All licensed ultra low emission vehicles #

# Source: Department for Transport and Driver and Vehicle Licensing Agency
# Publisher URL: https://www.gov.uk/government/collections/vehicles-statistics
# Licence: Open Government Licence 3.0

# Wards data from agregaates of Best-Fit LSOAs

library(sf) ; library(tidyverse) ; library(janitor)

df <- read_csv("https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1090508/df_VEH0135.csv") %>%
  clean_names()
# LSOA to ward lookup #

# Source: ONS Open Geography Portal 
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0

# Best-fit lookup between LSOAs and wards
lookup <- read_csv("https://opendata.arcgis.com/datasets/8c05b84af48f4d25a2be35f1d984b883_0.csv") %>% 
  setNames(tolower(names(.))) %>%
  filter(lad18nm=="Trafford") %>%
  select(lsoa11cd, wd18cd, wd18nm)

#lsoa to ward

df_ward <- left_join(df %>% clean_names(), lookup, by = "lsoa11cd") %>%
  filter(!is.na(wd18cd)) %>%
  filter(fuel== "Total") %>%
  select(wd18cd, wd18nm, x2022_q1) %>%
  group_by(wd18cd, wd18nm) %>%
  summarise(value = sum(as.numeric (x2022_q1))) %>%
  mutate(indicator = "All licensed ultra low emission vehicles", period="2022-03",unit ="vehicles", measure = "Count") %>%
  select(area_code = wd18cd, area_name = wd18nm, indicator, period, measure, unit, value)

write_csv (df_ward, "../data/ultra_low_emission_vehicles.csv")
