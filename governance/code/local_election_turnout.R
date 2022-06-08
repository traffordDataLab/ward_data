# Governance: Local elections turnout, 2022 #

# Source: Trafford Council
# URL: https://www.trafforddatalab.io/ward_data/governance/data/local_election_turnout.csv
# Licence:

library(tidyverse)

turnout <- read_csv("https://www.trafforddatalab.io/analysis/local_election/2022/data/local_election_turnout.csv") 

df <- turnout %>%
  filter(election_year == 2022) %>%
  mutate(indicator = "Local election turnout",
         measure = "Percentaage",
         unit = "Votes") %>%
  select(area_code = ward_code, area_name = ward_name, indicator, period = election_year, measure, unit, value = turnout)

write_csv(df, "../data/local_election_turnout.csv")
