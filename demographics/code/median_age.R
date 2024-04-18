# Demographics: Median age, 2022 #

# Source: Mid-year estimates 2022. Ward-level population estimates (official statistics in development
# URL: https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental
# Licence: Open Government Licence

library(httr) ; library(readxl) ; library(tidyverse)

tmp <- tempfile(fileext = ".xlsx")


GET(url = "https://www.ons.gov.uk/file?uri=/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/wardlevelmidyearpopulationestimatesexperimental/mid2021andmid2022/sapewardstablefinal.xlsx",
    write_disk(tmp))

df <- read_xlsx(tmp, sheet = 8, skip = 3) %>%
  filter(`LAD 2023 Code` == "E08000009") %>%
  pivot_longer(Total:M90, names_to = "age", values_to = "value") %>%
  mutate(period = as.Date("2022-06-30"))%>%
  filter(age != "Total") %>%
  separate(age, into = c("sex", "age"), sep = 1) %>%
  mutate(sex = case_match(sex,"F"~"Females","M"~"Males")) %>%
  pivot_wider(names_from = "sex", values_from = value) %>%
  mutate(Persons = Females + Males) %>%
  mutate(age = as.integer(age)) %>%
  rename(area_code = `Ward 2023 Code`, area_name = `Ward 2023 Name`) %>%
  group_by(area_code, area_name, age) %>%
  summarise(Persons) %>%
  summarise(value = age[max(which(cumsum(Persons)/sum(Persons) <= 0.5))]) %>%
  mutate(period = as.Date("2022-06-30", format = '%Y-%m-%d'),
         indicator = "Median age",
         measure = "Median",
         unit = "Persons") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/median_age.csv")
