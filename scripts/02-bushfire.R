library(sf)
library(tidyverse)
library(absmapsdata)
library(lubridate)
load(here::here("data", "bioregion_koala.rda"))

path <- "data/Historical_Bushfire_Boundaries/Historical_Bushfire_Boundaries.shp"
bushfire_raw <- read_sf(path) |>
  st_transform(4326) |>
  st_set_crs(4326)

bushfire <- bushfire_raw |>
  filter(between(ignition_d, ymd("2019-11-01"), ymd("2020-3-01"))) |>
  arrange(ignition_d)
save(bushfire, file = here::here("data", "bushfire.rda"))

bushfire |> ggplot() + geom_sf()

bushfire2 <- bushfire |>
  sf::st_make_valid() |>
  rowwise() |>
  mutate(a = st_intersects(geometry, bioregion_koala))

bushfire3 <- bushfire2 |> filter(length(a) >= 1) |> ungroup()
bushfire_big2 <- bushfire3 |> arrange(-Shape__Are) |> head(2) |> dplyr::select(-a)
st_write(bushfire_big2, dsn = here::here("data/bushfire_big2/bushfire_big2.shp"))

bushfire3 |>
  ggplot() +
  geom_sf(data = aus_polys |> filter(row_number() %in% c(1, 3)),
          size= 0.7, fill = "grey", color = "grey90") +
  geom_sf(fill = "orange") +
  geom_sf(data=  bushfire_big2, fill = "red") +
  # geom_sf(data = bioregion_koala |> sf::st_cast("MULTILINESTRING"), #fill = "grey",
  #         color = "black", size = 0.7) +
  coord_sf(xlim = c(150, 155), ylim = c(-33, -26)) +
  theme_bw()

dt <- koala |>
  filter(LAT < 0) |>
  sf::st_as_sf(coords = c("LON", "LAT"), crs = 4326) |>
  st_filter(bushfire_big2)
