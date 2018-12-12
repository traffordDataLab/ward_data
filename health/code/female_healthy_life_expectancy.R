## Health: Female healthy life expectancy, 2009-2013 ##

# Source: ONS
# URL: http://www.localhealth.org.uk/
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("https://www.ons.gov.uk/visualisations/dvc479/scatter-wards/data.csv", skip = 10) %>% 
  filter(`Local authority name` == "Trafford",
         Sex == "Female") %>% 
  select(area_code = `2011 Census Ward code`,
         area_name = `2011 Census Ward name`,
         value = `HLE (years)`) %>% 
  mutate(period = "2009-2013",
         indicator = "Female healthy life expectancy",
         measure = "count",
         unit = "persons") %>% 
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../female_healthy_life_expectancy.csv")
