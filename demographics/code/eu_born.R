# Demographics: Born in the EU (not UK), 2011 #

# Source: Table QS203EW, ONS 2011 Census
# URL: https://www.nomisweb.co.uk/census/2011/qs203ew
# Licence: Open Government Licence

df <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_524_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&cell=0,15&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,cell_name,measures_name,obs_value,obs_status_name") %>%
  select(area_code = GEOGRAPHY_CODE, area_name = GEOGRAPHY_NAME, type = CELL_NAME, n = OBS_VALUE) %>%
  mutate(type =
           factor(case_when(
             type == "All categories: Country of birth" ~ "Persons",
             type == "Europe: Other Europe: EU Countries: Total" ~ "EU_born"))) %>%
  group_by(area_code, area_name, type) %>%
  summarise(n = sum(n)) %>%
  spread(type, n) %>%
  mutate(value = round((EU_born/Persons)*100, 1),
         period = "2011",
         indicator = "EU born residents",
         measure = "Percentage",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/eu_born.csv")
