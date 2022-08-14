Using the PacFIN.Catch.Extraction() function from the <John-R-Wallace-NOAA/PacFIN-Data-Extraction> repo, and products derived from this PacFIN Logbook repo, the Compare.Raw.LogB.to.Proc.Data.and.FT() function (in the R folder) compares raw and processed logbook data to PacFIN fishticket data. 

Disclaimer: The highly aggregated data shown below far surpasses the 3-vessel rule of confidentiality and is given for illustrative purposes only. The data is neither vetted nor verified. For offical data reports and information on PacFIN see https://pacfin.psmfc.org/

    PacFIN.Login <- UID <- "wallacej"
    PacFIN.PW <- PWD <- "*********"
    
     # Raw Logbook
    base::load("LBData.1981.2021.RData")
    
    # Processed Logbook
    base::load("LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel 26 May 2022.RData")
    LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel$AGID <- as.character(LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel$AGID)
    
    # State.Lat is easily dervived from the SET_LAT and gives the state waters where the logbook tow was set.
    LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel$State.Lat <- 'W'
    LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel$State.Lat[LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel$SET_LAT < 46 + 16/60] <- 'O'
    LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel$State.Lat[LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel$SET_LAT < 42] <- 'C'
    Table(LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel$State.Lat, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel$AGID)
    
    # --- Use State.Lat in the Processed Logbook data ---
    
    # -- Sablefish --
    # Fishticket data for the given species
    PacFIN.SABL.Catch.List.12.Aug.2022 <- PacFIN.Catch.Extraction("('SABL')")
    
    Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', c('W', 'O', 'C'), PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
    
    Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', 'W', PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
    Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', 'O', PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
    Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', 'C', PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)

    # -- Skates --
     # Fishticket data for the given species group
     PacFIN.Longnose.Catch.List.22.Jul.2022 <- PacFIN.Catch.Extraction("('LSKT')")
     PacFIN.BigSkate.Catch.List.22.Jul.2022 <- PacFIN.Catch.Extraction("('BSKT', 'BSK1')")
     PacFIN.USKT.Catch.List.22.Jul.2022 <- PacFIN.Catch.Extraction("('USKT')")
     # PacFIN.CSKT.Catch.List.11.Aug.2022 <- PacFIN.Catch.Extraction("('CSKT')")
     # PacFIN.OSKT.Catch.List.11.Aug.2022 <- PacFIN.Catch.Extraction("('OSKT')")
         
     PacFIN.3.skates.CompFT <- rbind(PacFIN.Longnose.Catch.List.22.Jul.2022$CompFT, PacFIN.BigSkate.Catch.List.22.Jul.2022$CompFT, PacFIN.USKT.Catch.List.22.Jul.2022$CompFT)
     
     Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), c('W', 'O', 'C'), PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
     
     Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), 'W', PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
     Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), 'O', PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
     Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), 'C', PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
     
     
     # --- Use Agency ID (AGID) instead of State.Lat in the Processed Logbook data ---
     
     # -- Sablefish --
     Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', c('W', 'O', 'C'), PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)
     
     Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', 'W', PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)
     Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', 'O', PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)
     Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', 'C', PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)
     
     
     # -- Skates --
     Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), c('W', 'O', 'C'), PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)
      
     Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), 'W', PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)
     Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), 'O', PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)
     Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), 'C', PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)
    
    
The main results from the running the code above is given below:

    Table(LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel$State.Lat, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel$AGID)
       
             C      O      W
      C 488694   7087      5
      O  12633 270286   7378
      W      0 148314 138309
      
    
    Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', c('W', 'O', 'C'), PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
    
       Year    FT.mt LB.Raw.mt LB.Proc.mt FT_LB.Raw_Prop FT_LB.Proc_Prop LB.Proc_LB.Raw_Prop
    1  1981 5230.405  2916.847   2899.567          1.793           1.804               0.994
    2  1982 9207.161  4385.571   4359.359          2.099           2.112               0.994
    3  1983 6348.038  2464.390   2403.215          2.576           2.641               0.975
    4  1984 6563.113  1981.154   1967.507          3.313           3.336               0.993
    5  1985 6872.977  2617.192   2536.860          2.626           2.709               0.969
    6  1986 6227.764  2978.135   2880.688          2.091           2.162               0.967
    7  1987 6096.651  4802.316   5274.752          1.270           1.156               1.098
    8  1988 5092.637  4555.681   4769.633          1.118           1.068               1.047
    9  1989 5403.884  4655.152   4667.806          1.161           1.158               1.003
    10 1990 4852.774  4021.537   4010.252          1.207           1.210               0.997
    11 1991 4717.226  4201.889   4241.094          1.123           1.112               1.009
    12 1992 5068.417  4640.499   4773.697          1.092           1.062               1.029
    13 1993 4505.265  4250.055   4105.548          1.060           1.097               0.966
    14 1994 3434.760  3086.180   3204.169          1.113           1.072               1.038
    15 1995 3552.446  3121.689   3288.442          1.138           1.080               1.053
    16 1996 3918.259  3349.105   3487.832          1.170           1.123               1.041
    17 1997 3497.860  3158.173   3125.434          1.108           1.119               0.990
    18 1998 1973.245  1701.783   1750.914          1.160           1.127               1.029
    19 1999 2883.603  2691.123   2781.803          1.072           1.037               1.034
    20 2000 2461.933  2188.834   2271.762          1.125           1.084               1.038
    21 2001 2358.130  2071.647   2193.514          1.138           1.075               1.059
    22 2002 1460.027  1172.199   1186.632          1.246           1.230               1.012
    23 2003 2071.485  1907.298   2013.661          1.086           1.029               1.056
    24 2004 2210.869  1948.601   2060.497          1.135           1.073               1.057
    25 2005 2115.417  2015.642   1949.583          1.050           1.085               0.967
    26 2006 2266.616  2269.968   2171.558          0.999           1.044               0.957
    27 2007 2297.975  2369.220   2256.696          0.970           1.018               0.953
    28 2008 2632.410  2814.935   2683.143          0.935           0.981               0.953
    29 2009 2898.429  2897.690   2758.691          1.000           1.051               0.952
    30 2010 2468.170  2451.703   2323.968          1.007           1.062               0.948
    31 2011 1651.623  1638.578   1546.486          1.008           1.068               0.944
    32 2012 1456.008  1420.014   1356.907          1.025           1.073               0.956
    33 2013 1347.989  1343.974   1284.968          1.003           1.049               0.956
    34 2014 1264.525  1204.373   1153.229          1.050           1.097               0.958
    35 2015 1427.018  1370.464   1326.925          1.041           1.075               0.968
    36 2016 1431.743  1368.854   1297.336          1.046           1.104               0.948
    37 2017 1596.500  1326.031   1192.796          1.204           1.338               0.900
    38 2018 1378.124  1310.349   1242.103          1.052           1.110               0.948
    39 2019 1548.724  1403.804   1342.663          1.103           1.153               0.956
    40 2020 1074.001   928.993    669.856          1.156           1.603               0.721
    41 2021 1498.294  1431.575         NA          1.047              NA                  NA
    42 2022 1306.820        NA         NA             NA              NA                  NA
    

    
