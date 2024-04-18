# Demographics: Percentage of population aged 0-15 years, 2022 #

# Source: Mid-year estimates 2022. Ward-level population estimates (official statistics in development
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(httr) ; library(readxl) ; library(tidyverse)

tmp <- tempfile(fileext = ".xlsx")


GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2021andmid2022/sapewardstablefinal.xlsx",
    write_disk(tmp))

df <- read_xlsx(tmp, sheet = 8, skip = 3) %>%
  filter(`LAD 2023 Code` == "E08000009") %>%
  mutate(F0to15 = rowSums(pick(F0:F15), na.rm = TRUE), M0to15 = rowSums(pick(M0:M15), na.rm = TRUE)) %>%
  mutate(Count = F0to15+M0to15) %>%
  mutate(Percentage = round((Count/Total)*100,1)) %>%
  select(area_code = `Ward 2023 Code`, area_name = `Ward 2023 Name`, Percentage, Count) %>%
  pivot_longer(c(Percentage,Count), names_to = "measure", values_to = "value") %>%
  mutate(period = as.Date("2022-06-30"),
         indicator = "Population aged 0-15 years",
         unit = "Persons") %>%
  arrange(desc(measure)) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)



write_csv(df, "../data/population_0-15_years.csv")  
