# Health: Incidence of breast cancer, 2011-2015 #

# Source: Office for National Statistics
# URL: http://www.localhealth.org.uk
# Licence: Open Government Licence

df <- read_csv("LocalHealth_All_indicators_Ward_data.csv") %>% 
  filter(`Parent Name` == "Trafford",
         `Indicator Name` == "Incidence of breast cancer, standardised incidence ratio") %>%
  select(area_code = `Area Code`,
         area_name = `Area Name`,
         value = Value) %>% 
  mutate(period = "2011-2015",
         indicator = "Incidence of breast cancer",
         measure = "ratio",
         unit = "females",
         value = round(value, 1)) %>% 
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../breast_cancer.csv")
