#' Autoplot function for calculated indexes
#'
#' The function creates a line plot of the indexes calculated from
#' \code{calculate_idx()}
#'
#' @param data A {.field idx_res} object from {.code calculate_idx()}.
#' @param time The time variable in the data, support non-standard evaluation
#' @param site The time variable in the data, support non-standard evaluation
#' @export
#' @examples
#' \dontrun{
#' library(dplyr)
#' library(sf)
#' d <- disaster |> filter(cat_name == "CAT131") |> disaster_as_shape()
#' s <- query_species(d[1,])
#' library(tsibble)
#' time <- s$occurrence |> pull(eventDate) |> yearmonth() |> unique()
#' occur <- purrr::map(time, function(x){
#'   s$occurrence |>
#'     mutate(ym = yearmonth(eventDate)) |>
#'     filter(between(ym, x-3, x + 3))
#' })
#' names(occur) <- time
#' res <- occur |>
#'   purrr::map_dfr(~calculate_idx(occurrence = .x, taxonomy = s$taxonomy), .id = "ym") |>
#'   mutate(ym = time)
#' res |> autoplot(time = ym)
#' }
autoplot <- function(data, time = NULL, site = NULL){
  time <- rlang::enquo(time) |> rlang::quo_get_expr()
  site <- rlang::enquo(site) |> rlang::quo_get_expr()
  if (!inherits(data, "idx_res")){
    cli::cli_abort("Plese supply a {.field idx_res} object
                   from {.fn calculate_idx} for {.code autoplot}")
  }

  if (!is.null(time)){
    data <- data |>
      tidyr::pivot_longer(
        cols = -dplyr::all_of(time), names_to = "idx", values_to = "value"
        )
  }

  data |>
    ggplot2::ggplot(ggplot2::aes(x = !!time, y = value, group = idx)) +
    ggplot2::geom_line() +
    ggplot2::facet_wrap(ggplot2::vars(idx), ncol = 1, scales = "free")
}

globalVariables(c("value", "idx", ""))
