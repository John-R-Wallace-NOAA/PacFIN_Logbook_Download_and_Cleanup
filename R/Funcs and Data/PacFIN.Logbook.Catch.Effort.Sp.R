
# Test <- PacFIN.Logbook.Catch.Effort.Sp(c("PTR1", "PTRL"))


PacFIN.Logbook.Catch.Effort.Sp <- function(SPID, LBData = LBData.1981.2015) {

  # Using the extrapolated and adjusted 'APOUNDS_WDFW' for WDFW. WDFW's 'ADJ_TOWTIME' is also needed for WDFW CPUE.
  require(JRWToolBox)

  LBdata <- LBData[LBData$AGID %in% c('W', 'O', 'C'), ]

  LB <- LBData[LBData$SPID %in% SPID, ]
 
  LB$APOUNDS_WDFW[is.na(LB$APOUNDS_WDFW)] <- 0
  LB$APOUNDS[is.na(LB$APOUNDS)] <- 0
  
  WOC <- aggregate(list(Catch.lbs = LB$APOUNDS + LB$APOUNDS_WDFW), list(Key = LB$Key), sum, na.rm = T)
 
  Out <- match.f(LBData[!duplicated(LBData$Key),c("Key", "RYEAR", "DRVID", "TRIP_ID", "TOWNUM", "AGID", "RPCID", "RDAY", "DDATE", "RDATE", "TOWDATE", 
                   "SET_LAT", "SET_LONG", "UP_LAT", "UP_LONG", "LATLONG_TYPE", "SET_TIME", "UP_TIME", "DURATION", "ADJ_TOWTIME", "ARID_PSMFC", "BLOCK", 
                   "BLOCK_OR", "GRID", "PACFIN_TARGET", "FTID", "TICKET_DATE", "DEPTH1", "PERMID_1", "LEN_ENDOR_1", "bimo")], 
          WOC, "Key", "Key", "Catch.lbs")

  Out$Catch.lbs[is.na(Out$Catch.lbs)] <- 0
  
  Out
}




