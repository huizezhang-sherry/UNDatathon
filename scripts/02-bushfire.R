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
  geom_sf(data = bioregion_koala |> sf::st_cast("MULTILINESTRING"), #fill = "grey",
           color = "black", size = 0.7) +
  coord_sf(xlim = c(150, 155), ylim = c(-33, -26)) +
  theme_bw()

koala_dt <- koala |>
  st_filter(bushfire_big2) |>
  dplyr::mutate(long = st_coordinates(geometry)[,1],
                lat =  st_coordinates(geometry)[,2]) |>
  as_tibble() |>
  mutate(region = ifelse(lat < - 29.5, "liberation_trail", "Myall Creek Road"))

koala_dt |> filter(year > 2015) |>
  ggplot() +
  geom_sf(data = bushfire_big2, fill = "red") +
  geom_point(aes(x = long, y = lat)) +
  facet_wrap(~year, nrow = 2)

library(tsibble)
kl_count <- koala_dt |>
  filter(between(year, 2010, 2022)) |>
  count(region, year, month)

kl_count |>
  mutate(ym = tsibble::make_yearmonth(year = year, month = month)) |>
  ggplot(aes(x = ym, y = n, group = region)) +
  geom_line() +
  scale_x_yearmonth(date_labels = "%y %b", date_breaks = "6 month")

kl_count |>
  ggplot(aes(x = as.factor(month),  y = n, color = region,
             group = interaction(as.factor(year), region))) +
  geom_line() +
  facet_wrap(~year, ncol = 3)

