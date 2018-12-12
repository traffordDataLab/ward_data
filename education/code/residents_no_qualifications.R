# Education: Residents with no qualifications, 2011 #

# Source: Table KS501UK, ONS 2011 Census
# URL: https://www.nomisweb.co.uk/census/2011/ks501uk
# Licence: Open Government Licence

df <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_1510_1.data.csv?date=latest&geography=989862149...989862169&cell=1&measures=20301&select=date_name,geography_name,geography_code,cell_name,measures_name,obs_value,obs_status_name") %>% 
  select(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         value = OBS_VALUE) %>% 
  mutate(period = "2011",
         indicator = "Residents with no qualifications",
         measure = "percentage",
         unit = "persons") %>% 
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../residents_no_qualifications.csv")
