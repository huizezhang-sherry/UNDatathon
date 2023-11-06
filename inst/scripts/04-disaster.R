# https://insurancecouncil.com.au/industry-members/data-hub/
library(absmapsdata)
library(tidyverse)
library(sf)
library(vegan)

st_write(postcode, dsn = here::here("data/postcode/postcode.shp"))

disaster_raw <- readxl::read_xlsx(
  here::here("data/ICA-Historical-Normalised-Catastrophe-October-2023.xlsx"), skip = 9)
disaster <- disaster_raw %>%
  separate_longer_delim(cols = Postcode, delim = ",") |>
  filter(!is.na(Postcode)) |>
  mutate(Postcode = as.numeric(Postcode))
write_csv(disaster, here::here("data/disaster.csv"))

unique(disaster$CAT_Name)
range(disaster$CAT_Event_Start)
range(disaster$CAT_Event_Finish)

perth <- disaster |> filter(CAT_Name == "CAT141")

perth_region <- postcode_raw |> filter(postcode_2021 %in% perth$Postcode) |>
  filter(postcode_2021 != 6082)
perth_region |>
  ggplot() +
  geom_sf()

qld_bushfire <- disaster |>
  filter(cat_event_name == "2019/20 Bushfires (NSW,QLD,SA,VIC)") |>
  filter(between(postcode, 1000, 2599))

qld_bushfire_rg <- aus_postcode |> filter(postcode_2021 %in% qld_bushfire$postcode) |>
  filter(cent_lat > -33.8)


library(galah)
poly <- qld_bushfire_rg$geometry[[1]] |> sf::st_union() |> sf::st_bbox() |> sf::st_as_sfc()
poly <- bushfire_big2[1, ] |> rmapshaper::ms_simplify(keep = 0.1)
# poly <-  bioregion_koala |>
#   filter(OBJECTID < 300) |>
#   sf::st_union() |>
#   rmapshaper::ms_simplify(keep = 0.05)
perth_ala <- galah_call() |>
  galah_filter() |>
  galah_polygon(poly) |>
  atlas_occurrences()

perth_species <- galah_call() |>
  galah_filter(year >= 2019, year <= 2020 ) |>
  galah_polygon(poly) |>
  atlas_species()

perth_species3 <- perth_species |>
  filter(!is.na(class)) |>
  filter(!is.na(order)) |>
  filter(!is.na(genus)) |>
  filter(!is.na(family))

calc_idx <- function(obs, tax){
  # bad_names <- setdiff(unique(obs$scientificName), tax$species)
  # bad_names2 <- setdiff(tax$species, unique(obs$scientificName))
  #
  # perth_species2 <- tax |>
  #   filter(!species %in% bad_names2) |>
  #   select(class:species) |>
  #   as.data.frame()
  #
  # tax_res <- taxa2dist(perth_species2, varstep=TRUE)
  #
  perth_ala2 <- obs |>
    filter(!scientificName %in% bad_names)|>
    count(scientificName) |>
    pivot_wider(names_from = scientificName, values_from = n) |>
    as.data.frame()
  #
  # mod <- taxondive(perth_ala2, tax_res)


  idx_shannon <- diversity(perth_ala2, "shannon")
  idx_simpson <- diversity(perth_ala2, "simpson")
  tibble(shannon = idx_shannon, simpson = idx_simpson,
         #cw_diversity = mod$D, cw_distinctness = mod$Dstar
         )

}

library(tsibble)
time <- seq(yearmonth("2015 Jan"), yearmonth("2020 Dec"), 1)
res_dt <- map(time, function(x){
  perth_ala |>
    arrange(eventDate) |>
    mutate(ym = yearmonth(eventDate)) |>
    filter(between(ym, x-3, x + 3))
})

res <- res_dt |>
  map_dfr(~calc_idx(.x, perth_species3), .id = "ym") |>
  mutate(ym = seq(yearmonth("2015 Jan"), yearmonth("2020 Dec"), 1))

res |>
  pivot_longer(cols = -ym, names_to = "idx", values_to = "value") |>
  ggplot(aes(x = ym, y = value, group = idx)) +
  geom_line() +
  facet_wrap(vars(idx), ncol = 1, scales = "free")

