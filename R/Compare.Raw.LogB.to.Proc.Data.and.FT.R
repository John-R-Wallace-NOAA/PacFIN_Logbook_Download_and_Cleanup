
Compare.Raw.LogB.to.Proc.Data.and.FT <- function(SPID, State, CompFT, LB_Raw, LB_Proc, State.Lat = TRUE)   {
    
   library(JRWToolBox)    
    
   # Fishticket 
   # **** As mentioned in PacFIN.Catch.Extraction()), the summary catch (sc) PacFIN has this strangeness of retaining the name PACFIN_PORT_CODE when it only contains WA, OR, and CA port groups. **** 
   # **** The PacFIN.PSMFC.Summary.Catch continues this legacy coding choice. ****
      
   # ------------------------------------------- PSMFC Summary Catch Table without research (R) nor tribal data (TI) ---------------------------------------------------------------- 
   CompFT.PSMFC <- CompFT[!CompFT$REMOVAL_TYPE_CODE %in% "R" & !CompFT$FLEET_CODE %in% "TI" & 
            CompFT$PACFIN_CATCH_AREA_CODE %in% c("UP","1A", "1B", "MNTREY BAY", "1E", "1C", "2A", "2B", "2C", "2E", "2F", "2D", "3A", "3B", "3C-S"), ]
   CompFT.PSMFC$PACFIN_PORT_CODE <- CompFT.PSMFC$W_O_C_Port_Groups  # W_O_C_Port_Groups is derived from CompFT$AGENCY_CODE within PacFIN.Catch.Extraction()
   PacFIN.PSMFC.Summary.Catch <- aggregate(list(ROUND_WEIGHT_MTONS = CompFT.PSMFC$ROUND_WEIGHT_MTONS), CompFT.PSMFC[, c('COUNCIL_CODE', 'DAHL_GROUNDFISH_CODE', 'LANDING_YEAR', 'LANDING_MONTH',
                                                         'PACFIN_SPECIES_CODE', 'PACFIN_CATCH_AREA_CODE', 'PACFIN_GEAR_CODE', 'PACFIN_GROUP_GEAR_CODE', 'PACFIN_PORT_CODE')], sum, na.rm = TRUE)
   PacFIN.PSMFC.Summary.Catch <- sort.f(PacFIN.PSMFC.Summary.Catch, c('LANDING_YEAR', 'LANDING_MONTH', 'PACFIN_CATCH_AREA_CODE', 'PACFIN_GEAR_CODE', 'PACFIN_PORT_CODE'))
   PacFIN.PSMFC.Summary.Catch <- PacFIN.PSMFC.Summary.Catch[PacFIN.PSMFC.Summary.Catch$PACFIN_GROUP_GEAR_CODE %in% 'TWL' & 
         PacFIN.PSMFC.Summary.Catch$PACFIN_PORT_CODE %in% recode.simple(State, cbind(c('C', 'O', 'W'), c('ACA', 'AOR', 'AWA'))), ] 
   cat("\n"); print(Table(PacFIN.PSMFC.Summary.Catch$PACFIN_PORT_CODE))    
       
   # FT.Data.Agg <- aggregate(list(FTmt = PacFIN.PSMFC.Summary.Catch$CATCH.LBS/2204.6), list(Year = PacFIN.PSMFC.Summary.Catch$LANDING_YEAR), sum, na.rm = TRUE)
   # FT.Data.Agg <- aggregate(list(FT.mt = PacFIN.PSMFC.Summary.Catch$LWT_LBS/2204.6), list(Year = PacFIN.PSMFC.Summary.Catch$LANDING_YEAR), sum, na.rm = TRUE)
   FT.Data.Agg <- aggregate(list(FT.mt = PacFIN.PSMFC.Summary.Catch$ROUND_WEIGHT_MTONS), list(Year = PacFIN.PSMFC.Summary.Catch$LANDING_YEAR), sum, na.rm = TRUE)
   cat("\n"); print(FT.Data.Agg[1:4, ]); cat("\n\n")

   # Raw Logbook
   LB_Raw$APOUNDS_ALL <- ifelse(is.na(LB_Raw$APOUNDS_WDFW), LB_Raw$APOUNDS, LB_Raw$APOUNDS_WDFW)
   LB_Raw <- LB_Raw[LB_Raw$SPID %in% SPID & LB_Raw$AGID %in% State & !is.na(LB_Raw$AGID) & !(LB_Raw$ARID_PSMFC %in% '4A') & 
                    !is.na(LB_Raw$ARID_PSMFC) & LB_Raw$SET_LAT < 48 + 26/60 & !is.na(LB_Raw$SET_LAT), ]
   cat("\n"); print(Table(LB_Raw$ARID_PSMFC)); print(Table(LB_Raw$AGID))
   
   LB.Raw.Agg <- aggregate(list(LB.Raw.mt = LB_Raw$APOUNDS_ALL/2204.6), list(Year = LB_Raw$RYEAR), sum, na.rm = TRUE)
   cat("\n"); print(LB.Raw.Agg[1:4, ]); cat("\n\n")
   
   FT.LB.Raw <- JRWToolBox::renum(JRWToolBox::match.f(FT.Data.Agg, LB.Raw.Agg, 'Year', 'Year', 'LB.Raw.mt'))
      
   # Processed Logbook
   # Only need to remove area 4A here due to a few bad lat/long locations
   if(State.Lat) {
      LB_Proc <- LB_Proc[LB_Proc$State.Lat %in% State & !is.na(LB_Proc$State.Lat) & !LB_Proc$ARID_PSMFC %in% '4A' &  !is.na(LB_Proc$ARID_PSMFC) , ]
      cat("\n"); print(Table(LB_Proc$ARID_PSMFC)); print(Table(LB_Proc$State.Lat))
   } else {
      LB_Proc <- LB_Proc[LB_Proc$AGID %in% State & !is.na(LB_Proc$AGID) & !LB_Proc$ARID_PSMFC %in% '4A' &  !is.na(LB_Proc$ARID_PSMFC) , ]
      cat("\n"); print(Table(LB_Proc$ARID_PSMFC)); print(Table(LB_Proc$AGID))
   }
   
   # SP.col <- colnames(LB_Proc)[grep(SPID, colnames(LB_Proc))]
   SP.col <- paste0(SPID, ".kg")
   cat("\n"); print(SP.col); cat("\n")
   LB_Proc <- LB_Proc[, c('RYEAR', SP.col)]
  
   LB_Proc$SP.kg <- apply(LB_Proc[, -1, drop = FALSE], 1, sum, na.rm = TRUE)
   LB.Proc.Agg <- aggregate(list(LB.Proc.mt = LB_Proc$SP.kg/1000), list(Year = LB_Proc$RYEAR), sum, na.rm = TRUE)
   print(LB.Proc.Agg[1:4, ]); cat("\n\n")
   
   FT.LB.Raw.LB.Proc <- JRWToolBox::renum(JRWToolBox::match.f(FT.LB.Raw, LB.Proc.Agg, 'Year', 'Year', 'LB.Proc.mt'))
   
   # Find all the proportions
   FT.LB.Raw.LB.Proc$FT_LB.Raw_Prop <- FT.LB.Raw.LB.Proc$FT.mt/FT.LB.Raw.LB.Proc$LB.Raw.mt
   FT.LB.Raw.LB.Proc$FT_LB.Proc_Prop <- FT.LB.Raw.LB.Proc$FT.mt/FT.LB.Raw.LB.Proc$LB.Proc.mt
   FT.LB.Raw.LB.Proc$LB.Proc_LB.Raw_Prop <- FT.LB.Raw.LB.Proc$LB.Proc.mt/FT.LB.Raw.LB.Proc$LB.Raw.mt
   
   JRWToolBox::r(FT.LB.Raw.LB.Proc, 3)
}

