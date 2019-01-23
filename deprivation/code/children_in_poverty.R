# Deprivation: Children in poverty (after housing costs), 2017 #

# Source: End Child Poverty
# URL: http://www.endchildpoverty.org.uk/poverty-in-your-area-2018/
# Licence:

library(tidyverse) ; library(readxl)

lookup <- read_csv("https://opendata.arcgis.com/datasets/046394602a6b415e9fe4039083ef300e_0.csv") %>%
  filter(LAD17CD == "E08000009") %>%
  select(area_code = WD17CD, area_name = WD17NM)

child_poverty <- read_excel("North-West_LA-and-ward-data-1.xlsx", sheet = 35, range = "A5:F26") %>%
  select(area_code = 1, value = 6) %>%
  mutate(value = round(value*100, 1))

df <- left_join(lookup, child_poverty, by = "area_code") %>%
  mutate(period = "2017-07 to 2017-09",
         indicator = "Children in poverty",
         measure = "Percentage",
         unit = "Children") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/children_in_poverty.csv")
