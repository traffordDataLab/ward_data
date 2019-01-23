# Demographics: Non-white ethnic group, 2011 #

# Source: Table KS201EW, 2011 Census
# URL: https://www.nomisweb.co.uk/census/2011/KS201ew
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_608_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&cell=0,200,300,400,500&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,cell_name,measures_name,obs_value,obs_status_name") %>%
  select(area_code = GEOGRAPHY_CODE, area_name = GEOGRAPHY_NAME, group = CELL_NAME, n = OBS_VALUE) %>%
  mutate(group =
           factor(case_when(
             group == "All usual residents" ~ "Total residents",
             group %in% c("Asian/Asian British",
                         "Black/African/Caribbean/Black British",
                         "Mixed/multiple ethnic groups",
                         "Other ethnic group") ~ "BME"))) %>%
  group_by(area_code, area_name, group) %>%
  summarise(n = sum(n)) %>%
  spread(group, n)%>%
  mutate(value = round((BME/`Total residents`)*100, 1),
         period = "2011",
         indicator = "Non-white ethnic group",
         measure = "Percentage",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/bme.csv")
