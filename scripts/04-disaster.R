# https://insurancecouncil.com.au/industry-members/data-hub/
library(absmapsdata)
library(tidyverse)
library(sf)
postcode_raw <- strayr::read_absmap("postcode2021")
postcode <- postcode_raw |> rmapshaper::ms_simplify(keep = 0.01)
st_write(postcode, dsn = here::here("data/postcode/postcode.shp"))

disaster_raw <- readxl::read_xlsx(
  here::here("data/ICA-Historical-Normalised-Catastrophe-October-2023.xlsx"), skip = 9)
disaster <- disaster_raw %>%
  separate_longer_delim(cols = Postcode, delim = ",") |>
  filter(!is.na(Postcode))
write_csv(disaster, here::here("data/disaster.csv"))
write_
unique(disaster$CAT_Name)
range(disaster$CAT_Event_Start)
range(disaster$CAT_Event_Finish)
