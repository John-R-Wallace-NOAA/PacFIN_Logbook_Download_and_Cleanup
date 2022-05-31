


# Add species to the 'LB.ShortForm' file, each row of 'LB.ShortForm' will be a unique tow and the species catch (kg) will be in added columns

base::load("Funcs and Data/LBData.1981.2020.RData")  # Load main raw data, if not already loaded, used inside of PacFIN.Logbook.Catch.Effort.Sp() below

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

# LB Shortform Final 12 Apr 2021 is currently in the 'OLD' directory since 'LB Shortform Final 9 May 2022.RData' is an example from the new code that will be used in complete redo.
load("Funcs and Data/LB Shortform Final 12 Apr 2021.RData") # Only good tows in LB.ShortForm # rows = 1,088,460,  cols = 52
Source("Funcs and Data/PacFIN.Logbook.Catch.Effort.Sp.R") # Species or species group aggregate catch function - small helper function - straight source()'ing


# ******** Add extra species here  *****************

# SP.List <- list(LCOD.kg = c("LCOD", "LCD1"), POP.kg = c("POP1", "POP2", "UPOP"), WDW1.kg = "WDW1") # ** kg label here **
# SP.List <- list(YTRK.kg = c("YTRK", "YTR1")) # ** kg label here **
# SP.List <- list(POP.kg = c("POP1", "POP2", "UPOP"))
# SP.List <- list(DSRK.kg = "DSRK")

# All FMP species from Jameal
SP.List <- list(         # ** kg label here, but changed to kg below**
  ARR1.kg = c("ARR1"),
  ARTH.kg = c("ART1", "ARTH"),
  BCC1.kg = c("BCC1"),
  BGL1.kg = c("BGL1"),
  BLK1.kg = c("BLK1"),
  BLU1.kg = c("BLU1"),
  BNK1.kg = c("BNK1"),
  BRW1.kg = c("BRW1"),
  BRZ1.kg = c("BRZ1"),
  BSKT.kg = c("BSKT"),
  BSOL.kg = c("BSOL"),
  BYL1.kg = c("BYL1"),
  CBZN.kg = c("CBZ1", "CBZN"),
  CHN1.kg = c("CHN1"), # weird that CHNA does not occur in the data?
  CLP1.kg = c("CLP1"), # weird that CLPR does not occur in the data?
  CNR1.kg = c("CNR1"), # weird that CNRY does not occur in the data?
  COP1.kg = c("COP1"),  # weird that COPP does not occur in the data?
  CSKT.kg = c("CSKT"),
  CSOL.kg = c("CSOL"),
  CWC1.kg = c("CWC1"), # weird that CWCD does not occur in the data?
  DBR1.kg = c("DBR1"), # weird that DBRK does not occur in the data?
  DOVR.kg = c("DOVR", "DVR1"),
  DSRK.kg = c("DSRK"),
  EGLS.kg = c("EGL1", "EGLS"),
  FLG1.kg = c("FLG1"),
  FSOL.kg = c("FSOL"),
  GBL1.kg = c("GBL1"),
  GPH1.kg = c("GPH1"),
  GRDR.kg = c("GRDR"),
  GRS1.kg = c("GRS1"),
  GSP1.kg = c("GSP1"),
  GSR1.kg = c("GSR1"),
  HNY1.kg = c("HNY1"),
  KLPG.kg = c("KGL1", "KLPG"),
  KLP1.kg = c("KLP1"),
  LCOD.kg = c("LCOD", "LCD1"),
  LSKT.kg = c("LSKT"),
  LSP1.kg = c("LSP1"),
  LSRK.kg = c("LSRK"),
  NUSF.kg = c("NUSF"),
  NUSP.kg = c("NUSP"),
  NUSR.kg = c("NUSR"),
  OGRN.kg = c("OGRN"),
  OLV1.kg = c("OLV1", "OLVE"),
  ORCK.kg = c("ORCK"),
  OSKT.kg = c("OSKT"),
  PCOD.kg = c("PCOD"),
  PDAB.kg = c("PDAB", "PDB1"),
   POP.kg = c("POP1", "POP2", "UPOP"),
  PRR1.kg = c("PRR1"),
  PTRL.kg = c("PTR1", "PTRL"),
  PWHT.kg = c("PWHT"),
  QLB1.kg = c("QLB1"),
  RATF.kg = c("RATF"),
  RBR1.kg = c("RBR1"),
  RCK1.kg = c("RCK1"),
  RCK7.kg = c("RCK7"),
  RCK9.kg = c("RCK9"),
  RDB1.kg = c("RDB1"),
   REX.kg = c("REX", "REX1"),
  ROS1.kg = c("ROS1"),
  RSOL.kg = c("RSL1","RSOL"),
  RST1.kg = c("RST1"),
  SABL.kg = c("SABL"),
  SBL1.kg = c("SBL1"),
  SCR1.kg = c("SCR1"),
  STRY.kg = c("SFL1", "STRY"),
  SNS1.kg = c("SNS1"),
  SPK1.kg = c("SPK1"),
  SQR1.kg = c("SQR1"),
  SSOL.kg = c("SSO1", "SSOL"),
  SSP1.kg = c("SSP1"),
  SSRK.kg = c("SSRK"),
  STL1.kg = c("STL1"),
  STR1.kg = c("STR1"),
  SWS1.kg = c("SWS1"),
  TGR1.kg = c("TGR1"),
  THDS.kg = c("THDS"),
  TRE1.kg = c("TRE1"),
  URCK.kg = c("URCK"),
  USHR.kg = c("USHR"),
  USKT.kg = c("USKT"),
  USLF.kg = c("USLF"),
  USLP.kg = c("USLP"),
  VRM1.kg = c("VRM1"),
  WDW1.kg = c("WDW1"),
  YEY1.kg = c("YEY1"),
  YTR1.kg = c("YTR1")
  )

for ( i in 1:length(SP.List)) {
     cat("\n", names(SP.List)[i], "\n"); flush.console()
     tmp <- PacFIN.Logbook.Catch.Effort.Sp(SP.List[[i]], LBData = LBData.1981.2020)
     tmp[,ncol(tmp)] <- tmp[,ncol(tmp)]/2.20462262 # ** Converting from lbs to kg here **
     names(tmp)[ncol(tmp)] <- names(SP.List)[i]
     LB.ShortForm <- match.f(LB.ShortForm, tmp, "Key", "Key", ncol(tmp))
}

LB.ShortForm[1:4,]


# sum = 0, testing new method with match.f() with old method using POP
# sum(LB.ShortForm$POPlbs/2.20462262 - LB.ShortForm$POP.kg) 

# Check with Lingcod (sum = 0)
sum(LB.ShortForm$lcodlbs/2.20462262 - LB.ShortForm$LCOD.kg) 



# ******** Done adding species *****************




# Overwrite WDFW's DURATION with WDFW's ADJ_TOWTIME for WA 
LB.ShortForm$DURATION[LB.ShortForm$AGID  %in% 'W' & !is.na(LB.ShortForm$ADJ_TOWTIME)] <- LB.ShortForm$ADJ_TOWTIME[LB.ShortForm$AGID  %in% 'W' & !is.na(LB.ShortForm$ADJ_TOWTIME)]


# Remove OR 1993 trip with 760 mt of catch
LB.ShortForm[LB.ShortForm$TRIP_ID %in% '482131', ]
dim(LB.ShortForm)
LB.ShortForm <- LB.ShortForm[!LB.ShortForm$TRIP_ID %in% '482131', ]
dim(LB.ShortForm)


# Tow duration limits 
N.with.all.tows <- nrow(LB.ShortForm)
LB.ShortForm <- LB.ShortForm[
       (LB.ShortForm$DURATION > 0.2) &       # records with tow duration > 0.2
       (LB.ShortForm$DURATION <= 24.0) &     # records with tow duration <= 24 hours  
       (!is.na(LB.ShortForm$DURATION)) 
       , ]
100 * (1 - nrow(LB.ShortForm)/N.with.all.tows) # 1.45% of tows removed
dim(LB.ShortForm)

# # N.with.Hake <- nrow(LB.ShortForm)
# # LB.ShortForm.No.Hake.Strat <- LB.ShortForm[!(LB.ShortForm$Strategy %in% 'HAKE'),] # Rows = 976,494,  Cols = 50


# ================ Could also add a state waters by latitude column ========================
# Specify state waters where catch was taken - areas for analsyis using ARID_PSMFC
LB.ShortForm$State.Waters.PSMFC <- NA
LB.ShortForm$State.Waters.PSMFC[LB.ShortForm$ARID_PSMFC %in% c("3A", "3B", "3S", "3C", "3S", "3D")] <- "WA" #  # 3S [SOUTHERN PORTION OF AREA 3C (UNITED STATES ONLY)] added - JRW
LB.ShortForm$State.Waters.PSMFC[LB.ShortForm$ARID_PSMFC %in% c("2B", "2C", "2A", "2E", "2F")] <- "OR"  
LB.ShortForm$State.Waters.PSMFC[LB.ShortForm$ARID_PSMFC %in% c("1A", "1B", "1C")] <- "CA"            



# Clusters of midwater tows in PacFIN are mislabeled. Bathymetric depth will be used for midwater tows (see DataProcessExplore - JRW.R)
# Midwater tows with a GRID label of 'MDT' can not only be Hake tows but also tows for Widow and/or Yellowtail.

# Strategies based in part Jean Beyer Rogers work on Numerical Definition of Groundfish Assemblages: https://cdnsciencepub.com/doi/pdf/10.1139/f92-293

# Need to improve this strategy using more species and split 'OTHER' into Bottom Rockfish (BRF) and other strategies given in the Rogers paper.  
# However, perhaps using Midwater (only mentioned once in the Rogers paper) for Widow and Yellowtail and not just a Widow (WID) strategy.

# Fix up old Sablefish lbs
LB.ShortForm$sablbs <-  LB.ShortForm$sablbs - LB.ShortForm$SBL1.kg * 2.20462262
save(LB.ShortForm, file = 'Funcs and Data/LB.ShortForm, All FMP Species.RData')

base::load("W:\\ALL_USR\\JRW\\PacFIN & RACEBASE.R\\Main PacFIN Logbook Cleanup - 2021\\Funcs and Data\\LB.ShortForm, All FMP Species.RData") # Loads 'LB.ShortForm'


change(LB.ShortForm) # Rows = 1,072,706 (was 1,048,814); Cols = 141 (was 52)

# Move to testing with the new *.kg species

# Grrr - found that a delta is needed a the finite math issue.
# The '>' test is FALSE when the lbs on the LHS and RHS are exactly equal, but sometimes that is not the case when the conversion to kilograms was done first.

        Sp_LHS Sp_RHS       Sp        Sp.factor_LHS        Sp.factor_RHS    Sp.factor   Diff
46766       11     11    FALSE   4.9895160741841620   4.9895160741841611         TRUE     -1
133835       6     6     FALSE   2.7215542222822702   2.7215542222822697         TRUE     -1
230362     263    263    FALSE 119.2947934100395031 119.2947934100394889         TRUE     -1
279875     207    207    FALSE  93.8936206687383219  93.8936206687383077         TRUE     -1


# Old post hoc Strategy using lbs
Delta <- 0.0001 

LB.ShortForm$Strategy_OLD <- 'OTHER'
# LB.ShortForm$Strategy_OLD <- 'BRF' 

LB.ShortForm$Strategy_OLD[(ptrlbs + POPlbs > thdlbs + dovlbs + sablbs + Delta) & (ptrlbs + POPlbs > whtlbs + Delta)] <- 'NSM'
LB.ShortForm$Strategy_OLD[(thdlbs + dovlbs + sablbs > ptrlbs + POPlbs + Delta) & (thdlbs + dovlbs + sablbs > whtlbs + Delta)] <- 'DWD' # TDS species
# LB.ShortForm$Strategy_OLD[(whtlbs > 10 * ptrlbs) & (whtlbs > 10 * (thdlbs + dovlbs + sablbs))] <- 'HAKE'
LB.ShortForm$Strategy_OLD[(whtlbs > 10 * ptrlbs + Delta) & (whtlbs > 10 * (thdlbs + dovlbs) + Delta)] <- 'HAKE'  # Sablefish are far more often seen in hake tows than thornies or dover

Table(LB.ShortForm$Strategy_OLD, LB.ShortForm$GRID)

# Check that Strategy based on kilograms is the same as the one based on lbs
Delta <- 0.0001/2.20462262

LB.ShortForm$Strategy_CHECK <- 'OTHER'

LB.ShortForm$Strategy_CHECK[(PTRL.kg + POP.kg > LSP1.kg + SSP1.kg + DOVR.kg + SABL.kg + Delta) & (PTRL.kg + POP.kg > PWHT.kg + Delta)] <- 'NSM'
LB.ShortForm$Strategy_CHECK[(LSP1.kg + SSP1.kg + DOVR.kg + SABL.kg > PTRL.kg + POP.kg + Delta) & (LSP1.kg + SSP1.kg + DOVR.kg + SABL.kg > PWHT.kg + Delta)] <- 'DWD' # TDS species
LB.ShortForm$Strategy_CHECK[(PWHT.kg > 10 * PTRL.kg + Delta) & (PWHT.kg > 10 * (LSP1.kg + SSP1.kg + DOVR.kg) + Delta)] <- 'HAKE'  # Sablefish are far more often seen in hake tows than thornies or Dover
                        
Table(LB.ShortForm$Strategy_CHECK, LB.ShortForm$GRID)

# With using the Delta, the lbs and kilograms are now the same
Table(LB.ShortForm$Strategy_OLD, LB.ShortForm$Strategy_CHECK)
          DWD   HAKE    NSM  OTHER
  DWD   521677      0      0      0
  HAKE       0  51127      0      0
  NSM        0      0 258239      0
  OTHER      0      0      0 241663
  
  
# Clean up  
LB.ShortForm$Strategy_OLD <- NULL
LB.ShortForm$Strategy_CHECK <- NULL
names(LB.ShortForm)[grep('lbs', names(LB.ShortForm))]
LB.ShortForm[, names(LB.ShortForm)[grep('lbs', names(LB.ShortForm))]] <- NULL


# -- Extra info on finite math --
# Dividing first with a factor can change equal to not equal (Hmm, did I learn this in high school way before double precision was a thing?)

c(11.3398092595094582, 3.6287389630430265 + 7.7110702964664313)
[1] 11.339809259509458 11.339809259509458 # Equal 

# Divide first, then sum
c(11.3398092595094582/2.2, 3.6287389630430265/2.2 + 7.7110702964664313/2.2)
[1] 5.1544587543224809 5.1544587543224800 # Not equal

# Sum first and then divide
c(11.3398092595094582/2.2, (3.6287389630430265 + 7.7110702964664313)/2.2)
[1] 5.1544587543224809 5.1544587543224809  # Equal


# New post hoc Strategy - now with Widow and Yellowtail testing
LB.ShortForm$Strategy <- 'OTHER'

LB.ShortForm$Strategy[(PTRL.kg + POP.kg > LSP1.kg + SSP1.kg + DOVR.kg + SABL.kg + Delta) & (PTRL.kg + POP.kg > PWHT.kg + Delta)] <- 'NSM'
LB.ShortForm$Strategy[(LSP1.kg + SSP1.kg + DOVR.kg + SABL.kg > PTRL.kg + POP.kg + Delta) & (LSP1.kg + SSP1.kg + DOVR.kg + SABL.kg > PWHT.kg + Delta)] <- 'DWD' # TDS species
LB.ShortForm$Strategy[(PWHT.kg > 10 * PTRL.kg + Delta) & (PWHT.kg > 10 * (LSP1.kg + SSP1.kg + DOVR.kg) + Delta) &
                        (PWHT.kg > 2 * (WDW1.kg) + Delta) & (PWHT.kg > 2 * (YTR1.kg) + Delta)] <- 'HAKE'  # Sablefish are far more often seen in hake tows than thornies or Dover

Table(LB.ShortForm$Strategy, LB.ShortForm$GRID)



   
# Look at the hake stategy with using the Total_All_FMP.kg
   
# Make sure Total_All_FMP.kg is gone, so a redo doesn't double count the catch
LB.ShortForm$Total_All_FMP.kg <- NULL
LB.ShortForm$Total_All_FMP.kg <- apply(LB.ShortForm[, names(LB.ShortForm)[grep('.kg', names(LB.ShortForm))]], 1, sum, na.rm = TRUE)

# Seems pretty reasonable - 'Strategy' holds up quite well
Table(LB.ShortForm$Strategy, LB.ShortForm$PWHT.kg > 1000 & LB.ShortForm$PWHT.kg > 0.75 * LB.ShortForm$Total_All_FMP.kg)

#         FALSE   TRUE
#  DWD   521452      0
#  HAKE    2838  48289
#  NSM   258277      0
#  OTHER 241832     18
      
         FALSE   TRUE
  DWD   521465      0
  HAKE    1338  48289
  NSM   258384      0
  OTHER 243212     18


# Repeat table from above - now showing the results
Table(LB.ShortForm$Strategy, LB.ShortForm$GRID) # One would assume that most all Hake tows are MDT - but not all MDT are Hake tows.
      
           FFT    FTS    GFL    GFS    GFT    MDT    OTW    RLT   <NA>
  DWD    96435  22453  22065   4242 246229   1353    453 126947   1288
  HAKE     112     38     18     30   1016  48303     14     95      1
  NSM    43631  22988   3285   8473 126062   1413   4408  46856   1268
  OTHER  18824   3040   2416  52493 119308  13167    829  29121   4032


Table(LB.ShortForm$Strategy %in% 'HAKE', LB.ShortForm$GRID)
      
           FFT    FTS    GFL    GFS    GFT    MDT    OTW    RLT   <NA>
  FALSE 158890  48481  27766  65208 491599  15933   5690 202924   6588
  TRUE     112     38     18     30   1016  48303     14     95      1


Table(LB.ShortForm$PWHT.kg > 1000 & LB.ShortForm$PWHT.kg > 0.75 * LB.ShortForm$Total_All_FMP.kg, LB.ShortForm$GRID)  
    
           FFT    FTS    GFL    GFS    GFT    MDT    OTW    RLT   <NA>
  FALSE 158966  48519  27783  65238 492135  16461   5704 203005   6588
  TRUE      36      0      1      0    480  47775      0     14      1

  
Table(LB.ShortForm$PWHT.kg > 3000 & LB.ShortForm$PWHT.kg > 0.5 * LB.ShortForm$Total_All_FMP.kg, LB.ShortForm$GRID)
       
           FFT    FTS    GFL    GFS    GFT    MDT    OTW    RLT   <NA>
  FALSE 158989  48519  27784  65238 492254  17049   5704 203006   6589
  TRUE      13      0      0      0    361  47187      0     13      0


# Hake tows are 4.63% of the total
N.with.Hake <- nrow(LB.ShortForm)
LB.ShortForm.No.Hake.Strat <- LB.ShortForm[!(LB.ShortForm$Strategy %in% 'HAKE'),] 
100 * (1 - nrow(LB.ShortForm.No.Hake.Strat)/N.with.Hake)


# *** Leave in Hake tows for Sablefish or other analysis***
LB.ShortForm.with.Hake.Strat <- LB.ShortForm
save(LB.ShortForm.with.Hake.Strat, file = "Funcs and Data/LB.ShortForm.with.Hake.Strat 26 Apr 2022.RData")

# Save a version with DRVID changed to Ves_num
LB.ShortForm.with.Hake.Strat.Ves_num <- LB.ShortForm.with.Hake.Strat
LB.ShortForm.with.Hake.Strat.Ves_num$DRVID <- as.numeric(factor(LB.ShortForm.with.Hake.Strat.Ves_num$DRVID))
names(LB.ShortForm.with.Hake.Strat.Ves_num)[grep("DRVID", names(LB.ShortForm.with.Hake.Strat.Ves_num))] <- "Ves_num"
save(LB.ShortForm.with.Hake.Strat.Ves_num,  file = "Funcs and Data/LB.ShortForm.with.Hake.Strat.Ves_num, 26 Apr 2022.RData")



# Add Chub & Jack mackerel; Not in the FMP but wanted by Derek
SP.List.Extra <- list(CMCK.kg = c("CMCK"), JMCK.kg = c("JMCK") )

LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel <- LB.ShortForm.with.Hake.Strat.Ves_num
for ( i in 1:length(SP.List.Extra)) {
     cat("\n", names(SP.List.Extra)[i], "\n"); flush.console()
     tmp <- PacFIN.Logbook.Catch.Effort.Sp(SP.List.Extra[[i]], LBData = LBData.1981.2020)
     tmp[,ncol(tmp)] <- tmp[,ncol(tmp)]/2.20462262 # ** Converting from lbs to kg here **
     names(tmp)[ncol(tmp)] <- names(SP.List.Extra)[i]
     LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel <- match.f(LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, tmp, "Key", "Key", ncol(tmp))
}

LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel[1:4,]

save(LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel, file = 'Funcs and Data/LB.ShortForm.with.Hake.Strat.Ves.num.Mackerel 26 May 2022.RData')



#   -------------- Yet more figures looking at depth - see the associated doc for many others ------------------------------

base::load("LB.ShortForm.with.Hake.Strat 21 Mar 2022.RData")


dev.new(width = 800, height = 500)
xyplot(DEPTH1 * 1.8288 ~ DepthGIS.m | GRID, group = AGID, auto = TRUE, main = "Years: 1997 - 2020", data = LB.ShortForm.with.Hake.Strat[LB.ShortForm.with.Hake.Strat$RYEAR >= 1997, ], 
   panel = function(...) { panel.abline(0,1, col = 'green');  panel.xyplot(...) })

   

dev.new(width = 800, height = 500)
xyplot(DEPTH1 * 1.8288 ~ DepthGIS.m | GRID, group = AGID, auto = TRUE, main = "Years: 1987 - 1996", data = LB.ShortForm.with.Hake.Strat[LB.ShortForm.with.Hake.Strat$RYEAR >= 1987 & 
             LB.ShortForm.with.Hake.Strat$RYEAR <= 1996, ], panel = function(...) { panel.abline(0,1, col = 'green');  panel.xyplot(...) })



library(JRWToolBox) 
library(Imap)

# GRID GFT with DepthGIS.m > 2000 
change(LB.ShortForm.with.Hake.Strat[LB.ShortForm.with.Hake.Strat$RYEAR >= 1987 & LB.ShortForm.with.Hake.Strat$RYEAR <= 1996 
          & LB.ShortForm.with.Hake.Strat$GRID %in% 'GFT' & LB.ShortForm.with.Hake.Strat$DepthGIS.m > 2000, ] )
          
dev.new()
plotRAST(cbind(jitter(Best_Long, 20), jitter(Best_Lat)), longrange = c(-125.75, -124), latrange = c(40.05, 41.6), 
         col.pts = 'Dodger blue', levels.contour = seq(-11000, 9000, by = 500) )
points(Best_Long, Best_Lat, pch = '.', col = 'red', cex = 2.5)



# GRID GFT with DepthGIS.m > 2000 and DEPTH1 * 1.8288 < 500
change(LB.ShortForm.with.Hake.Strat[LB.ShortForm.with.Hake.Strat$RYEAR >= 1987 & LB.ShortForm.with.Hake.Strat$RYEAR <= 1996 
          & LB.ShortForm.with.Hake.Strat$GRID %in% 'GFT' & LB.ShortForm.with.Hake.Strat$DepthGIS.m > 2000 & LB.ShortForm.with.Hake.Strat$DEPTH1 * 1.8288 < 500 , ] )
          
dev.new()                    
plotRAST(cbind(jitter(Best_Long), jitter(Best_Lat, 0.5)), longrange = c(-126, -124), latrange = c(41.5, 43.5), 
         col.pts = 'Dodger blue', levels.contour = seq(-11000, 9000, by = 500) )
points(Best_Long, Best_Lat, pch = '.', col = 'red')

   

    