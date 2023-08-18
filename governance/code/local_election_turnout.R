# Governance: Local elections turnout, 2023 #

# Source: Trafford Council
# URL: https://www.trafford.gov.uk/about-your-council/elections/results/2020-2029/2023-Local-election-results.aspx
# Licence:

library(tidyverse)

lookup_w_la <- fromJSON("https://services1.arcgis.com/ESMARspQHYMw9BZ9/arcgis/rest/services/WD23_LAD23_UK_LU/FeatureServer/0/query?where=LAD23NM%20%3D%20'TRAFFORD'&outFields=WD23CD,WD23NM,LAD23NM&outSR=4326&f=json", flatten = TRUE) %>% 
  pluck("features") %>% 
  as_tibble() %>% 
  select(area_code = attributes.WD23CD, area_name = attributes.WD23NM)


df <- read_csv("https://www.trafforddatalab.io/open_data/elections/trafford_council_election_results.csv") %>%
  filter(ElectionDate == "2023-05-04") %>%
  select(area_name = ElectoralAreaLabel, turnout = PercentageTurnout) %>%
  unique() %>%
  left_join(lookup_w_la, by = "area_name") %>%
  mutate(period = "2023",
         indicator = "Local election turnout",
         measure = "Percentage",
         unit = "Votes") %>%
  select(area_code, area_name, indicator, period, measure, unit, value = turnout)

write_csv(df, "../data/local_election_turnout.csv")
