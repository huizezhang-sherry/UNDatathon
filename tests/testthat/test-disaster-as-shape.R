test_that("disaster_to_shape() works", {
  library(sf)
  library(dplyr)
  expect_snapshot(disaster |> filter(cat_name == "CAT131") |> disaster_as_shape())
  expect_snapshot(disaster |> filter(cat_name == "CAT131") |> disaster_as_shape(as_sfc = TRUE))

  # errors
  expect_snapshot(disaster |> head(1) |> mutate(postcode = NA) |> disaster_as_shape(), error = TRUE)
  expect_snapshot(disaster |> head(1) |> select(-postcode) |> disaster_as_shape(), error = TRUE)

})
