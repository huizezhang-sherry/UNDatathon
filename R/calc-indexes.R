#' Calculate indexes from the biodiversity data
#'
#' The function calculates biodiversity indexes (Simpson's Diversity Index,
#' Shannon Diversity Index, and Clarke & Warwick's Distinctness and Diversity
#' Index) from the animal data queried from the Atlas of Living Australia
#'
#' @param data A \code{galah_res} object from  \code{query_species()}.
#' @param occurrence A dataframe of animal occurrence data, which can be
#'  individual occurrence count or occurrence count per species.
#' @param taxonomy A dataframe of animal taxonmy data.
#' @param is_count Indicator whether the animal occurrence data is recorded
#'  as occurrence count per species.
#' @param indexes The index(es) to compute: "shannon", "simpson" or "CW".
#' @export
#' @references https://www.ala.org.au/
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(sf)
#' d <- disaster |> filter(cat_name == "CAT131") |> disaster_as_shape()
#' s <- query_species(d[1,])
#' s |> calculate_idx()
#' }
calculate_idx <- function(data = NULL, occurrence = NULL, taxonomy = NULL,
                              is_count = FALSE,
                              indexes = c("shannon", "simpson", "CW")){

  indexes <-  lapply(indexes, function(i) match.arg(NULL, i)) |> unlist()

  if (!is.null(data) && !inherits(data, "galah_res")){
    cli::cli_abort(
    "The {.arg data} argument only accepts results of a {.field galah_res} object
    from {.code query_species()}.
    You can input separate occurrence and species data with {.arg occurrence = }
    and {.arg taxonomy = }.")
  }

  if ("CW" %in% indexes && is.null(taxonomy) && is.null(data)){
    cli::cli_abort(
      "Taxonomic information is required for CW index.
      Please supply it with argument {.arg taxonomy = } ")
  }

  if (!inherits(data, "galah_res") && is.null(occurrence)){
    cli::cli_abort(
    "Please input a {.field galah_res} object or occurrence data to compute the indexes.")
  }

  if (inherits(data, "galah_res")){
    occurrence <- data$occurrence
    taxonomy <- data$taxonomy
  }

  cw_res <- NULL
  if ("CW" %in% indexes){
    bad_names <- setdiff(unique(occurrence$scientificName), taxonomy$species)
    bad_names2 <- setdiff(taxonomy$species, unique(occurrence$scientificName))

    taxonomy <- taxonomy |>
      dplyr::filter(!species %in% bad_names2) |>
      as.data.frame()

    tax_res <- vegan::taxa2dist(taxonomy, varstep=TRUE)

    occurrence2 <- occurrence |>
      dplyr::filter(!scientificName %in% bad_names)|>
      dplyr::count(scientificName)|>
      tidyr::pivot_wider(names_from = scientificName, values_from = n) |>
      as.data.frame()

    cw_res <- vegan::taxondive(occurrence2, tax_res)
  }

  if (!is_count){
    occurrence <- occurrence |>
      dplyr::count(scientificName)|>
      tidyr::pivot_wider(names_from = scientificName, values_from = n) |>
      as.data.frame()
  }

  if ("shannon" %in% indexes){
    idx_shannon <- vegan::diversity(occurrence, index = "shannon")
  }

  if ("simpson" %in% indexes){
    idx_simpson <- vegan::diversity(occurrence, index = "simpson")
  }

  res <- tibble::tibble(shannon = idx_shannon, simpson = idx_simpson)
  if (!is.null(cw_res)){
    res <- res |>
      dplyr::mutate(cw_diversity = cw_res$D, cw_distinctness = cw_res$Dstar)
  }

  class(res) <- c("idx_res", class(res))
  return(res)

}

globalVariables(c("scientificName", "n"))
