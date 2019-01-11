# Health: Deaths from cancer, 2011-2015 #

# Source: Local Health, Public Health England
# URL: http://www.localhealth.org.uk
# Licence: Open Government Licence

df <- read_csv("LocalHealth_All_indicators_Ward_data.csv") %>%
  filter(`Parent Name` == "Trafford",
         `Indicator Name` == "Deaths from all cancer, all ages, standardised mortality ratio") %>%
  select(area_code = `Area Code`,
         area_name = `Area Name`,
         value = Value) %>%
  mutate(period = "2011 to 2015",
         indicator = "Deaths from cancer",
         measure = "ratio",
         unit = "persons",
         value = round(value, 1)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/deaths_from_cancer.csv")
