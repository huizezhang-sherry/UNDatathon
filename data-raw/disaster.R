## code to prepare `DATASET` dataset goes here
postcode_raw <- strayr::read_absmap("postcode2021")
aus_postcode <- postcode_raw |> rmapshaper::ms_simplify(keep = 0.01)
usethis::use_data(aus_postcode, overwrite = TRUE, internal = TRUE)

disaster_raw <- readxl::read_xlsx(
  here::here("inst/ICA-Historical-Normalised-Catastrophe-October-2023.xlsx"),
  skip = 9)
disaster <- disaster_raw %>%
  janitor::clean_names() |>
  separate_longer_delim(cols = postcode, delim = ",") |>
  mutate(postcode = as.numeric(postcode)) |>
  filter(!is.na(postcode)) |>
  arrange(cat_event_start)
usethis::use_data(disaster, overwrite = TRUE)
