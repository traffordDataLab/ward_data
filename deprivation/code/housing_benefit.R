# Deprivation: Housing benefit, August 2018 #

# Source: Department for Work and Pensions
# URL: https://stat-xplore.dwp.gov.uk
# Licence: Open Government Licence
# Method: (Claimants/Households)*100 in best-fit wards

library(tidyverse) ; library(readxl)

lookup <- read_csv("https://opendata.arcgis.com/datasets/500d4283cbe54e3fa7f358399ba3783e_0.csv") %>%
  filter(LAD17CD == "E08000009") %>%
  select(lsoa11nm = LSOA11NM, area_code = WD17CD, area_name = WD17NM)

households <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_618_1.data.csv?date=latest&geography=1249908541...1249908544,1249908617,1249908620,1249908548...1249908551,1249908553,1249908573,1249908618,1249908619,1249908621,1249908545...1249908547,1249908577,1249908578,1249908554...1249908556,1249908560,1249908563,1249908587,1249908589,1249908591,1249908614,1249908615,1249908557...1249908559,1249908562,1249908564,1249908588,1249908590,1249908611,1249908616,1249908630...1249908634,1249908552,1249908561,1249908565,1249908629,1249908635,1249908574...1249908576,1249908612,1249908613,1249908579,1249908581,1249908582,1249908586,1249908597,1249908598,1249908601...1249908603,1249908530,1249908531,1249908596,1249908606,1249908610,1249908529,1249908592...1249908595,1249908580,1249908583...1249908585,1249908604,1249908536...1249908540,1249908534,1249908605,1249908607...1249908609,1249908523,1249908524,1249908527,1249908599,1249908600,1249908522,1249908526,1249908528,1249908532,1249908535,1249908533,1249908622,1249908627,1249908628,1249908642,1249908636,1249908638...1249908640,1249908643,1249908525,1249908623,1249908624,1249908637,1249908641,1249908510,1249908512,1249908521,1249908625,1249908626,1249908506...1249908508,1249908511,1249908519,1249908515,1249908516,1249908520,1249908571,1249908572,1249908509,1249908513,1249908514,1249908517,1249908518,1249908566...1249908570&rural_urban=0&cell=0&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,cell_name,measures_name,obs_value,obs_status_name") %>%
  select(lsoa11nm = GEOGRAPHY_NAME,
         households = OBS_VALUE)

claimants <- read_excel("table_2018-12-17_09-31-14.xlsx", range = "B11:C149") %>%
  select(lsoa11nm = 1,
         claimants = 2) %>%
  mutate(claimants = replace(claimants, claimants == "..", 0),
         claimants = as.integer(claimants))

df <- left_join(lookup, claimants, by = "lsoa11nm") %>%
  left_join(., households, by = "lsoa11nm") %>%
  group_by(area_code, area_name) %>%
  summarise(total_claimants = sum(claimants),
            value = round(total_claimants/sum(households)*100, 1)) %>%
  mutate(period = "2018-08",
         indicator = "Housing benefits",
         measure = "Percentage",
         unit = "Households") %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/housing_benefit.csv")
