# query_species() works

    Code
      query_species(d[1, ])
    Message
      This query will return 5,421 records
    Output
      
      Checking queue
      Current queue size: 1 inqueue  running 
      $occurrence
      # A tibble: 5,419 x 8
         decimalLatitude decimalLongitude eventDate           scientificName          
                   <dbl>            <dbl> <dttm>              <chr>                   
       1           -42.7             147. 2019-01-01 16:00:00 Strepera (Strepera) ful~
       2           -42.7             147. 2019-01-01 16:00:00 Anthochaera (Anthochaer~
       3           -42.7             147. 2019-01-01 16:00:00 Cacatua (Cacatua) galer~
       4           -42.7             147. 2019-01-01 16:00:00 Zanda funerea           
       5           -42.7             147. 2019-01-01 16:00:00 Nesoptilotis flavicollis
       6           -42.7             147. 2019-01-01 16:00:00 Phylidonyris (Phylidony~
       7           -42.1             146. 2019-01-02 08:00:00 Corvus tasmanicus       
       8           -42.1             146. 2019-01-02 08:00:00 Strepera (Strepera) ful~
       9           -42.1             146. 2019-01-02 08:00:00 Anthochaera (Anthochaer~
      10           -42.1             146. 2019-01-02 08:00:00 Phylidonyris (Phylidony~
      # i 5,409 more rows
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

