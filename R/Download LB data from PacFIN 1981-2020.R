#############################################################################################################################################
## Initial code from the data preparation and exploration for FATE petrale ROMS-IBM project
##             which was modified from the 2013 CPUE standardization for the stock assessment
## This code is for all logbook data through 2018
## Changes to add species in columns to a logbook shortform where each row is a unique tow was done by John Wallace
#############################################################################################################################################


#header descriptions -  these are old and are from the 2013 analysis, but may still be usefull
#"OBJECTID"    Unique ID for Row Number, same value as FID_ALL_LB…
#"FID_ALL_LBhauls_87_09_SetPt"     Unique ID for Set Point, same value as OBJECTID
#"RYEAR"     return year
#"DRVID"    derived vessel ID, usually CG
#"TRIP_ID"    Key to lbk_trip
#"TOWNUM"    Key to lbk_tow                    
#"AGID"        Data source agency ID
#"RPCID"    PacFIN return port code (link to pc)
#"bimo"     bimontly period                      
#"DDATE"    Date of departure, Orcale date truncated to 12 am
#"RDATE"    Date of return, Orcale date truncated to 12 am
#"TOWDATE"      tow date             
#"SET_LAT"    latitude of set position converted from degrees/minutes to degrees.decimal
#"SET_LONG"    longitude of set position converted from degrees/minutes to degrees.decimal
#"UP_LAT"    lat at end of tow                    
#"UP_LONG"    long at end of tow
#"LATLONG_TYPE"    source of lat/long info,L = Logbook entry,C = Center of area, entered by agency staff                 #
#                    B = Center position of block, from the block_pos table
#"SET_TIME"    time net was set (hhmm)                   
#"UP_TIME"    time net was hauled up (hhmm)                               
#"DURATION"    tow duration (up-set time) in hours
#"ADJ_TOWTIME"     WDFW adjusted tow time, represents missing logs as well.
                    #  This is the (logbook) extrapolated and adjusted tow time from WDFW. Best data availabe from WDFW.                              
#"ARID_PSMFC"    PSMFC area ID, might be filled from block_pos table set position                                                                 
#"BLOCK"    block number (10xl0 minutes): set position
#"BLOCK_OR"    ODFW 5x5 minutes block number: set position                
#"GRID"        Gear ID: a gear code, gear group or 'all'                                          
#"PACFIN_TARGET"tow species target
#"FTID"        fish ticket identifier
#"TICKET_DATE"    date on fish ticket                
#"DEPTH1"    1st depth in fathoms (see depth_type1)                      
#"PERMID_1"    permit number 1
#"LEN_ENDOR_1"    vessel size  
#"SPID"            species ID 
#"APOUNDS"      adjusted pounds
#"APOUNDS_WDFW" Ticket adjusted pounds for WDFW only (representing missing logs as well) - 
              #      This is the (logbook) extrapolated and adjusted lbs from WDFW. Best data availabe from WDFW.          

#"fltlbs"    flatfish lbs
#"ptrlbs"    petrale lbs
#"dovlbs"        dover lbs   
#"rcklbs"    rockfish lbs
#"thdlbs"    thornyhead lbs
#"wdwlbs"    widow lbs                     
#"sablbs"    sablefish lbs
#"whtlbs"    whiting lbs
#"gflbs"    total groundfish lbs                  
#"ngflbs"    total non-groundfish lbs
#"apounds"    check this, should be adjusted lbs? 
#"latgrp"    jim's grouping               
#"depgrp"    jim's grouping
#"dtslbs"    dover,thornyhead,sablefish lbs
#"SET_LATDD"    Set point latitude in decimal degrees
#"SET_LONDD"    Set point longitude in decimal degrees


################################# READ IN LOGBOOK DATA ###########################################


# Select wanted PacFin columns - APOUNDS_CALCULATED is a flag, so not needed  - hpounds (hail lbs) may be useful but was not included
PacFinCols <- c("RYEAR", "DRVID", "TRIP_ID", "TOWNUM", "AGID", "RPCID", "RDAY", "DDATE", "RDATE", "TOWDATE", "SET_LAT", "SET_LONG", "UP_LAT", 
      "UP_LONG", "LATLONG_TYPE", "SET_TIME", "UP_TIME", "DURATION", "ADJ_TOWTIME", "ARID_PSMFC", "BLOCK", "BLOCK_OR", "GRID", "PACFIN_TARGET", "FTID", 
      "TICKET_DATE", "DEPTH1", "DEPTH_TYPE1", "PERMID_1", "LEN_ENDOR_1", "SPID", "APOUNDS", "APOUNDS_WDFW")

# Source the function that downloads PacFIN logbook data by year
Source("Funcs and Data/PacFIN Logbook Data by Year.R")

# Getting all the years of data from PacFIN takes 8-10 hours (good for an overnight run). PacFIN.Login and PacFIN.PW are set in Main script.

# LBData.1981.2020 <- PacFIN.Logbook.Data.by.Year(1981, uid = PacFIN.Login, pwd = PacFIN.PW)[,PacFinCols]

LBData.1981.2020 <- NULL 
for ( i in 1981:2020) { 
       cat("\n\nYear", i, "\n")
       LBData.1981.2020 <- rbind(LBData.1981.2020, PacFIN.Logbook.Data.by.Year(i, uid = PacFIN.Login, pwd = PacFIN.PW)[,PacFinCols]) # Downloading a few colums that are not used 
}

       
# Saved again later with bimo and Key columns and other changes, saved the raw data here because of the long download time. 
save(LBData.1981.2020, file = "Funcs and Data/LBData.1981.2020.RData")  


      if(F) {
      # For testing a new years worth of data, but changes to older years may happen
      Test.2016 <- PacFIN.Logbook.Data.by.Year(2016, uid = PacFIN.Login, pwd = PacFIN.PW)[, PacFinCols]
       Test.2016$DDATE <- as.Date(Test.2016$DDATE, "%d-%b-%Y")
      Test.2016$RDATE <- as.Date(Test.2016$RDATE, "%d-%b-%Y")
      Test.2016$bimo <- ceiling(as.numeric(recode.simple(months(Test.2016$RDATE, T) , cbind(c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"), 1:12)))/2)
      Test.2016$SET_LONG <- - Test.2016$SET_LONG
      Test.2016$Key <- paste(Test.2016$AGID, Test.2016$TRIP_ID, Test.2016$TOWNUM)  # Unique key 
      # base::load('Funcs and Data/LBData.1981.2016.RData')
      dim(LBData.1981.2016)
      LBData.1981.2016 <- rbind(LBData.1981.2016, Test.2016)
      }

dim(LBData.1981.2020)
head(LBData.1981.2020)

# The PacFIN SQL functions: pfutil.bimon_period() and pfutil.undelimit() no longer exist.
# Kayleigh Somers has had Rob Ames make new SQL scripts for the logbook extraction (Talked to Kayleigh on 27 Sept 2018).  
# Sticking with the old SQL here that has been modified to not use those functions, since otherwise the code is broken.
# "bimo" which was calculated in SQL with the pfutil.bimon_period() function is now calculated below.


# Check if there is data for OR and WA before 1987
Table(LBData.1981.2020$RYEAR, LBData.1981.2020$AGID)  # JRWToolBox::Table() function defaults to show the NA's, unlike table(). Seeing the NA's is alsmost always important in fisheries work.
N <- nrow(Table(LBData.1981.2020$RYEAR, LBData.1981.2020$AGID))

# # Example test using 1984
# import.sql("Select * from pacfin.lbk_trip where rownum < 11 and AGID = 'C' and RYEAR  = 1984", dsn="PacFIN", uid=PacFIN.Login, pwd=PacFIN.PW) # Data for CA
# import.sql("Select * from pacfin.lbk_trip where rownum < 11 and AGID = 'W' and RYEAR  = 1984", dsn="PacFIN", uid=PacFIN.Login, pwd=PacFIN.PW) # No data for WA nor OR ('O') before 1987

# # Compare to older data - the numbers by year and state agency are equal

# Compare to 2018b
base::load("..\\Main PacFIN Logbook Cleanup - 2018b\\Funcs and Data\\LBData.1981.2018.dmp") 
Table(LBData.1981.2018$RYEAR, LBData.1981.2018$AGID)
Table(LBData.1981.2020$RYEAR, LBData.1981.2020$AGID)[-((N - 1):N), ] - Table(LBData.1981.2018$RYEAR, LBData.1981.2018$AGID)


# Compare to 2015 data - 2017 analysis
base::load("..\\Main PacFIN Logbook Cleanup - 2015\\Funcs and Data\\LBData.1981.2015.dmp")
Table(LBData.1981.2015$RYEAR, LBData.1981.2015$AGID)
Table(LBData.1981.2020$RYEAR, LBData.1981.2020$AGID)[-((N - 4):N), ] - Table(LBData.1981.2015$RYEAR, LBData.1981.2015$AGID)





# Change the character dates into the R "Date" class, create the bimonthly [ (Jan, Feb) = 1, (Mar, Apr) = 2, ... ] column: 'bimo', and make the Western hemisphere longitudes negative.
LBData.1981.2020$DDATE <- as.Date(LBData.1981.2020$DDATE, "%d-%b-%Y")
LBData.1981.2020$RDATE <- as.Date(LBData.1981.2020$RDATE, "%d-%b-%Y")
LBData.1981.2020$bimo <- ceiling(as.numeric(recode.simple(months(LBData.1981.2020$RDATE, T) , cbind(c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"), 1:12)))/2)
LBData.1981.2020$SET_LONG <- - LBData.1981.2020$SET_LONG
LBData.1981.2020$UP_LONG <- - LBData.1981.2020$UP_LONG

# Create a unique tow key 
LBData.1981.2020$Key <- paste(LBData.1981.2020$AGID, LBData.1981.2020$TRIP_ID, LBData.1981.2020$TOWNUM)  
length(unique(LBData.1981.2020$Key)) # 1,145,548 (1,114,030 for 1981 - 2015)

# # Add even more items to a test key to check uniqeness
TestKey <- paste(LBData.1981.2020$AGID, LBData.1981.2020$TRIP_ID, LBData.1981.2020$TOWNUM, LBData.1981.2020$RYEAR, LBData.1981.2020$DRVID) 
length(unique(TestKey))  # 1,169,945 - same as above (1,145,548 for 1981-2018b; 1,114,030  for 1981-2015) 
rm(TestKey)

# Save the data, writing over the raw data above
save(LBData.1981.2020, file = "Funcs and Data/LBData.1981.2020.RData") 











