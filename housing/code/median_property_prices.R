# Housing: Median property prices, June 2020 #

# Source: ONS
# Publisher URL: https://www.ons.gov.uk/peoplepopulationandcommunity/housing/datasets/medianpricepaidbywardhpssadataset37
# Licence: Open Government Licence

library(tidyverse) ; library(readxl) ; library(jsonlite)

url <- "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/housing/datasets/medianpricepaidbywardhpssadataset37/yearendingdecember2021/hpssadataset37medianpricepaidbyward.zip"
download.file(url, dest = "hpssadataset37medianpricepaidbyward.zip")
unzip("hpssadataset37medianpricepaidbyward.zip", exdir = ".")
file.remove("hpssadataset37medianpricepaidbyward.zip")

codes <- fromJSON(paste0("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD18_LAD18_UK_LU/FeatureServer/0/query?where=LAD18NM%20like%20'%25", URLencode(toupper("Trafford"), reserved = TRUE), "%25'&outFields=WD18CD,LAD18NM&outSR=4326&f=json"), flatten = TRUE) %>% 
  pluck("features") %>% 
  as_tibble() %>% 
  distinct(attributes.WD18CD) %>% 
  pull(attributes.WD18CD) 

df <- read_xls("HPSSA Dataset 37 - Median price paid by ward.xls", sheet = 6, skip = 5) %>% 
  select(area_name = `Ward name`, area_code = `Ward code`, value = `Year ending Dec 2021`) %>% 
  filter(area_code %in% codes) %>% 
  mutate(value = as.integer(value),
         period = "2021",
         indicator = "Median property prices",
         measure = "Median",
         unit = "Pounds") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/median_property_prices.csv")
