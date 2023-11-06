library(vdiffr)
library(dplyr)
library(tsibble)
test_that("multiplication works", {
  s <- test_ala

  res <- split_time(test_ala) |>
      purrr::map_dfr(~calculate_idx(occurrence = .x, taxonomy = test_ala$taxonomy), .id = "ym")

  p1 <- res |>
    mutate(ym = yearmonth(ym)) |>
    autoplot(time = ym)
  vdiffr::expect_doppelganger("base case", p1)

  expect_snapshot(test_ala |> autoplot(), error = TRUE)
})
