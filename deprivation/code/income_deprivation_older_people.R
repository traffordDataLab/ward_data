# Deprivation: Adults aged 60 or over living in income deprived households, 2015 #

# Source: Income Deprivation Affecting Older People Index (IDAOPI), English Indices of Deprivation 2015, MHCLG
# URL: https://www.gov.uk/government/statistics/english-indices-of-deprivation-2015
# Licence: Open Government Licence

# MHCLG does not publish the Indices of Deprivation at ward level. 
# Ward level data derive from Public Health England.

library(tidyverse) ; library(fingertipsR)

# select_indicators()
df <- fingertips_data(IndicatorID = 340, AreaTypeID = 8) %>% 
  filter(ParentName == "Trafford") %>% 
  select(area_code = AreaCode,
         area_name = AreaName,
         value = Value) %>% 
  mutate(period = "2015",
         indicator = "Adults aged 60 or over living in income deprived households",
         measure = "Percentage",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/income_deprivation_older_people.csv")
