# English Indices of Deprivation 2025 #
# Indices of Deprivation: Living Environment #

# Source: Ministry of Housing, Communities and Local Government
# Publisher URL: https://www.gov.uk/government/statistics/english-indices-of-deprivation-2025
# Licence: Open Government Licence 3.0

# MHCLG does not publish the Indices of Deprivation at ward level. 
# Ward level data produced according to the Appendix A. How to aggregate to different geographies of the English Indices of Deprivation 2019 Research report

library(sf) ; library(tidyverse) ; library(janitor) ; library(jsonlite)

la<-"Trafford"

#df <- read_csv("https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/833982/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators.csv") %>%
df <- read_csv("https://assets.publishing.service.gov.uk/media/691ded56d140bbbaa59a2a7d/File_7_IoD2025_All_Ranks_Scores_Deciles_Population_Denominators.csv") %>%

  clean_names() %>%
  filter(`local_authority_district_name_2024`==la) %>% 
  select(lsoa21cd = "lsoa_code_2021", score = "living_environment_score", population = "total_population_mid_2022") %>% 
  mutate(indicator="Indices of Deprivation: Living Environment")

# LSOA to ward lookup #

# Source: ONS Open Geography Portal 
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0

# Best-fit lookup between LSOAs and wards
#lookup <- read_csv("https://opendata.arcgis.com/datasets/8c05b84af48f4d25a2be35f1d984b883_0.csv") %>% 

lookup <- fromJSON(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/LSOA21_WD25_LAD25_EW_LU_v2/FeatureServer/0/query?where=LAD25NM%20%3D%20'", URLencode(toupper("Trafford"), reserved = TRUE), "'&outFields=LSOA21CD,LSOA21NM,WD25CD,WD25NM,LAD25CD,LAD25NM&outSR=4326&f=json"), flatten = TRUE) %>% 
  pluck("features") %>% 
  as_tibble() %>% 
  select(lsoa21cd = attributes.LSOA21CD, area_code = attributes.WD25CD, area_name = attributes.WD25NM)

#IoD lsoa to ward

iod_ward <- left_join(df, lookup, by = "lsoa21cd") %>%
  group_by(area_code, area_name, indicator) %>%
  summarise(ward_score=sum(score*population)/sum(population)) %>%
  ungroup %>%
  mutate(period="2025",unit ="Score", measure = "Weighted Score", value = round(ward_score, digits = 1)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv (iod_ward, "../data/environment_deprivation.csv")
