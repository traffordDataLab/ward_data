# Transport: Private transport to work, 2011 #

# Source: Table QS701EW, ONS 2011 Census
# URL: https://www.nomisweb.co.uk/census/2011/qs701ew
# Licence: Open Government Licence
# Method: (Car OR motorbike OR taxi) / All usual residents aged 16 to 74 in employment)*100

employed <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_624_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&c_sex=0&cell=200&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,c_sex_name,cell_name,measures_name,obs_value,obs_status_name") %>%
  select(area_code = GEOGRAPHY_CODE, employed = OBS_VALUE)

df <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_568_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&cell=5...7&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,cell_name,measures_name,obs_value,obs_status_name") %>%
  select(area_code = GEOGRAPHY_CODE, area_name = GEOGRAPHY_NAME, mode = CELL_NAME,  n = OBS_VALUE) %>%
  group_by(area_code, area_name) %>%
  summarise(private_transport_to_work = sum(n)) %>%
  left_join(., employed, by = "area_code") %>%
  mutate(value = round((private_transport_to_work / employed)*100, 1),
         period = "2011",
         indicator = "Private transport to work",
         measure = "Percentage",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/private_transport_to_work.csv")
