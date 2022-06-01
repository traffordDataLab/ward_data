## Average broadband speed (Mbit/s), Sep 2019 ##

# Source: Connected Nations, Ofcom
# URL: https://www.ofcom.org.uk/research-and-data/multi-sector-research/infrastructure-research/connected-nations-2019/data-downloads
# Licence: Open Government Licence
# Method: Median of mean postcode centroid download speed.

library(tidyverse) ; library(jsonlite) ; library(sf)

# ONS Postcode Directory (Latest) Centroids ##
# Source: ONS Open Geography Portal
# Publisher URL: https://geoportal.statistics.gov.uk/datasets/ons-postcode-directory-august-2020
# Licence: Open Government Licence 3.0

postcodes <- read_csv("https://github.com/traffordDataLab/spatial_data/raw/master/postcodes/trafford_postcodes.csv") %>%
  select(postcode, ward_code, ward_name)

url <- "https://www.ofcom.org.uk/__data/assets/file/0028/229663/cn-2021-fixed-pc-performance.zip"
download.file(url, dest = "cn-2021-fixed-pc-performance.zip")
unzip("cn-2021-fixed-pc-performance.zip", exdir = ".")
file.remove("cn-2021-fixed-pc-performance.zip")

files = list.files("performance_postcode_files", pattern="*.csv")

df <- map_df(paste0("performance_postcode_files/",files), read_csv) %>%
  select (postcode_space,`Average download speed (Mbit/s)`) %>%
  left_join(postcodes, by=c("postcode_space" = "postcode")) %>%
  filter(!is.na(ward_name)) %>%
  group_by(ward_code, ward_name) %>%
  summarize(value = round(median(`Average download speed (Mbit/s)`, na.rm = TRUE), 1)) %>%
  mutate(period = "2021-05",
         indicator = "Average download speed",
         measure = "Median",
         unit = "Mbps") %>%
  select(area_code = ward_code, area_name = ward_name, indicator, period, measure, unit, value)

write_csv(df, "../data/average_broadband_speed.csv")
