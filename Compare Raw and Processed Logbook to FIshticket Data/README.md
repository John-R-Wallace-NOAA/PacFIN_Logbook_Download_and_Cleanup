Using the PacFIN.Catch.Extraction() function from the <John-R-Wallace-NOAA/PacFIN-Data-Extraction> repo, and products derived from this PacFIN Logbook repo, the Compare.Raw.LogB.to.Proc.Data.and.FT() function (in the R folder) compares raw and processed logbook data to PacFIN fishticket data. 


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
          
                           AGID
                      C      O      W
               C 488694   7087      5
    State.Lat  O  12633 270286   7378
               W      0 148314 138309
      
            
    # --- Sablefish ---
    # Fishticket data for the given species
    PacFIN.SABL.Catch.List.12.Aug.2022 <- PacFIN.Catch.Extraction("('SABL')")
    
    # -- Using all Coast Wide Data --
    Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', c('W', 'O', 'C'), PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
    
    # -- Use State.Lat in the Processed Logbook data --
    Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', 'W', PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
    Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', 'O', PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
    Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', 'C', PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)

    # -- Use Agency ID (AGID) in the Processed Logbook data --
     Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', 'W', PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)
     Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', 'O', PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)
     Compare.Raw.LogB.to.Proc.Data.and.FT('SABL', 'C', PacFIN.SABL.Catch.List.12.Aug.2022$CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)


    # --- Skates ---
    # Fishticket data for the given species group
    PacFIN.Longnose.Catch.List.22.Jul.2022 <- PacFIN.Catch.Extraction("('LSKT')")
    PacFIN.BigSkate.Catch.List.22.Jul.2022 <- PacFIN.Catch.Extraction("('BSKT', 'BSK1')")
    PacFIN.USKT.Catch.List.22.Jul.2022 <- PacFIN.Catch.Extraction("('USKT')")
    # PacFIN.CSKT.Catch.List.11.Aug.2022 <- PacFIN.Catch.Extraction("('CSKT')")
    # PacFIN.OSKT.Catch.List.11.Aug.2022 <- PacFIN.Catch.Extraction("('OSKT')")
       
     
    PacFIN.3.skates.CompFT <- rbind(PacFIN.Longnose.Catch.List.22.Jul.2022$CompFT, PacFIN.BigSkate.Catch.List.22.Jul.2022$CompFT, PacFIN.USKT.Catch.List.22.Jul.2022$CompFT)
     
    # -- Using all Coast Wide Data --  
    Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), c('W', 'O', 'C'), PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
     
    # -- Use State.Lat in the Processed Logbook data --
    Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), 'W', PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
    Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), 'O', PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
    Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), 'C', PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel)
  
    # -- Use Agency ID (AGID) in the Processed Logbook data --
    Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), 'W', PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)
    Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), 'O', PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)
    Compare.Raw.LogB.to.Proc.Data.and.FT(c('LSKT', 'BSKT', 'USKT'), 'C', PacFIN.3.skates.CompFT, LBData.1981.2021, LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, State.Lat = FALSE)
    
 
