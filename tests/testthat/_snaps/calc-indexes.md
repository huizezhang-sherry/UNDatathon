# calculate_indexes() works

    Code
      calculate_indexes(s)
    Output
      # A tibble: 1 x 4
        shannon simpson cw_diversity cw_distinctness
          <dbl>   <dbl>        <dbl>           <dbl>
      1    5.73   0.991         90.0            91.1

---

    Code
      calculate_indexes(s, index = c("shannon", "simpson"))
    Output
      # A tibble: 1 x 2
        shannon simpson
          <dbl>   <dbl>
      1    5.73   0.991

---

    Code
      calculate_indexes(data = s$occurrence)
    Condition
      Error in `calculate_indexes()`:
      ! The `data` argument only accepts results of a galah_res object from `query_species()`. You can input separate occurrence and species data with `occurrence = ` and `taxonomy = `.

---

    Code
      calculate_indexes(occurrence = s$occurrence)
    Condition
      Error in `calculate_indexes()`:
      ! Taxonomic information is required for CW index. Please supply it with argument `taxonomy = `

---

    Code
      calculate_indexes(taxonomy = s$taxonomy)
    Condition
      Error in `calculate_indexes()`:
      ! Please input a galah_res object or occurrence data to compute the indexes.

