# disaster_to_shape() works

    Code
      disaster_as_shape(filter(disaster, cat_name == "CAT131"))
    Output
      Simple feature collection with 11 features and 5 fields
      Geometry type: POLYGON
      Dimension:     XY
      Bounding box:  xmin: 145.7653 ymin: -43.20078 xmax: 148.3203 ymax: -41.33485
      Geodetic CRS:  WGS 84
      First 10 features:
         postcode_2021 cent_long postcode_num_2021 areasqkm_2021  cent_lat
      1           7140  146.5308              7140     5233.2386 -42.39338
      2           7172  147.6331              7172      241.9126 -42.73259
      3           7173  147.6769              7173      114.8740 -42.83702
      4           7174  147.7753              7174       42.5297 -42.82928
      5           7175  147.8600              7175       62.3831 -42.76914
      6           7177  147.8580              7177       90.3882 -42.88349
      7           7178  147.9086              7178       96.6914 -42.94368
      8           7179  147.9136              7179       51.4124 -43.00455
      9           7182  147.9013              7182      175.4638 -43.13454
      10          7214  147.9001              7214     1376.0028 -41.52456
                               geometry
      1  POLYGON ((147.1969 -42.8013...
      2  POLYGON ((147.6033 -42.7980...
      3  POLYGON ((147.6033 -42.7980...
      4  POLYGON ((147.8193 -42.8044...
      5  POLYGON ((147.8484 -42.8439...
      6  POLYGON ((147.7297 -42.8930...
      7  POLYGON ((147.8218 -42.9077...
      8  POLYGON ((147.9866 -42.9702...
      9  POLYGON ((147.821 -43.20078...
      10 POLYGON ((147.8441 -41.3348...

---

    Code
      disaster_as_shape(filter(disaster, cat_name == "CAT131"), as_sfc = TRUE)
    Output
      Geometry set for 11 features 
      Geometry type: POLYGON
      Dimension:     XY
      Bounding box:  xmin: 145.7653 ymin: -43.20078 xmax: 148.3203 ymax: -41.33485
      Geodetic CRS:  WGS 84
      First 5 geometries:
    Message
      POLYGON ((147.1969 -42.80136, 147.1762 -42.7799...
      POLYGON ((147.6033 -42.79808, 147.7265 -42.7836...
      POLYGON ((147.6033 -42.79808, 147.7297 -42.8930...
      POLYGON ((147.8193 -42.80444, 147.7334 -42.7986...
      POLYGON ((147.8484 -42.84399, 147.9369 -42.735,...

---

    Code
      disaster_as_shape(mutate(head(disaster, 1), postcode = NA))
    Condition
      Error in `disaster_as_shape()`:
      ! No shapefile found for the postcode in the disaster data. Please check if the postcode is correct and without NAs.

---

    Code
      disaster_as_shape(select(head(disaster, 1), -postcode))
    Condition
      Error in `disaster_as_shape()`:
      ! The postcode column doesn't exist in the disaster data. Please specify the postcode column with argument `postcode`

