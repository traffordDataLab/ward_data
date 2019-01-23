# Deprivation: Children aged 0 to 15 living in income deprived families, 2015 #

# Source: English Indices of Deprivation 2015, MHCLG
# URL: https://www.gov.uk/government/statistics/english-indices-of-deprivation-2015
# Licence: Open Government Licence

# Average score calculated as per guidance in Appendix A
# https://www.gov.uk/government/uploads/system/uploads/attachment_data/file/464597/English_Indices_of_Deprivation_2015_-_Research_Report.pdf

library(tidyverse) ; library(readxl) ; library(stringi) ; library(forcats)

lookup <- read_csv("https://opendata.arcgis.com/datasets/500d4283cbe54e3fa7f358399ba3783e_0.csv") %>%
  filter(LAD17CD == "E08000009") %>%
  select(lsoa11cd = LSOA11CD, area_code = WD17CD, area_name = WD17NM)

imd <- read_csv("http://opendatacommunities.org/downloads/cube-table?uri=http%3A%2F%2Fopendatacommunities.org%2Fdata%2Fsocietal-wellbeing%2Fimd%2Findices") %>%
  select(lsoa11cd = FeatureCode, measure = Measurement, value = Value, index_domain = `Indices of Deprivation`) %>%
  mutate(index_domain = as.factor(stri_sub(index_domain, 4))) %>%
  filter(lsoa11cd %in% lookup$lsoa11cd,
         index_domain == "Income Deprivation Affecting Children Index (IDACI)",
         measure == "Score") %>%
  select(lsoa11cd, value)

# https://www.gov.uk/government/statistics/english-indices-of-deprivation-2015
population <- read_excel("File_6_ID_2015_Population_denominators.xlsx", sheet = 2) %>%
  select(lsoa11cd = `LSOA code (2011)`,
         pop = `Dependent Children aged 0-15: mid 2012 (excluding prisoners)`)

df <- lookup %>%
  left_join(., imd, by = "lsoa11cd") %>%
  left_join(., population, by = "lsoa11cd") %>%
  mutate(score = pop*value) %>%
  group_by(area_code, area_name) %>%
  summarise(total_score = sum(score),
            value = round(total_score/sum(pop), 3)) %>%
  mutate(period = "2015",
         indicator = "Children aged 0 to 15 living in income deprived families",
         measure = "Score",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/child_poverty.csv")
