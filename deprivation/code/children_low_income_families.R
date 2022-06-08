# Deprivation: Children in low income families, 2018/19 #

# Source: Department for Work & Pensions
# URL: https://www.gov.uk/government/publications/children-in-low-income-families-local-area-statistics-201415-to-201819/children-in-low-income-families-local-area-statistics-201415-to-201819
# Licence: Open Government Licence

library(tidyverse) ; library(httr) ; library(jsonlite)


api_key <- ""

path <- "https://stat-xplore.dwp.gov.uk/webapi/rest/v1/table"

query <- list(database = unbox("str:database:CILIF_REL"),
              measures = "str:count:CILIF_REL:V_F_CILIF_REL",
              dimensions = c("str:field:CILIF_REL:V_F_CILIF_REL:WARD_CODE",
                             "str:field:CILIF_REL:F_CILIF_DATE:DATE_NAME",
                             "str:field:CILIF_REL:V_F_CILIF_REL:CHILD_AGE"
                             ) %>% matrix(),
              recodes = list(
                `str:field:CILIF_REL:V_F_CILIF_REL:WARD_CODE` = list(
                  map = as.list(paste0("str:value:CILIF_REL:V_F_CILIF_REL:WARD_CODE:V_C_MASTERGEOG11_WARD_TO_LA_NI:E0", seq(5000819, 5000839, 1)))),
                `str:field:CILIF_REL:F_CILIF_DATE:DATE_NAME` = list(
                  map = as.list(paste0("str:value:CILIF_REL:F_CILIF_DATE:DATE_NAME:C_CILIF_YEAR:",c(2020)))),
                `str:field:CILIF_REL:V_F_CILIF_REL:CHILD_AGE` = list(
                  map = list(paste0("str:value:CILIF_REL:V_F_CILIF_REL:CHILD_AGE:C_CILIF_SINGLE_AGE:",c(0:15))))
              )) %>% toJSON()

request <- POST(
  url = path,
  body = query,
  config = add_headers(APIKey = api_key),
  encode = "json")
response <- fromJSON(content(request, as = "text"), flatten = TRUE)
tabnames <- response$fields$items %>% map(~.$labels %>% unlist)
values <- response$cubes[[1]]$values
dimnames(values) <- tabnames[1:2]

df <- as.data.frame.table(values, stringsAsFactors = FALSE) %>%
  as_tibble() %>% 
  set_names(c(response$fields$label,"Count")) %>%
  select(area_name=`National - Regional - LA - Wards`,period=Year,Count)

# Mid-2020 population estimates
# Source: Nomis / ONS
# URL: https://www.nomisweb.co.uk/datasets/pestsyoala

population_under16 <- read_csv("https://www.nomisweb.co.uk/api/v01/dataset/NM_2010_1.data.csv?geography=1660945005...1660945019,1660945021,1660945020,1660945022...1660945025&date=latest&gender=0&c_age=201&measures=20100") %>%
select(area_code = GEOGRAPHY_CODE, area_name = GEOGRAPHY_NAME, under16 = OBS_VALUE)

df <- left_join(df, population_under16, by = "area_name") %>%
  mutate(Percent=round(Count*100/under16,1),
         indicator = "Children in low income families (0-15 years)",
         unit = "Persons") %>%
  gather(measure,value,Percent,Count) %>%
  arrange(area_name) %>%
  select(area_code, area_name, indicator, period, measure, unit, value)


write_csv(df, "../data/children_low_income_families.csv")
