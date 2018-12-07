# Demographics: Population change, 2007 to 2017 #

# Source: ONS 2007 and 2017 Mid-Year Population Estimates
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(tidyverse) ; library(readxl)

# mid-2007
url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2007quinarye_esfor2009wards/rft---mid-2007-quinary-estimates-for-2009-wards%20(1).zip"
download.file(url, dest = "rft---mid-2007-quinary-estimates-for-2009-wards%20(1).zip")
unzip("rft---mid-2007-quinary-estimates-for-2009-wards%20(1).zip", exdir = ".")
file.remove("rft---mid-2007-quinary-estimates-for-2009-wards%20(1).zip")

df_2007 <- read_excel("mid_2007_ward_2009_quinary.xls", sheet = 2, skip = 3) %>% 
  filter(`Local Authority` == 'Trafford') %>% 
  select(area_code = `New Code`, 
         area_name = `Ward Name`, 
         pop_07 = `All Ages`) %>% 
  mutate(pop_07 = as.integer(pop_07))

# mid-2017
url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2017sape20dt8/sape20dt8mid2017ward2017syoaestimatesunformatted1.zip"
download.file(url, dest = "sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")
unzip("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip", exdir = ".")
file.remove("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")

df_2017 <- read_excel("SAPE20DT8-mid-2017-ward-2017-syoa-estimates-unformatted.xls", 
                      sheet = 4, skip = 3) %>% 
  filter(`Local Authority` == 'Trafford') %>% 
  select(area_code = `Ward Code 1`, 
         pop_17 = `All Ages`)

# bind
df <- left_join(df_2007, df_2017, by = "area_code") %>% 
  mutate(value = round((pop_17-pop_07)/pop_07*100, 1),
         period = as.Date("2017-06-30", format = '%Y-%m-%d'),
         indicator = "Population change (2007 to 2017)",
         measure = "percent",
         unit = "persons") %>% 
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../population_change.csv")