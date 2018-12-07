# Demographics: Percentage of population aged 65 or more years, 2017 #

# Source: ONS
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates
# Licence: Open Government Licence

library(tidyverse) ; library(readxl)

url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2017sape20dt8/sape20dt8mid2017ward2017syoaestimatesunformatted1.zip"
download.file(url, dest = "sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")
unzip("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip", exdir = ".")
file.remove("sape20dt8mid2017ward2017syoaestimatesunformatted1.zip")

df <- read_excel("SAPE20DT8-mid-2017-ward-2017-syoa-estimates-unformatted.xls", 
                 sheet = 4, skip = 3) %>% 
  filter(`Local Authority` == 'Trafford') %>% 
  mutate(period = as.Date("2017-06-30", format = '%Y-%m-%d'),
         indicator = "Percentage of population aged 65 or more years",
         measure = "percent",
         unit = "persons",
         value = round(rowSums(select(., `65`:`90+`)/`All Ages`)*100, 1)) %>% 
  select(area_code = `Ward Code 1`, 
         area_name = `Ward Name 1`, 
         indicator, period, measure, unit, value)

write_csv(df, "../population_65_or_more_years.csv")
