# Health: General Health - bad or very bad, 2011 #

# Source: Table QS302EW, ONS 2011 Census
# URL: https://www.nomisweb.co.uk/census/2011/qs302ew
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_531_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&c_health=0,4,5&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,c_health_name,measures_name,obs_value,obs_status_name") %>% spread(C_HEALTH_NAME, OBS_VALUE) %>%
  mutate(value = round((`Bad health`+`Very bad health`)/`All categories: General health`*100,1)) %>% 
  select(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         value) %>% 
  mutate(period = "2011",
         indicator = "People reporting their general health as bad or very bad",
         measure = "Percentage",
         unit = "Persons",
         value = round(value, 1)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "general_health_bad.csv")



