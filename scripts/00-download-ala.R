library(galah) # API to ALA
library(lubridate)
library(tidyverse)
library(rnoaa)
library(here)

id <- galah_identify("koala")

galah_config(email = "alex.qin@sydney.edu.au")

koala_raw <- atlas_occurrences(identify = id)
koala <- koala_raw %>%
  mutate(
    year = year(eventDate),
    month = month(eventDate),
    wday = wday(eventDate, week_start = 1),
    hour = hour(eventDate),
    day = day(eventDate)
  )

# Renaming column
koala <- koala %>%
  rename("LAT" = "decimalLatitude",
         "LON" = "decimalLongitude")

# Removing entries with NA in year
koala <- koala %>% drop_na(year)
koala <- koala[order(koala$year),]
koala <- koala |> filter(LAT < 0) |>
  sf::st_as_sf(coords = c("LON", "LAT"), crs = 4326)
save(koala, file = here::here("data", "koala.rda"))

nov2019 <- koala |> arrange(day) |> dplyr::filter(month == 11, year == 2019)
dec2019 <- koala |> arrange(day) |> dplyr::filter(month == 12, year == 2019)
jan2020 <- koala |> arrange(day) |> dplyr::filter(month == 1, year == 2020)
feb2020 <- koala |> arrange(day) |> dplyr::filter(month == 2, year == 2020)

koala_bushfire <- rbind(nov2019, dec2019, jan2020, feb2020) |>


koala_bushfire |>
  ggplot() +
  geom_sf(data = australia) +
  geom_point(aes(x = LON, y = LAT)) +
  facet_wrap(~month, nrow = 2, ncol = 2)




