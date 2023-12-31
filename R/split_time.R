#' Split the occurrence data by year and month
#'
#' The function splits the occurence data by year and month.
#'
#' @param data A {.field galah_res} object from {.code query_species}.
#' @param window The time window to split the data.
#' @export
#' @examples
#' res <- test_ala |> split_time()
#' res[[1]]
split_time <- function(data, window = 3){

  if(!inherits(data, "galah_res")){
    cli::cli_abort(
    "Please input a {.field galah_res} object from {.code query_species}"
    )
  }
  time <- data$occurrence |> dplyr::pull(eventDate) |> tsibble::yearmonth() |> unique()
  occur <- purrr::map(time, function(x){
    data$occurrence |>
      dplyr::mutate(ym = tsibble::yearmonth(eventDate)) |>
      dplyr::filter(dplyr::between(ym, x- window, x + window))
  })
  names(occur) <- time

  return(occur)
}

globalVariables(c("ym"))
