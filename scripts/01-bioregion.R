library(sf)
library(tidyverse)
library(absmapsdata)

aus_polys <- ozmaps::abs_ste |>
  st_transform(4326) |>
  st_set_crs(4326) |>
  rmapshaper::ms_simplify(keep = 0.3) |>
  filter(NAME != "Other Territories")

aus_lines <- aus_polys |> sf::st_cast("MULTILINESTRING") |> rmapshaper::ms_simplify(keep = 0.3)

path <- "data/Interim_Biogeographic_Regionalisation_for_Australia_(IBRA)_Version_7_(Subregions)/IBRA7_subregions.shp"
bioregion_raw <- read_sf(path) |>
  st_transform(4326) |>
  st_set_crs(4326)

bioregion <- bioregion_raw |> rmapshaper::ms_simplify(keep = 0.1)
save(bioregion, file = here::here("data", "bioregion.rda"))
st_write(bioregion, dsn = here::here("data/bioregion/bioregion.shp"))

bioregion |>
  ggplot() +
  geom_sf()

bioregion_koala <- bioregion |>
  filter(!row_number() %in% c(326)) |>
  rowwise() |>
  # expensive step
  mutate(count = lengths(st_intersects(geometry, koala_bushfire))) |>
  filter(count > 200)
save(bioregion_koala, file = here::here("data", "bioregion_koala.rda"))

bioregion_koala |>
  ggplot() +
  geom_sf(data = aus_lines |> filter(row_number() %in% c(1, 3)),
          color = "grey", size = 0.5) +
  geom_sf(fill = "orange", color = "black", size = 0.7) +
  theme_void()

