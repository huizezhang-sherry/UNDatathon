#' Query species from the Atlas of Living Australia
#'
#' The function queries species from the Atlas of Living Australia ...
#'
#' instruction on need to config with email
#'
#' @param shape an sfc object
#' @param year_vec a vector of years
#' @export
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(sf)
#' d <- disaster |> filter(cat_name == "CAT131") |> disaster_as_shape()
#' query_species(d[1,])
#' }
query_species <- function(shape, year_vec = c(2019, 2020)){

  shape_size <- sf::st_coordinates(shape) |> nrow()

  if (shape_size >= 500){
    cli::cli_warn(
    "The shapefile is too large.
    Please simplify the object with {.code rmapshaper::ms_simplify()}.")
  }

  if (inherits(shape, "sf")) shape <- shape |> sf::st_as_sfc()
  if (!inherits(shape, "sfc")){
    cli::cli_abort("Please convert shape object to an sfc object.")
  }

  email <- getOption("galah_config")$user$email
  if (length(email) == 0){
    cli::cli_abort(
    "Please set the configuration with {.code galah_config(email = )}.")
  }

  res_occur <- galah_call() |>
    galah::galah_filter(year == year_vec ) |>
    galah::galah_polygon(shape) |>
    galah::atlas_occurrences()

  res_species_raw <- galah_call() |>
    galah::galah_filter(year == year_vec ) |>
    galah::galah_polygon(shape) |>
    galah::atlas_species()

  res_species <- res_species_raw |>
    dplyr::select(class:species) |>
    dplyr::filter(!is.na(class)) |>
    dplyr::filter(!is.na(order)) |>
    dplyr::filter(!is.na(genus)) |>
    dplyr::filter(!is.na(family))

  list(occurrence = res_occur, species = res_species)
}

globalVariables(c("class", "order", "genus", "family", "galah_call",
                  "species", "year", "postcode_2021"))
