library(vdiffr)
library(dplyr)
library(tsibble)
test_that("multiplication works", {
  s <- test_ala

  time <- s$occurrence |> pull(eventDate) |> yearmonth() |> unique()
  occur <- purrr::map(time, function(x){
    s$occurrence |>
      mutate(ym = yearmonth(eventDate)) |>
      filter(between(ym, x-3, x + 3))
  })
  names(occur) <- time
  res <- occur |>
    purrr::map_dfr(~calculate_idx(occurrence = .x, taxonomy = s$taxonomy), .id = "ym") |>
    mutate(ym = time)
  p1 <- res |> autoplot(time = ym)
  vdiffr::expect_doppelganger("base case", p1)

  expect_snapshot(test_ala |> autoplot(), error = TRUE)
})
