## Health: Female life expectancy at birth, 2013-2017 ##

# Source: ONS
# URL: http://www.localhealth.org.uk/
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("life_exp.csv") %>% 
  filter(sex == "Female") %>%
  select(area_code, area_name, value = age) %>%
  mutate(period = "2013 to 2017",
         indicator = "Female life expectancy at birth",
         measure = "Years",
         unit = "Females") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/female_life_expectancy.csv")
