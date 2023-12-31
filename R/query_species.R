#' Query species from the Atlas of Living Australia
#'
#' The function queries species from the Atlas of Living Australia in a given
#'  time period. The function requires a registered email from the website.
#'
#' @param shape An sfc object.
#' @param year_vec A vector of years.
#' @export
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(sf)
#' d <- disaster |> filter(cat_name == "CAT131") |> disaster_as_shape()
#' query_species(d[1,])
#' }
query_species <- function(shape, year_vec = c(2019, 2020)){
  if (inherits(shape, "sf")) shape <- shape |> sf::st_as_sfc()
  if (!inherits(shape, "sfc")){
    cli::cli_abort("Please convert shape object to an sfc object.")
  }

  email <- getOption("galah_config")$user$email
  if (length(email) == 0){
    cli::cli_abort(
    "Please set the configuration with {.code galah_config(email = )}.")
  }

  res_occur_raw <- galah_call() |>
    galah::galah_filter(year == year_vec ) |>
    galah::galah_polygon(shape) |>
    galah::atlas_occurrences()

  res_occur <- res_occur_raw |>
    dplyr::arrange(eventDate) |>
    dplyr::filter(!is.na(eventDate))

  res_taxonomy_raw <- galah_call() |>
    galah::galah_filter(year == year_vec ) |>
    galah::galah_polygon(shape) |>
    galah::atlas_species()

  res_taxonomy <- res_taxonomy_raw |>
    dplyr::select(class:species) |>
    dplyr::filter(!is.na(class)) |>
    dplyr::filter(!is.na(order)) |>
    dplyr::filter(!is.na(genus)) |>
    dplyr::filter(!is.na(family))

  res <- list(occurrence = res_occur, taxonomy = res_taxonomy)
  class(res) <- c("galah_res", "list")
  return(res)
}

globalVariables(c("class", "order", "genus", "family", "galah_call",
                  "species", "year", "postcode_2021", "eventDate"))
