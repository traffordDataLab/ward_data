## Deprivation: Fuel poverty, 2018 ##

# Source: Department for Business, Energy & Industrial Strategy
# Publisher URL: https://www.gov.uk/government/collections/fuel-poverty-sub-regional-statistics
# Licence: Open Government Licence

# NB uses best-fitting LSOAs

library(tidyverse) ; library(readxl)

lookup <- read_csv("https://opendata.arcgis.com/datasets/500d4283cbe54e3fa7f358399ba3783e_0.csv") %>%
  filter(LAD17CD == "E08000009") %>%
  select(LSOA11CD, area_code = WD17CD, area_name = WD17NM)

tmp <- tempfile(fileext = ".xlsx")
GET(url = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1081191/sub-regional-fuel-poverty-2022-tables.xlsx",
    write_disk(tmp))

df <- read_excel(tmp, sheet = 7, skip = 2) %>%
  filter(`LA Code` == "E08000009") %>%
  select(LSOA11CD = `LSOA Code`,
         fuel_poor = `Number of households in fuel poverty`,
         households = `Number of households`) %>%
  left_join(., lookup, by = "LSOA11CD") %>%
  group_by(area_code, area_name) %>%
  summarise(fuel_poor = sum(fuel_poor),
            households = sum(households),
            value = round((fuel_poor/households)*100, 1)) %>%
  mutate(period = "2020",
         indicator = "Fuel poverty",
         measure = "Percentage",
         unit = "Households") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/fuel_poverty.csv")
