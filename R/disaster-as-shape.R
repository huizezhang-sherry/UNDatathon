#' Find the shape file for the postcode in the disaster data
#'
#' The function extracts the shape file of the postcodes in the disaster data.
#'
#' @param disaster_df A dataframe containing the disaster data.
#' @param postcode The column name of the postcode in the disaster data.
#' @param as_sfc Whether to return a simple feature column (sfc) object.
#' (with default as TRUE) or a simple feature (sf) object.
#' @export
#' @examples
#' \dontrun{
#' library(dplyr)
#' disaster |> filter(cat_name == "CAT131") |> disaster_as_shape()
#' }
disaster_as_shape <- function(disaster_df, postcode = "postcode", as_sfc = FALSE){
  if (!postcode %in% colnames(disaster_df)){
    cli::cli_abort(
    "The postcode column doesn't exist in the disaster data.
    Please specify the postcode column with argument {.arg postcode}")
  }

  res <- aus_postcode |> dplyr::filter(postcode_2021 %in% disaster_df[[postcode]])

  if (nrow(res) == 0){
    cli::cli_abort(
      "No shapefile found for the postcode in the disaster data.
      Please check if the postcode is correct and without NAs.")
  }

  if (as_sfc) res <- res |> sf::st_as_sfc()
  return(res)

}
