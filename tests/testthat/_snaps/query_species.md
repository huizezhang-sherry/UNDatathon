# query_species() works

    Code
      query_species(d[1, ])
    Message
      This query will return 5,421 records
    Output
      
      Checking queue
      Current queue size: 1 inqueue  running 
      $occurrence
      # A tibble: 5,421 x 8
         decimalLatitude decimalLongitude eventDate           scientificName         
                   <dbl>            <dbl> <dttm>              <chr>                  
       1           -42.9             147. 2019-08-03 00:00:00 Litoria ewingii        
       2           -42.9             147. 2019-08-03 00:00:00 Crinia signifera       
       3           -42.9             147. 2019-08-05 00:00:00 Crinia signifera       
       4           -42.9             147. 2019-08-05 00:00:00 Crinia signifera       
       5           -42.9             147. 2020-12-24 09:04:59 Epacris serpyllifolia  
       6           -42.9             147. 2020-12-25 09:57:59 Nothofagus cunninghamii
       7           -42.9             147. 2020-12-24 08:15:00 Telopea truncata       
       8           -42.9             147. 2020-12-24 08:15:00 Richea pandanifolia    
       9           -42.9             147. 2020-12-24 08:15:00 Bauera rubioides       
      10           -42.9             147. 2020-12-24 08:22:00 Drosera arcturi        
      # i 5,411 more rows
      # i 4 more variables: taxonConceptID <chr>, recordID <chr>,
      #   dataResourceName <chr>, occurrenceStatus <chr>
      
      $taxonomy
      # A tibble: 785 x 5
         class order          family       genus        species                       
         <chr> <chr>          <chr>        <chr>        <chr>                         
       1 Aves  Passeriformes  Corvidae     Corvus       Corvus tasmanicus             
       2 Aves  Passeriformes  Artamidae    Strepera     Strepera (Strepera) fuliginosa
       3 Aves  Passeriformes  Rhipiduridae Rhipidura    Rhipidura (Rhipidura) albisca~
       4 Aves  Passeriformes  Maluridae    Malurus      Malurus (Malurus) cyaneus     
       5 Aves  Psittaciformes Psittacidae  Platycercus  Platycercus (Platycercus) cal~
       6 Aves  Passeriformes  Meliphagidae Nesoptilotis Nesoptilotis flavicollis      
       7 Aves  Passeriformes  Meliphagidae Anthochaera  Anthochaera (Anthochaera) par~
       8 Aves  Passeriformes  Acanthizidae Sericornis   Sericornis (Sericornis) humil~
       9 Aves  Passeriformes  Hirundinidae Hirundo      Hirundo (Hirundo) neoxena     
      10 Aves  Passeriformes  Acanthizidae Acanthiza    Acanthiza (Acanthiza) pusilla 
      # i 775 more rows
      
      attr(,"class")
      [1] "galah_res" "list"     

