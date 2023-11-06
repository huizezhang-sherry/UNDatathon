test_that("calculate_indexes() works", {
  library(dplyr)
  s <- test_ala
  expect_snapshot(calculate_idx(s))
  expect_snapshot(calculate_idx(s, index = c("shannon", "simpson")))

  # errors
  expect_snapshot(calculate_idx(data = s$occurrence), error = TRUE)
  expect_snapshot(calculate_idx(occurrence = s$occurrence), error = TRUE)
  expect_snapshot(calculate_idx(taxonomy = s$taxonomy), error = TRUE)
})
