# Deprivation: Housing benefit, May 2020 #

# Source: Department for Work and Pensions
# URL: https://www.gov.uk/government/statistics/housing-benefit-caseload-statistics
# Licence: Open Government Licence
# Method: (Claimants/Households)*100

library(tidyverse) ; library(httr) ; library(jsonlite) ; library(zoo)

#Denominator:Households
# Source: Table KS401EW, ONS 2011 Census
# URL: https://www.nomisweb.co.uk/census/2011/ks401ew
# Licence: Open Government Licence

households <- read_csv("http://www.nomisweb.co.uk/api/v01/dataset/NM_618_1.data.csv?date=latest&geography=1237320482...1237320496,1237320498,1237320497,1237320499...1237320502&rural_urban=0&cell=5&measures=20100&select=date_name,geography_name,geography_code,rural_urban_name,cell_name,measures_name,obs_value,obs_status_name") %>%
    select(area_code = GEOGRAPHY_CODE,
           households = OBS_VALUE)

api_key <- ""

path <- "https://stat-xplore.dwp.gov.uk/webapi/rest/v1/table"

query <- list(database = unbox("str:database:hb_new"),
              measures = "str:count:hb_new:V_F_HB_NEW",
              dimensions = c("str:field:hb_new:V_F_HB_NEW:WARD_CODE",
                             "str:field:hb_new:F_HB_NEW_DATE:NEW_DATE_NAME"
              ) %>% matrix(),
              recodes = list(
                `str:field:hb_new:V_F_HB_NEW:WARD_CODE` = list(
                  map = as.list(paste0("str:value:hb_new:V_F_HB_NEW:WARD_CODE:V_C_MASTERGEOG11_WARD_TO_LA:E0", seq(5000819, 5000839, 1)))),
                `str:field:hb_new:F_HB_NEW_DATE:NEW_DATE_NAME` = list(
                  map = as.list(paste0("str:value:hb_new:F_HB_NEW_DATE:NEW_DATE_NAME:C_HB_NEW_DATE:",c(202202))))
              )) %>% toJSON()

request <- POST(
  url = path,
  body = query,
  config = add_headers(APIKey = api_key),
  encode = "json")
response <- fromJSON(content(request, as = "text"), flatten = TRUE)
tabnames <- response$fields$items %>% map(~.$labels %>% unlist)
values <- response$cubes[[1]]$values
dimnames(values) <- tabnames
area_codes<-response$fields$items[[1]]$uris %>% unlist() %>% as_tibble() %>% set_names(c("area_code")) %>% mutate(area_code=str_sub(area_code,-9,-1))

df <- as.data.frame.table(values, stringsAsFactors = FALSE) %>%
  as_tibble() %>% 
  set_names(c(response$fields$label,"Count"))%>%
  cbind(area_codes) %>%
  mutate(period=format(as.yearmon(str_sub(Month,-7,-2), "%b-%y"),"%Y-%m")) %>%
  select(area_code,area_name=`National - Regional - LA - Ward`,period,Count) %>%
  left_join(households, by = "area_code") %>%
  mutate(Percent=round(Count*100/households,1),
         indicator = "Housing benefits") %>%
  gather(measure,value,Percent,Count) %>%
  mutate(unit=ifelse(measure=="Count","Persons","Households")) %>%
  arrange(area_name) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../data/housing_benefit.csv")
