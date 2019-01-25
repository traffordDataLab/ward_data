# Health: Hospital stays for alcohol-related harm, 2011/12 to 2015/16 #

# Source: Public Health England, produced from ONS data Copyright 2017
# URL: http://www.localhealth.org.uk/
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("LocalHealth_All_indicators_Ward_data.csv") %>% 
  filter(`Parent Name` == "Trafford",
         `Indicator Name` == "Hospital stays for alcohol-related harm, standardised admission ratio") %>% 
  select(area_code = `Area Code`,
         area_name = `Area Name`,
         value = Value) %>% 
  mutate(period = "2011/12 to 2015/16",
         indicator = "Hospital stays for alcohol-related harm",
         measure = "SAR",
         unit = "Admissions",
         value = round(value, 1)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "hospital_admissions_alcohol.csv")



