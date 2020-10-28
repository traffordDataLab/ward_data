# Economy: Number of jobs, 2018 #

# Source: Business Register and Employment Survey
# Publisher URL: https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/bulletins/businessregisterandemploymentsurveybresprovisionalresults/2018
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_190_1.data.csv?geography=E05000819...E05000839&date=latest&public_private=0&employment_status=1&measures=20100&select=date_name,geography_name,geography_code,public_private_name,employment_status_name,measures_name,obs_value,obs_status_name") %>%
  mutate(period = DATE_NAME,
         indicator = "Number of jobs",
         measure = "Count",
         unit = "Employees") %>%
  select(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         indicator, period, measure, unit,
         value = OBS_VALUE)

write_csv(df, "../data/number_of_jobs.csv")
