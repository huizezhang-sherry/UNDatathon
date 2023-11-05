test_that("query_species() works", {
   library(dplyr)
   library(sf)
   library(galah)
   galah_config(email = "alex.qin@sydney.edu.au")
   d <- disaster |> filter(cat_name == "CAT131") |> disaster_as_shape()
   expect_snapshot(query_species(d[1,]))
})
