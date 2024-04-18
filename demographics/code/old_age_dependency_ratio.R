# Demographics: old-age dependency ratio, 2022#

# Source: Mid-year estimates 2022. Ward-level population estimates (official statistics in development
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(httr) ; library(readxl) ; library(tidyverse)

tmp <- tempfile(fileext = ".xlsx")


GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2021andmid2022/sapewardstablefinal.xlsx",
    write_disk(tmp))

df1 <- read_xlsx(tmp, sheet = 8, skip = 3) %>%
  filter(`LAD 2023 Code` == "E08000009") %>%
  mutate(F16to64 = rowSums(pick(F16:F64), na.rm = TRUE), M16to64 = rowSums(pick(M16:M64), na.rm = TRUE)) %>%
  mutate(Count1664 = F16to64+M16to64) %>%
  select(area_code = `Ward 2023 Code`, area_name = `Ward 2023 Name`, Count1664)

df2 <- read_xlsx(tmp, sheet = 8, skip = 3) %>%
  filter(`LAD 2023 Code` == "E08000009") %>%
  mutate(F65p = rowSums(pick(F65:F90), na.rm = TRUE), M65p = rowSums(pick(M65:M90), na.rm = TRUE)) %>%
  mutate(Count65p = F65p +M65p) %>%
  select(area_code = `Ward 2023 Code`, area_name = `Ward 2023 Name`, Count65p)

df <- left_join(df1,df2, by = c("area_code", "area_name")) %>%
  mutate(value = round((Count65p/Count1664)*100, 1),
         period = as.Date("2022-06-30"),
         indicator = "Old-age dependency ratio",
         measure = "Ratio",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/old_age_dependency_ratio.csv")  
