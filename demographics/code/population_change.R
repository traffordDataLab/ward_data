# Demographics: Population change, 2010 to 2020 #

# Source: ONS 2010 and 2020 Mid-Year Population Estimates
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(tidyverse) ; library(readxl)

# mid-2010
url <- "https://www.ons.gov.uk/file?uri=%2fpeoplepopulationandcommunity%2fpopulationandmigration%2fpopulationestimates%2fdatasets%2fwardlevelmidyearpopulationestimatesexperimental%2fmid2010basedon2010wards/rft---ward-level-mid-year-population-estimates-2010-based-on-2010-wards%20%281%29.zip"

download.file(url, dest = "rft---ward-level-mid-year-population-estimates-2010-based-on-2010-wards%20%281%29.zip")
unzip("rft---ward-level-mid-year-population-estimates-2010-based-on-2010-wards%20%281%29.zip", exdir = ".")
file.remove("rft---ward-level-mid-year-population-estimates-2010-based-on-2010-wards%20%281%29.zip")

df_2010 <- read_excel("mid_2010_ward_2010_quinary.xls", sheet = 2, skip = 3) %>%
  filter(`Local Authority` == 'Trafford') %>%
  select(area_code = `Ward Code`,
         area_name = `Ward Name`,
         pop_10 = `All Ages`) %>%
  mutate(pop_10 = as.integer(pop_10))

# mid-2020

df_2020 <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2010_1.data.csv?geography=1656750701...1656750715,1656750717,1656750716,1656750718...1656750721&date=latest&gender=0&c_age=200&measures=20100") %>%
  select(area_code = GEOGRAPHY_CODE,
         pop_20 = OBS_VALUE)

# bind
df <- left_join(df_2010, df_2020, by = "area_code") %>%
  mutate(value = round((pop_20-pop_10)/pop_10*100, 1),
         period = "2010 to 2020",
         indicator = "Population change (2010 to 2020)",
         measure = "Percentage",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/population_change.csv")
