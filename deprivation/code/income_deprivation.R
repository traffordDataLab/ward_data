# English Indices of Deprivation 2019 #
# Indices of Deprivation: Income#

# Source: Ministry of Housing, Communities and Local Government
# Publisher URL: https://www.gov.uk/government/statistics/announcements/english-indices-of-deprivation-2019
# Licence: Open Government Licence 3.0

# MHCLG does not publish the Indices of Deprivation at ward level. 
# Ward level data produced according to the Appendix A. How to aggregate to different geographies of the English Indices of Deprivation 2019 Research report

library(sf) ; library(tidyverse) ; library(janitor)

la<-"Trafford"

df <- read_csv("https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/833982/File_7_-_All_IoD2019_Scores__Ranks__Deciles_and_Population_Denominators.csv") %>%
  clean_names() %>%
  filter(`local_authority_district_name_2019`==la) %>% 
  select(lsoa11cd = "lsoa_code_2011", score = "income_score_rate", population = "total_population_mid_2015_excluding_prisoners") %>% 
  mutate(indicator="Indices of Deprivation: Income")

# LSOA to ward lookup #

# Source: ONS Open Geography Portal 
# Publisher URL: http://geoportal.statistics.gov.uk/
# Licence: Open Government Licence 3.0

# Best-fit lookup between LSOAs and wards
lookup <- read_csv("https://opendata.arcgis.com/datasets/8c05b84af48f4d25a2be35f1d984b883_0.csv") %>% 
  setNames(tolower(names(.))) %>%
  filter(lad18nm==la) %>%
  select(lsoa11cd, wd18cd, wd18nm)

#IoD lsoa to ward

iod_ward <- left_join(df, lookup, by = "lsoa11cd") %>%
  group_by(wd18cd, wd18nm, indicator) %>%
  summarise(ward_score=sum(score*population)/sum(population)) %>%
  ungroup %>%
  mutate(period="2019",unit ="Persons", value = round(ward_score * 100, digits = 1), measure = "Percentage") %>%
  select(area_code = wd18cd, area_name = wd18nm, indicator, period, measure, unit, value)

write_csv (iod_ward, "../data/income_deprivation.csv")
