## code to prepare `test` dataset goes here
galah_config(email = "alex.qin@sydney.edu.au")
d <- disaster |> filter(cat_name == "CAT131") |> disaster_as_shape()
test_ala <- query_species(d[1,])
usethis::use_data(test_ala, overwrite = TRUE)
