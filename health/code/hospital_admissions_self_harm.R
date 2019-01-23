# Health: Hospital admissions for self-harm, 2010/11 - 2014/15 #

# Source: Hospital Episode Statistics
# URL: https://fingertips.phe.org.uk/
# Licence: Open Government Licence

library(tidyverse) ; library(fingertipsR)

df <- fingertips_data(IndicatorID = 92584, AreaTypeID = 8) %>%
  filter(ParentName == "Trafford") %>%
  select(area_code = AreaCode,
         area_name = AreaName,
         value = Value) %>%
  mutate(period = "2010/11 to 2014/15",
         indicator = "Hospital admissions for self-harm",
         measure = "Standardised Admissions Ratio",
         unit = "Admissions") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/hospital_admissions_self_harm.csv")  
