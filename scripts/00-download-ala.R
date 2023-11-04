library(galah) # API to ALA
library(lubridate)
library(tidyverse)
library(rnoaa)
library(here)

id <- galah_identify("koala")

galah_config(email = "alex.qin@sydney.edu.au")

koala <- atlas_occurrences(identify = id)
koala <- koala %>%
  mutate(
    year = year(eventDate),
    month = month(eventDate, label=TRUE, abbr=TRUE),
    wday = wday(eventDate, label=TRUE, abbr=TRUE, week_start = 1),
    hour = hour(eventDate),
    day = ymd(as.Date(eventDate))
  )


# Renaming column

koala <- koala %>%
  rename("decimalLatitude" = "LAT",
         "decimalLongitude" = "LON")

# Reordering by year
koala <- koala[, order(koala$year)]
