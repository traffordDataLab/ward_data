## Health: Male healthy life expectancy, 2009-2013 ##

# Source: ONS
# URL: http://www.localhealth.org.uk/
# Licence: Open Government Licence

library(tidyverse)

lookup <- read_csv("https://www.trafforddatalab.io/spatial_data/lookups/administrative_lookup.csv") %>%
  filter(lad17nm == "Trafford") %>%
  select(area_code = wd17cd, area_name = wd17nm)

df <- read_csv("https://www.ons.gov.uk/visualisations/dvc479/scatter-wards/data.csv", skip = 10) %>%
  filter(`Local authority name` == "Trafford",
         Sex == "Male") %>%
  select(area_name = `2011 Census Ward name`,
         value = `HLE (years)`) %>%
  mutate(period = "2009 to 2013",
         indicator = "Male healthy life expectancy",
         measure = "Years",
         unit = "Males") %>%
  left_join(lookup, by = "area_name") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/male_healthy_life_expectancy.csv")
