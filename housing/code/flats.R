# Housing: Flat, maisonette or apartment, 2011 #

# Source: Table KS401EW, ONS 2011 Census
# URL: https://www.nomisweb.co.uk/census/2011/ks401ew
# Licence: Open Government Licence

df <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_618_1.data.csv?date=latest&geography=E05000819...E05000839&rural_urban=0&cell=4,10...12&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,cell_name,measures_name,obs_value,obs_status_name") %>%
  select(area_code = GEOGRAPHY_CODE, area_name = GEOGRAPHY_NAME, type = CELL_NAME, n = OBS_VALUE) %>%
  mutate(type =
           factor(case_when(
             type == "All categories: Household spaces" ~ "Households",
             type %in% c("Flat, maisonette or apartment: Purpose-built block of flats or tenement",
                         "Flat, maisonette or apartment: Part of a converted or shared house (including bed-sits)",
                         "Flat, maisonette or apartment: In a commercial building") ~ "Flat"))) %>%
  group_by(area_code, area_name, type) %>%
  summarise(n = sum(n)) %>%
  spread(type, n) %>%
  mutate(value = round((Flat/Households)*100, 1),
         period = "2011",
         indicator = "Flat, maisonette or apartment",
         measure = "Percentage",
         unit = "Households") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/flats.csv")
