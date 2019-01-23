# Education: Residents with a higher education qualification, 2011 #

# Source: Table KS501EW, ONS 2011 Census
# URL: https://www.nomisweb.co.uk/census/2011/ks501ew
# Licence: Open Government Licence

df <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_623_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&cell=6&measures=20301&select=date_name,geography_name,geography_code,rural_urban_name,cell_name,measures_name,obs_value,obs_status_name") %>%
  select(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         value = OBS_VALUE) %>%
  mutate(period = "2011",
         indicator = "Residents with a higher education qualification",
         measure = "Percentage",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/residents_higher_education_qualification.csv")
