test_that("calculate_indexes() works", {
  library(dplyr)
  library(sf)
  library(galah)
  galah_config(email = "alex.qin@sydney.edu.au")
  d <- disaster |> filter(cat_name == "CAT131") |> disaster_as_shape()
  s <- query_species(d[1,])
  expect_snapshot(calculate_indexes(s))
  expect_snapshot(calculate_indexes(s, index = c("shannon", "simpson")))

  # errors
  expect_snapshot(calculate_indexes(data = s$occurrence), error = TRUE)
  expect_snapshot(calculate_indexes(occurrence = s$occurrence), error = TRUE)
  expect_snapshot(calculate_indexes(taxonomy = s$taxonomy), error = TRUE)
})
