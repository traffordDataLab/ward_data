## Average broadband speed (Mbit/s), May 2022 ##

# Source: Connected Nations, Ofcom
# URL: https://www.ofcom.org.uk/research-and-data/multi-sector-research/infrastructure-research/connected-nations-2022/data
# Licence: Open Government Licence
# Method: Median of mean postcode centroid download speed.

library(tidyverse) ; library(jsonlite) ; library(sf)

# ONS Postcode Directory (Latest) Centroids ##
# Source: ONS Open Geography Portal
# Publisher URL: https://geoportal.statistics.gov.uk/datasets/ons-postcode-directory-may-2023
# Licence: Open Government Licence 3.0

postcodes <- read_csv("https://github.com/traffordDataLab/spatial_data/raw/master/postcodes/trafford_postcodes.csv") %>%
  select(postcode, ward_code, ward_name)

url <- "https://www.ofcom.org.uk/__data/assets/file/0029/249554/202205_fixed_pc_performance_r02.zip"
download.file(url, dest = "202205_fixed_pc_performance_r02.zip")
unzip("202205_fixed_pc_performance_r02.zip", exdir = ".")
file.remove("202205_fixed_pc_performance_r02.zip")

files = list.files(".", pattern="*.csv")

df <- map_df(files, read_csv) %>%
  select (postcode_space,`Average download speed (Mbit/s)`) %>%
  left_join(postcodes, by=c("postcode_space" = "postcode")) %>%
  filter(!is.na(ward_name)) %>%
  group_by(ward_code, ward_name) %>%
  summarize(value = round(median(`Average download speed (Mbit/s)`, na.rm = TRUE), 1)) %>%
  mutate(period = "2022-05",
         indicator = "Average download speed (median of available postcodes)",
         measure = "Median",
         unit = "Mbps") %>%
  select(area_code = ward_code, area_name = ward_name, indicator, period, measure, unit, value)

write_csv(df, "../data/average_broadband_speed.csv")
