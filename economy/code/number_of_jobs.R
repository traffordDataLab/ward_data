# Economy: Number of employees, 2020 #

# Source: Business Register and Employment Survey
# Publisher URL: https://www.ons.gov.uk/employmentandlabourmarket/peopleinwork/employmentandemployeetypes/bulletins/businessregisterandemploymentsurveybresprovisionalresults/provisionalresults2020
# Licence: Open Government Licence

library(tidyverse)

df <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_190_1.data.csv?geography=1656750701...1656750715,1656750717,1656750716,1656750718...1656750721&date=latest&public_private=0&employment_status=1&measures=20100") %>%
  mutate(period = DATE_NAME,
         indicator = "Number of employees",
         measure = "Count",
         unit = "Employees") %>%
  select(area_code = GEOGRAPHY_CODE,
         area_name = GEOGRAPHY_NAME,
         indicator, period, measure, unit,
         value = OBS_VALUE)

write_csv(df, "../data/number_of_jobs.csv")
