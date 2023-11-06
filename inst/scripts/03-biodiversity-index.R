library(vegan)
library(tidyverse)
data(dune)
data(dune.taxon)
# Taxonomic distances from a classification table with variable step lengths.
taxdis <- taxa2dist(dune.taxon[, 1:3], varstep=TRUE)
plot(hclust(taxdis), hang = -1)
mod <- taxondive(dune, taxdis)


species_raw <- read_csv(here::here("data/Queensland_2018.csv"))
species <- species_raw |> arrange(eventDate) |> filter(eventDate == ymd("2018-01-01"))
species2 <- species |> sf::st_as_sf(coords = c("decimalLongitude", "decimalLatitude"), crs = 4326) |>
  st_filter(bioregion_koala[3,])
species_dt <- species2 |>
  sf::st_drop_geometry() |>
  filter(!is.na(species)) |>
  select(order, family, genus, species) |>
  distinct() |>
  as.data.frame()
rownames(species_dt) <- species_dt$species
tax <- taxa2dist(species_dt, varstep=TRUE)
plot(hclust(tax), hang = -1)
abun <- species2 |>
  sf::st_drop_geometry() |>
  filter(!is.na(species)) |>
  count(species) |>
  pivot_wider(names_from = species, values_from = n) |>
  as.data.frame()
mod <- taxondive(abun, tax)


disaster <- read_csv(here::here("data/disaster_dataframe.csv"))

disaster |>
  ggplot() +
  geom_point(aes(x = lon, y = lat))

