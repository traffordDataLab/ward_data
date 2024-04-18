# Demographics: Percentage of population aged 20-44 years, 2022 #

# Source: Mid-year estimates 2022. Ward-level population estimates (official statistics in development
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(httr) ; library(readxl) ; library(tidyverse)

tmp <- tempfile(fileext = ".xlsx")


GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2021andmid2022/sapewardstablefinal.xlsx",
    write_disk(tmp))

df <- read_xlsx(tmp, sheet = 8, skip = 3) %>%
  filter(`LAD 2023 Code` == "E08000009") %>%
  mutate(F20to44 = rowSums(pick(F20:F44), na.rm = TRUE), M20to44 = rowSums(pick(M20:M44), na.rm = TRUE)) %>%
  mutate(Count = F20to44+M20to44) %>%
  mutate(Percentage = round((Count/Total)*100,1)) %>%
  select(area_code = `Ward 2023 Code`, area_name = `Ward 2023 Name`, Percentage, Count) %>%
  pivot_longer(c(Percentage,Count), names_to = "measure", values_to = "value") %>%
  mutate(period = as.Date("2022-06-30"),
         indicator = "Population aged 20-44 years",
         unit = "Persons") %>%
  arrange(desc(measure)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)


write_csv(df, "../data/population_20-44_years.csv")
