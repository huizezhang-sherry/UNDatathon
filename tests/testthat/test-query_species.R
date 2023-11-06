test_that("query_species() works", {
   library(dplyr)
   library(sf)
   library(galah)
   d <- disaster |> filter(cat_name == "CAT131") |> disaster_as_shape()
   #expect_snapshot(query_species(d[1,]))
})
