# Labour market: Professional occupations, 2011 #

# Source: Table DC6112EW, ONS 2011 Census
# URL: https://www.nomisweb.co.uk/census/2011/dc6112ew
# Licence: Open Government Licence
# Method: (Managers, directors and senior officials OR Professional occupations)/All usual residents aged 16 to 74 in employment)*100

lookup <- read_csv("https://www.trafforddatalab.io/spatial_data/lookups/administrative_lookup.csv") %>%
  filter(lad17nm == "Trafford") %>%
  select(area_code = wd17cd, area_name = wd17nm)

df <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_794_1.data.csv?date=latest&geography=1140857093...1140857113&c_sex=0&c_occpuk11_1=0,1,4&c_age=0&measures=20100&select=date_name,geography_name,geography_code,c_sex_name,c_occpuk11_1_name,c_age_name,measures_name,obs_value,obs_status_name") %>%
  select(area_name = GEOGRAPHY_NAME, type = C_OCCPUK11_1_NAME, n = OBS_VALUE) %>%
  mutate(type =
           factor(case_when(
             type == "All categories: Occupation" ~ "employed",
             type %in% c("1 : Managers, directors and senior officials",
                         "2 : Professional occupations") ~ "professionals"))) %>%
  group_by(area_name, type) %>%
  summarise(n = sum(n)) %>%
  spread(type, n) %>%
  mutate(value = round((professionals/employed)*100, 1),
         period = "2011",
         indicator = "Professional occupations",
         measure = "Percentage",
         unit = "Persons") %>%
  left_join(lookup, by = "area_name") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/professional_occupations.csv")
