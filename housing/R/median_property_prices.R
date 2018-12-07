# Housing: Median property prices, 2017 #

# Source: Land Registry
# Publisher URL: https://data.gov.uk/dataset/land-registry-monthly-price-paid-data
# Licence: Open Government Licence
# NB: excludes sales where propertyType is recorded as "otherPropertyType"

library(tidyverse) ; library(SPARQL) ; library(sf) 

postcodes <- read_csv("https://opendata.arcgis.com/datasets/75edec484c5d49bcadd4893c0ebca0ff_0.csv") %>%
  select(postcode = pcds, lat, long)

wards <- st_read("https://opendata.arcgis.com/datasets/07194e4507ae491488471c84b23a90f2_0.geojson") %>% 
  filter(wd17cd %in% paste0("E0", seq(5000819, 5000839, 1))) %>% 
  select(area_code = wd17cd, area_name = wd17nm) 

endpoint <- "http://landregistry.data.gov.uk/landregistry/query"
query <- paste0("
                PREFIX xsd:     <http://www.w3.org/2001/XMLSchema#>
                PREFIX rdf:     <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
                PREFIX rdfs:    <http://www.w3.org/2000/01/rdf-schema#>
                PREFIX owl:     <http://www.w3.org/2002/07/owl#>
                PREFIX skos:    <http://www.w3.org/2004/02/skos/core#>
                PREFIX lrppi:   <http://landregistry.data.gov.uk/def/ppi/>
                PREFIX lrcommon: <http://landregistry.data.gov.uk/def/common/>
                
                SELECT ?date ?paon ?saon ?street ?town ?district ?county ?postcode ?propertytype ?transactiontype ?amount
                WHERE {
                ?transx lrppi:pricePaid ?amount ;
                lrppi:transactionDate ?date ;
                lrppi:propertyAddress ?addr ;
                lrppi:transactionCategory ?transactiontype ;
                lrppi:propertyType ?propertytype .
                
                ?addr lrcommon:district 'TRAFFORD'^^xsd:string .
                
                FILTER ( ?date >= '2017-01-01'^^xsd:date )
                FILTER ( ?date <= '2017-12-31'^^xsd:date )
                FILTER ( ?propertytype != lrcommon:otherPropertyType )
                FILTER ( ?transactiontype != lrppi:additionalPricePaidTransaction )
                
                OPTIONAL {?addr lrcommon:paon ?paon .}
                OPTIONAL {?addr lrcommon:saon ?saon .}
                OPTIONAL {?addr lrcommon:street ?street .}
                OPTIONAL {?addr lrcommon:town ?town .}
                OPTIONAL {?addr lrcommon:district ?district .}
                OPTIONAL {?addr lrcommon:county ?county .}
                OPTIONAL {?addr lrcommon:postcode ?postcode .}
                }
                ORDER BY ?date
                ")

df <- SPARQL(endpoint,query)$results %>% 
  mutate(date = as.POSIXct(date, origin = '1970-01-01')) %>% 
  left_join(., postcodes, by = "postcode") %>%  
  filter(!is.na(long)) %>%
  st_as_sf(coords = c("long", "lat")) %>% 
  st_set_crs(4326) %>% 
  st_join(., wards, join = st_within, left = FALSE) %>% 
  st_set_geometry(value = NULL) %>% 
  group_by(area_code, area_name) %>% 
  summarise(value = as.integer(median(amount))) %>% 
  mutate(period = "2017",
         indicator = "Median property prices",
         measure = "median",
         unit = "housholds") %>% 
  select(area_code, area_name, indicator, period, measure, unit, value)

write_csv(df, "../median_property_prices.csv")
