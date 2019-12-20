


# Add species to the 'LB.ShortForm' file, each row of 'LB.ShortForm' will be a unique tow and the species catch (kg) will be in added columns

base::load("Funcs and Data/LBData.1981.2018.dmp")  # Load main raw data, if not already loaded, used inside of PacFIN.Logbook.Catch.Effort.Sp() below

sort(unique(LBData.1981.2018$SPID))
#   [1] "ALBC" "ARR1" "ART1" "ARTH" "ASRK" "BCC1" "BGL1" "BLK1" "BLU1" "BMO1" "BNK1" "BRW1" "BRZ1" "BSKT" "BSOL" "BSRK" "BSRM" "BTCR" "BTRY" "BYL1"
#  [21] "CBZ1" "CBZN" "CHL1" "CHLB" "CHN1" "CHNK" "CHUM" "CLP1" "CMCK" "CMSL" "CNR1" "COHO" "COP1" "CSKT" "CSOL" "CSRK" "CUDA" "CWC1" "DBR1" "DCRB"
#  [41] "DOVR" "DSOL" "DSRK" "DVR1" "EELS" "EGL1" "EGLS" "EULC" "FLG1" "FNTS" "FSOL" "GBAS" "GBL1" "GPH1" "GRDR" "GRS1" "GSP1" "GSR1" "GSTG" "HNY1"
#  [61] "HTRB" "JMCK" "KFSH" "KGL1" "KLP1" "KLPG" "LCD1" "LCOD" "LDB1" "LSKT" "LSP1" "LSRK" "MAKO" "MEEL" "MISC" "MSC2" "MSHP" "MSQD" "NANC" "NUSF"
#  [81] "NUSP" "NUSR" "OBAS" "OCRB" "OCRK" "OCTP" "OFLT" "OGRN" "OLV1" "OLVE" "ORCK" "OSCL" "OSKT" "OSRK" "OSRM" "OURC" "PBNT" "PCOD" "PDAB" "PDB1"
# [101] "PHLB" "PHRG" "PLCK" "POP1" "POP2" "PROW" "PRR1" "PSDN" "PSHP" "PSRK" "PTR1" "PTRL" "PWHT" "QLB1" "RATF" "RBR1" "RCK1" "RCK2" "RCK3" "RCK4"
# [121] "RCK5" "RCK6" "RCK7" "RCK9" "RCLM" "RCRB" "RDB1" "REX"  "REX1" "ROS1" "RPRW" "RSL1" "RSOL" "RST1" "RURC" "SABL" "SBL1" "SCLP" "SCR1" "SDB1"
# [141] "SFL1" "SHAD" "SHP1" "SLNS" "SMLT" "SNS1" "SPK1" "SPRW" "SQID" "SQR1" "SRFP" "SSO1" "SSOL" "SSP1" "SSRK" "STL1" "STNA" "STR1" "STRY" "SWRD"
# [161] "SWS1" "TCOD" "TGR1" "THDS" "TRE1" "TSRK" "UCRB" "UDAB" "UECH" "UFLT" "UHAG" "UHLB" "UKCR" "UMCK" "UMSK" "UPOP" "URCK" "USCL" "USCU" "USHR"
# [181] "USKT" "USLF" "USLP" "USRK" "USRM" "USTG" "USTR" "UTCR" "UTRB" "VRM1" "WBAS" "WCRK" "WDW1" "WEEL" "WSTG" "YEY1" "YLTL" "YTR1"




# *************************************** Good tows only *******************************************

load("Funcs and Data/LB Shortform Final 25 Mar 2019.dmp") # Only good tows in LB.ShortForm # rows = 1,033,637,  cols = 46
Source("Funcs and Data/PacFIN.Logbook.Catch.Effort.Sp.R") # Species or species group aggregate catch


# ******** Add extra species here *****************

SP.List <- list(LCOD.kg = c("LCOD", "LCD1"), POP.kg = c("POP1", "POP2", "UPOP")) # ** kg label here **
# SP.List <- list(YTRK.kg = c("YTRK", "YTR1")) # ** kg label here **


for ( i in 1:length(SP.List)) {
     cat("\n", names(SP.List)[i], "\n"); flush.console()
     tmp <- PacFIN.Logbook.Catch.Effort.Sp(SP.List[[i]], LBData = LBData.1981.2015.Nov2017)
     tmp[,ncol(tmp)] <- tmp[,ncol(tmp)]/2.20462  # ** Converting from lbs to kg here **
     names(tmp)[ncol(tmp)] <- names(SP.List)[i]
     LB.ShortForm <- match.f(LB.ShortForm, tmp, "Key", "Key", ncol(tmp))
}

LB.ShortForm[1:4,]


# sum = 0, testing new method with match.f() with old method using POP
# sum(LB.ShortForm$POPlbs/2.20462 - LB.ShortForm$POP.kg) 

# ******** Done adding species *****************




# Overwrite WDFW's DURATION with WDFW's ADJ_TOWTIME for WA 
LB.ShortForm$DURATION[LB.ShortForm$AGID  %in% 'W' & !is.na(LB.ShortForm$ADJ_TOWTIME)] <- LB.ShortForm$ADJ_TOWTIME[LB.ShortForm$AGID  %in% 'W' & !is.na(LB.ShortForm$ADJ_TOWTIME)]

# Tow duration limits 
N.with.all.tows <- nrow(LB.ShortForm)
LB.ShortForm <- LB.ShortForm[
       (LB.ShortForm$DURATION > 0.2) &       # records with tow duration > 0.2
       (LB.ShortForm$DURATION <= 24.0) &     # records with tow duration <= 24 hours  
       (!is.na(LB.ShortForm$DURATION)) 
       , ]
100 * (1 - nrow(LB.ShortForm)/N.with.all.tows) # Percent of tows removed


N.with.Hake <- nrow(LB.ShortForm)
LB.ShortForm.No.Hake.Strat <- LB.ShortForm[!(LB.ShortForm$Strategy %in% 'HAKE'),] # Rows = 976,494,  Cols = 50


# Specify state waters where catch was taken - areas for analsyis using ARID_PSMFC
LB.ShortForm$State.Waters <- NA
LB.ShortForm$State.Waters[LB.ShortForm$ARID_PSMFC %in% c("3A","3B","3S","3C", "3S", "3D")] <- "WA" #  # 3S [SOUTHERN PORTION OF AREA 3C (UNITED STATES ONLY)] added - JRW
LB.ShortForm$State.Waters[LB.ShortForm$ARID_PSMFC %in% c("2B","2C","2A","2E","2F")] <- "OR"  
LB.ShortForm$State.Waters[LB.ShortForm$ARID_PSMFC %in% c("1A","1B","1C")] <- "CA"            



# Clusters of midwater tows in PacFIN are mislabeled. Bathymetry depth will be used for midwater tows (see DataProcessExplore - JRW.R)
# Tows that have both a Strategy of 'HAKE' and a GRID label of 'MDT' will be removed as hopefully 'true' hake tows (see below). 


# The OTHER strategy has been labeled BRF after looking at Canary, Darkblotched, Bocaccio, and Chilipepper (Aug 22 2018)
# OLD: Need to improve this strategy with more species and perhaps add a Bottom Rockfish (BRF) strategy 

change(LB.ShortForm) # Rows = 1,048,814, Col = 52

# LB.ShortForm$Strategy <- 'OTHER'
LB.ShortForm$Strategy <- 'BRF' 
LB.ShortForm$Strategy[(ptrlbs + POPlbs > thdlbs + dovlbs + sablbs) & (ptrlbs + POPlbs > whtlbs)] <- 'NSM'
LB.ShortForm$Strategy[(thdlbs + dovlbs + sablbs > ptrlbs + POPlbs) & (thdlbs + dovlbs + sablbs > whtlbs)] <- 'DWD' # TDS species
# LB.ShortForm$Strategy[(whtlbs > 10 * ptrlbs) & (whtlbs > 10 * (thdlbs + dovlbs + sablbs))] <- 'HAKE'
LB.ShortForm$Strategy[(whtlbs > 10 * ptrlbs) & (whtlbs > 10 * (thdlbs + dovlbs))] <- 'HAKE'  # Sablefish are far more often seen in hake tows then thornies or dover

Table(LB.ShortForm$Strategy, LB.ShortForm$GRID)


# *** May want to leave in Hake tows for Sablefish or other analysis***
LB.ShortForm.with.Hake.Strat <- LB.ShortForm
save(LB.ShortForm.with.Hake.Strat, file= "Funcs and Data/LB.ShortForm.with.Hake.Strat 25 Mar 2019.dmp")

# LB.ShortForm.BCC1.CLP1.RCK1 <- LB.ShortForm
# save(LB.ShortForm.BCC1.CLP1.RCK1, file= "Funcs and Data/LB.ShortForm.BCC1.CLP1.RCK1 21 Aug 2018.dmp")  # "YTRK"

N.with.Hake <- nrow(LB.ShortForm)
LB.ShortForm.No.Hake.Strat <- LB.ShortForm[!(LB.ShortForm$Strategy %in% 'HAKE'),] # Rows = 976,494,  Cols = 50
100 * (1 - nrow(LB.ShortForm.No.Hake.Strat)/N.with.Hake) # Percent of hake tows removed
Table(LB.ShortForm.No.Hake.Strat$Strategy, LB.ShortForm.No.Hake.Strat$GRID)



# Principal components approach from Kot
# DatG$PC <- "PC3"
# DatG$PC[DatG$CPUE_petrale <= quantile(DatG$CPUE_petrale, 0.75) & DatG$CPUE_dover > quantile(DatG$CPUE_dover, 0.50) & 
#               DatG$CPUE_thorny <= quantile(DatG$CPUE_thorny, 0.75) & DatG$CPUE_sablefish <= quantile(DatG$CPUE_sablefish, 0.75)] <- "PC2"
# DatG$PC[DatG$CPUE_petrale > quantile(DatG$CPUE_petrale, 0.50) & DatG$CPUE_dover <= quantile(DatG$CPUE_dover, 0.75) & 
#               DatG$CPUE_thorny <= quantile(DatG$CPUE_thorny, 0.75) & DatG$CPUE_sablefish <= quantile(DatG$CPUE_sablefish, 0.75)] <- "PC1"


# Save without added species
save(LB.ShortForm.No.Hake.Strat, file= "Funcs and Data/LB ShortForm No Hake Strat 25 Mar 2019.dmp")

# Species added above
# save(LB.ShortForm.No.Hake.Strat, file= "Funcs and Data/LB ShortForm No Hake Strat 26 Jan 2018.dmp")  # LCOD & POP
# save(LB.ShortForm.No.Hake.Strat, file= "Funcs and Data/LB.ShortForm.No.Hake.Strat 22 Mar 2017.dmp")  # "YTRK"



# Check Data

if(F) {

   Table(LB.ShortForm.No.Hake.Strat$ARID_PSMFC, LB.ShortForm.No.Hake.Strat$State.Waters)

   change(LB.ShortForm.No.Hake.Strat[is.na(LB.ShortForm.No.Hake.Strat$State.Waters), ])
   imap()
   points(SET_LONG, SET_LAT, col='red') # Some good tows can appear on land due to the use of Logbook blocks.

   change(LB.ShortForm.No.Hake.Strat[LB.ShortForm.No.Hake.Strat$ARID_PSMFC %in% '4A', ])
   points(SET_LONG, SET_LAT, col='green')  # These 5 points appear in the ocean not in the Puget Sound (3B or perhaps 3A)

   # change(LB.ShortForm.No.Hake.Strat)
   change(LB.ShortForm)

   agg.table(aggregate(list(LCOD.mt = LCOD.kg/1000), List(RYEAR, Strategy), sum))
   agg.table(aggregate(list(pop.mt = POP.kg/1000), List(RYEAR, Strategy), sum))
   agg.table(aggregate(list(BCC1.mt = BCC1.kg/1000), List(RYEAR, Strategy), sum))
   agg.table(aggregate(list(RCK1.mt = RCK1.kg/1000), List(RYEAR, Strategy), sum))
   agg.table(aggregate(list(CLP1.mt = CLP1.kg/1000), List(RYEAR, Strategy), sum))
  
   agg.table(aggregate(list(dov.kg = dovlbs/2204.62), List(RYEAR, Strategy), sum))
   agg.table(aggregate(list(ptr.kg = ptrlbs/2204.62), List(RYEAR, Strategy), sum))
   agg.table(aggregate(list(sab.kg = sablbs/2204.62), List(RYEAR, Strategy), sum))
   agg.table(aggregate(list(thd.kg = thdlbs/2204.62), List(RYEAR, Strategy), sum))
   r(agg.table(aggregate(list(sht.kg = whtlbs/2204.62), List(RYEAR, Strategy), sum)), 3)

   Table(LB.ShortForm$RYEAR, LB.ShortForm$AGID, LB.ShortForm$ptrlbs > 0)
   Table(LB.ShortForm$RYEAR, LB.ShortForm$AGID, LB.ShortForm$sablbs > 0)
   Table(LB.ShortForm$RYEAR, LB.ShortForm$AGID, LB.ShortForm$dovlbs > 0)
   Table(LB.ShortForm$RYEAR, LB.ShortForm$AGID, LB.ShortForm$POPlbs > 0)   
   Table(LB.ShortForm$RYEAR, LB.ShortForm$AGID, LB.ShortForm$thdlbs > 0)
   Table(LB.ShortForm$RYEAR, LB.ShortForm$AGID, LB.ShortForm$whtlbs > 0)
   
}






