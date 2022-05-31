


# ================ Create BestBtmDepth (meters) ======================================================
  
    base::load("Funcs and Data/LB GIS Depths Dat 12 Apr 2021.RData") 
    
    #  DEPTH1 has the best (only) depths for the midwater tows, but it appears that some midwater depths in PacFIN are on the bottom --------
    
    Dat$BestBtmDepth.m <- Dat$DEPTH1 * 1.8288 # Fathoms to meters 
    Dat$BestBtmDepth.m[is.na(Dat$BestBtmDepth.m) | Dat$GRID %in% 'MDT'] <- Dat$DepthGIS.m[is.na(Dat$BestBtmDepth.m) | Dat$GRID %in% 'MDT'] 
    
    # Type 'A' for DEPTH_TYPE1 isn't clear if it's average over depth of the bottom or average over depth of the net
       
    # Here is the DEPTH_TYPE1 breakdown for 2016 only     
    # #            C     O     W
    # #   A        0 69057  5670
    # #   <NA> 23170     0     0
    # # 
    
    # -----------  Reported vs GIS depth for midwater hauls only ---------------------
    
    # Look at extra deep DepthGIS.m and all the data 
    Dat[Dat$DepthGIS.m %>>% 10000,]
    
    load("Funcs and Data\\EEZ.Polygon.WestCoast.RData")
    load("Funcs and Data\\Points.out.of.Dat.and.polygons.RData")
    
    # dir.create("Figs")
    
    for(PNG in c(FALSE, TRUE)) {
       if(PNG)
          png(paste0("Figs/All Data on Coast.png"), 2000, 2000)
       ilines(list(world.h.land, world.h.borders, EEZ.Polygon.WestCoast, BankPolygon, CoastWidePolygon), c(-135, -116), c(29.5, 49.5), zoom = F)
       points(Dat[, c('SET_LONG', 'SET_LAT')], pch='.')
       # points(Dat[Dat$Key %in% 'O 1121790 7', c('SET_LONG', 'SET_LAT')], col= 'red') 
       ilines(list(world.h.land, world.h.borders, EEZ.Polygon.WestCoast, BankPolygon, CoastWidePolygon), add = TRUE, zoom = FALSE) 
       if(PNG)
          dev.off()
    }
    
    
    # Midwater - without Dat$GoodTow (see below for with Dat$GoodTow)
    dir.create("Figs/GIS Depth by Reported Depth/", recursive = TRUE)
    for( i in unique(Dat$AGID)) {
      png(paste0("Figs/GIS Depth by Reported Depth/Depths, All Tows, MidWater, State ", i, ".png"), 960, 960)
      print(xyplot(DepthGIS.m ~ DEPTH1*1.8288 | factor(RYEAR), data = Dat[Dat$GRID %in% 'MDT' & Dat$AGID %in% i & Dat$DepthGIS.m < 1500,],
          panel = function(...) { panel.xyplot(...); panel.abline(0,1, col='red'); panel.abline(h = 0, col='green', lty =2)}, xlab = "Reported Depth (meters)", 
          ylab = "GIS Estimated Depth (meters)", main = paste0("State ", i, "; Midwater; All Tows")))
      dev.off() 
    }
    
    # Non-Midwater - without Dat$GoodTow (see below for with Dat$GoodTow)
    for( i in unique(Dat$AGID)) {
      png(paste0("Figs/GIS Depth by Reported Depth/Depths, All Tows, Non-MidWater, State ", i, ".png"), 960, 960) 
      print(xyplot(DepthGIS.m ~ DEPTH1*1.8288 | factor(RYEAR), data = Dat[!Dat$GRID %in% 'MDT' & Dat$AGID %in% i & Dat$DepthGIS.m < 1500,],
          panel = function(...) { panel.xyplot(...); panel.abline(0,1, col='red'); panel.abline(h = 0, col='green', lty =2)}, xlab = "Reported Depth (meters)", 
          ylab = "GIS Estimated Depth (meters)", main = paste0("State ", i, "; Non-Midwater; All Tows")))
    dev.off()      
    }
    
    # ---------  Come back here after creating 'GoodTow' below ------
    for( i in unique(Dat$AGID)) {
      png(paste0("Figs/GIS Depth by Reported Depth/Depths, Good Tows, State ", i, ".png"), 960, 960)
      print(xyplot(DepthGIS.m ~ DEPTH1*1.8288 | factor(RYEAR), data = Dat[!Dat$GRID %in% 'MDT' & Dat$AGID %in% i & Dat$DepthGIS.m < 1500 & Dat$GoodTow & !(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long)),],
          panel = function(...) { panel.xyplot(...); panel.abline(0,1, col='red'); panel.abline(h = 0, col='green', lty =2)}, xlab = "Reported Depth (meters)", 
          ylab = "GIS Estimated Depth (meters)", main = paste0("State ", i, "; Non-Midwater; Good Tows Only")))
      dev.off()    
    }
    
    
    # -----------  Look for reasonable midwater bottom depth limit ---------------------
    change(Dat[Dat$InsideAllPoly & Dat$GRID %in% 'MDT', ])
    aggregate(list(DEPTH1.fth = DEPTH1), List(RYEAR), max, na.rm=T)
    aggregate(list(BestBtmDepth.ftm = BestBtmDepth.m/1.8288), List(RYEAR), max, na.rm=T)
    Table(Dat[Dat$BestBtmDepth.m/1.8288 >= 1500, "GRID"], Dat[Dat$BestBtmDepth.m/1.8288 >= 1500, "RYEAR"])
    Table(Dat[Dat$BestBtmDepth.m/1.8288 >= 900, "GRID"], Dat[Dat$BestBtmDepth.m/1.8288 >= 900, "RYEAR"])

    # -----------  Look for reasonable depth difference between GIS and reported depth ---------------------
    Dat$DepthDiff.m <- abs(Dat$DepthGIS.m - Dat$DEPTH1 * 1.8288 )
    histogram(~ DepthDiff.m | factor(RYEAR), data = Dat[Dat$DepthGIS.m < 1500, ], panel= function(...) {panel.histogram(...); panel.abline(v=c(250, 500))})

    Dat$DepthDiff.m <- NULL
    
    
# ================ Create GoodTow ======================================================


################### Conditions for leaving in a tow ############################
#  A tow reported in a block before 1997 is in as long as the depth is less than 2000 meters and greater than -100, The depth can be negative (i.e. on land) since a centroid
#      can be deeper than a tow within the block and some centorids are on land. (Used Imap::depthMeters() on all the centroids to check.)
# The depth also needs to be between 0 and 1,500 meters
################################################################################


# --- More restriction for poor depth reporting ---
# Changed depth difference limit from 500 to 250 meters after (re)running VAST with Region = "Other" and CA Current for Petrale Winter fishery 
#             and looking for reasonable depth differences between GIS and reported depth - see above
# Also changed the depth limit for non-midwater trawls to 1281 m (700 fathoms)
# DatG <- DatG[(abs(DatG$DEPTH1*1.8288 - DatG$DepthGIS.m) %<=% 250 | is.na(DatG$DEPTH1)) & DatG$DepthGIS.m %<=% 1281,] 


# Note again, that DEPTH1 stays missing in lieu of over being greater than 250 m from the GIS depth - better to be missing than far off.
# Dat$InDepthDiffLimit <- abs(Dat$DepthGIS.m - Dat$DEPTH1 * 1.8288 ) < 500  | is.na(Dat$DEPTH1) # Absolute difference between DEPTH1 (fathoms) * 1.8288 and DepthGIS.m less than 500 meters or DEPTH1 can be missing

# Absolute difference between DEPTH1 (fathoms) * 1.8288 and DepthGIS.m less than 250 meters (500 meters for block reporting) or DEPTH1 can be missing
Dat$InDepthDiffLimit <- abs(Dat$DepthGIS.m - Dat$DEPTH1 * 1.8288 ) < 250 | is.na(Dat$DEPTH1)
Dat$InDepthDiffLimit_Block <- abs(Dat$DepthGIS.m - Dat$DEPTH1 * 1.8288 ) < 500 | is.na(Dat$DEPTH1)

# Best Depth between 0 and 1281 meters (700 fathoms) for non-blocks and best bottom depth between -100 (on land)  and 2000 meters (1094 fathoms)
Dat$InDepthLimit <- Dat$BestBtmDepth.m > 0.0 & Dat$BestBtmDepth.m < 1281
Dat$InDepthLimit_Block <- Dat$BestBtmDepth.m > -100.0 & Dat$BestBtmDepth.m < 2000

#  A midwater tow inside all poly and towing over a best bottom depth less than or equal to 1646 (900 fathoms) is also good 
Dat$GoodTow <- (Dat$InsideAllPoly & Dat$InDepthDiffLimit & Dat$InDepthLimit) |
               (!is.na(Dat$BLOCK) & Dat$RYEAR <= 1996 & Dat$InDepthLimit_Block & Dat$InDepthDiffLimit_Block) |
               (Dat$InsideAllPoly & Dat$GRID %in% 'MDT' & Dat$BestBtmDepth.m <= 900*1.8288 )

Dat$GoodTow2 <- ((Dat$InsideAllPoly & Dat$InDepthDiffLimit & Dat$InDepthLimit) |
               (!is.na(Dat$BLOCK) & Dat$RYEAR <= 1996 & Dat$InDepthLimit_Block & Dat$InDepthDiffLimit_Block) |
               (Dat$InsideAllPoly & Dat$GRID %in% 'MDT' & Dat$BestBtmDepth.m <= 900*1.8288 )) & !(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long))            
               
#  0.88% less tows
(nrow(Dat) - sum(Dat$GoodTow, na.rm = TRUE))/nrow(Dat)
#  # [1] 0.008800175
                
# Missing good tows are not good tows                
Table(Dat$RYEAR, Dat$GoodTow) 
Dat$GoodTow[is.na(Dat$GoodTow)] <- FALSE
Table(Dat$RYEAR, Dat$GoodTow) 

# Also removing any tows with missing lat or long
# *** Use Dat.SAVE, with missing lats, for the some of the checks below ***
Dat.SAVE <- Dat

dim(Dat[(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long)), ]) 
# 4% missing
100 * nrow(Dat[(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long)), ])/nrow(Dat)

Dat <- Dat[!(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long)), ]


Dat$InDepthDiffLimit <- Dat$InDepthDiffLimit_Block <- Dat$InDepthLimit <- Dat$InDepthLimit_Block <- Dat$InsidePoly <- Dat$InsideBankPoly <- NULL

LB.ShortForm <- Dat[Dat$GoodTow,] 

# Tow duration limits are in 'Add all FMP species to LB Shortform Dat.R' (1.45% of tows removed)
save(LB.ShortForm, file= "Funcs and Data/LB Shortform Final 12 Apr 2021.RData")  


# ============================== Checks ========================================================


# ----- An old LB.ShortForm version is needed here for comparison ----

base::load("..\\Main PacFIN Logbook Cleanup - 2018b\\Funcs and Data\\LB Shortform Final 25 Mar 2019.dmp")

Dat.OLD <- LB.ShortForm
Dat <- Dat.SAVE  # See above for Dat.SAVE

Table(Dat$RYEAR[Dat$GoodTow], Dat$AGID[Dat$GoodTow])[-(39:40), ] - Table(Dat.OLD$RYEAR[Dat.OLD$GoodTow], Dat.OLD$AGID[Dat.OLD$GoodTow])

Table(is.na(Dat$SET_LAT) & !is.na(Dat$Best_Lat), Dat$RYEAR, Dat$AGID)


# All states have some missing SET_LAT over the years
Table(!is.na(Dat$SET_LAT), Dat$RYEAR, Dat$AGID)

# Missing SET_LAT for OR for selected years
# YEARS <- 1981:2018
YEARS <- 1987
load("Funcs and Data\\EEZ.Polygon.WestCoast.RData")
load("Funcs and Data\\Points.out.of.Dat.and.polygons.RData")

ilines(list(world.h.land, world.h.borders, EEZ.Polygon.WestCoast, BankPolygon, CoastWidePolygon), c(-135, -116), c(29.5, 49.5), zoom = FALSE)
change(Dat.OLD[Dat.OLD$RYEAR %in% YEARS & Dat.OLD$AGID %in% 'O',])
points(SET_LONG, SET_LAT)

dim(Dat[Dat$RYEAR %in% YEARS & Dat$AGID %in% 'O' & is.na(Dat$SET_LAT),])
change(Dat[Dat$RYEAR %in% YEARS & Dat$AGID %in% 'O' & is.na(Dat$SET_LAT),])
points(Best_Long - 2.5, Best_Lat, col='red')

change(Dat[Dat$RYEAR %in% YEARS & Dat$AGID %in% 'O',])
points(SET_LONG - 5, SET_LAT, col='green')
ilines(list(world.h.land, world.h.borders, EEZ.Polygon.WestCoast, BankPolygon, CoastWidePolygon), add = TRUE, zoom = FALSE) 
 
# ---------------------------------------------------

# Dat <- Dat.SAVE

# Percent reduction for good tows and missing lat/long
100 * ( 1 - sum(Dat$GoodTow & !(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long)))/nrow(Dat)) # 6.96% (was 7.1%)
100 * (nrow(Dat) - nrow(LB.ShortForm))/nrow(Dat) # 6.96% (exactly the same as above)


# Percent reduction in good tows by year
round(100*( 1- table(Dat[Dat$GoodTow & !(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long)),]$RYEAR)/Table(Dat$RYEAR)), 2)


# Reported vs GIS depth for non-midwater hauls only
dev.new()

# Non-Midwater - with not Dat$GoodTow & missing lat/long removed - compare without Dat$GoodTow and missing lat/longs above
for( i in unique(Dat$AGID)) {
  png(paste0("Figs/GIS Depth by Reported Depth/Depths, Good Tows, Non-MidWater,State ", i, ".png"), 960, 960)
  print(xyplot(DepthGIS.m ~ DEPTH1*1.8288 | factor(RYEAR), data = Dat[!Dat$GRID %in% 'MDT' & Dat$AGID %in% i & Dat$DepthGIS.m < 1500 & Dat$GoodTow & !(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long)),],
      panel = function(...) { panel.xyplot(...); panel.abline(0,1, col='red'); panel.abline(h = 0, col='green', lty =2)}, xlab = "Reported Depth (meters)", 
      ylab = "GIS Estimated Depth (meters)", main = paste0("State ", i, "; Non-Midwater; Good Tows Only")))
  dev.off()    
}



# GoodTow with BestBtmDepth.m
 # DEPTH1 (red, DEPTH1 converted to meters). Jitter (blue) to show DepthGIS.m data in blocks; green is no jitter for DepthGIS.m
     graphics.off()
        # dev.new()
        dir.create("Figs/Lat_by_Depth_Clean/", recursive = TRUE)
        png("Figs/Lat_by_Depth_Clean/Lat_by_Depth_Clean%03d.png", 960, 960)
        List <- list(); List[[1]] <- 1:6 + 1980; List[[2]] <- 7:12 + 1980; List[[3]] <- 13:18 + 1980; List[[4]] <- 19:24 + 1980; List[[5]] <- 25:30 + 1980; List[[6]] <- 31:36 + 1980; List[[7]] <- 37:40 + 1980
        for ( j in 1:7) {
          # dev.new()
           par(mfrow=c(2,3))
           for( i in List[[j]]) {
             DATA <- Dat[Dat$RYEAR %in% i & Dat$GoodTow & !(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long)), c("SET_LAT", "DEPTH1", "BestBtmDepth.m")]
             try(plot(DATA$DEPTH1*1.8288, DATA$SET_LAT, col = 'red', pch=".", main = i, xlim= c(-3900, 3900), ylim = c(32, 49), xlab = "Depth (meters)", ylab= "Latitude"))
             abline( v = c(-1500, 1500), lty = 2, col = 'grey')
             if(i < 1997)
                 try(points(jitter(-DATA$BestBtmDepth.m, 1.5, amount = 0), jitter(DATA$SET_LAT, 0.5, amount = 0), col = 'dodgerblue', pch="."))
             try(points(-DATA$BestBtmDepth.m, DATA$SET_LAT, col = 'green', pch="."))
           }
         }
    graphics.off()


# How many new GIS depths by year (includes in and out of EEZ)
Table(Dat$RYEAR, is.na(Dat$DEPTH1) & !is.na(Dat$DepthGIS.m))

# How many new GIS depths by agency and year (includes in and out of area polygons)
Table(Dat$RYEAR, is.na(Dat$DEPTH1) & !is.na(Dat$DepthGIS.m), Dat$AGID)

# Total new GIS depths within the polygons is 22,941 for both 2015, 2018, 2018b, and 2021
sum(Table(is.na(Dat$DEPTH1[Dat$InsideAllPoly]) & !is.na(Dat$DepthGIS.m[Dat$InsideAllPoly]), Dat$RYEAR[Dat$InsideAllPoly])[,2])

# Within 1989 by 1 degree latitude blocks
Table(is.na(Dat$DEPTH1[Dat$RYEAR %in% 1989]) & !is.na(Dat$DepthGIS.m[Dat$RYEAR %in% 1989]), round(Dat$SET_LAT[Dat$RYEAR %in% 1989]))

# Within the polygons there are no missing Lat/Long
Table(Dat$RYEAR[Dat$InsideAllPoly], is.na(Dat$SET_LAT[Dat$InsideAllPoly]) | is.na(Dat$SET_LONG[Dat$InsideAllPoly]))


 
base::load("Funcs and Data\\LB Shortform Final 12 Apr 2021.RData")

# Example of Petrale lbs by location June, 2000
     ilines(list(world.h.land, world.h.borders, EEZ.Polygon.WestCoast, BankPolygon, CoastWidePolygon), c(-135, -116), c(29.5, 49.5), zoom = F)
     plot.bubble.zero.cross(LB.ShortForm[LB.ShortForm$RYEAR %in% 2000 & months(LB.ShortForm$DDATE) %in% "June", c("SET_LONG", "SET_LAT", "ptrlbs")], add = TRUE)

# Table of Petrale lbs by year and month and a table by year only
     change(LB.ShortForm[LB.ShortForm$InsideAllPoly,])
     (agg.table(aggregate(list(Ptrl.mt = ptrlbs/2204.6), list(Year = RYEAR, Month = months(DDATE)), sum), Print=F))[,c(5,4,8,1,9,7,6,2,12,11,10)]
     (PtrlYear <- aggregate(list(Ptrl.mt = ptrlbs/2204.6), list(Year = RYEAR), sum))

# Compare Petrale to 2018b version    
     change(LB.ShortForm[LB.ShortForm$InsideAllPoly,])
     r(Ptrl.2020 <- agg.table(aggregate(list(Ptrl.mt = ptrlbs/2204.6), list(Year = RYEAR, Agency = AGID), sum, na.rm = TRUE), Print = FALSE), 2)

     base::load("W:\\ALL_USR\\JRW\\PacFIN & RACEBASE.R\\Main PacFIN Logbook Cleanup - 2018b\\Funcs and Data\\LB Shortform Final 25 Mar 2019.dmp")
     change(LB.ShortForm[LB.ShortForm$InsideAllPoly,])
     r(Ptrl.2018b <- agg.table(aggregate(list(Ptrl.mt = ptrlbs/2204.6), list(Year = RYEAR, Agency = AGID), sum, na.rm = TRUE), Print = FALSE), 2)
     
     r(Ptrl.2020[-(39:40), ] - Ptrl.2018b, 2)
    

          C       O      W                           C       O      W
1981 607.94      NA     NA                 1981 607.94      NA     NA
1982 539.00      NA     NA                 1982 539.00      NA     NA
1983 387.11      NA     NA                 1983 387.11      NA     NA
1984 375.70      NA     NA                 1984 375.70      NA     NA
1985 509.07      NA     NA                 1985 509.07      NA     NA
1986 467.84      NA     NA                 1986 467.84      NA     NA
1987 487.30  592.72 944.24                 1987 487.30  592.72 944.24
1988 532.89  615.91 809.39                 1988 532.89  615.91 809.39
1989 615.23  648.89 702.41                 1989 615.23  648.89 702.41
1990 439.52  583.44 595.02                 1990 439.52  583.44 595.02
1991 539.91  704.69 437.98                 1991 539.91  704.69 437.98
1992 443.31  560.01 443.24                 1992 443.31  560.01 443.24
1993 395.91  530.70 472.36                 1993 395.91  530.70 472.36
1994 469.99  471.53 378.48                 1994 469.99  471.53 378.48
1995 525.17  585.21 478.62                 1995 525.17  585.21 478.62
1996 761.02  498.64 482.40                 1996 761.02  498.64 482.40
1997 632.02  596.28 513.61                 1997 632.02  596.28 513.61
1998 371.90  496.37 578.36                 1998 371.90  496.37 578.36
1999 470.89  452.18 508.00                 1999 470.89  452.18 508.00
2000 554.07  643.98 775.76                 2000 554.07  643.98 775.76
2001 489.79  788.87 670.66                 2001 489.79  788.87 670.66
2002 405.68  748.35 710.03                 2002 405.68  748.35 710.03
2003 331.58  949.57 943.98                 2003 331.58  949.57 943.98
2004 405.91  891.59 839.27                 2004 405.91  891.59 839.27
2005 729.17 1335.38 375.74                 2005 729.17 1335.38 375.74
2006 682.13 1487.77 263.94                 2006 682.13 1487.77 263.94
2007 853.08 1125.04 137.87                 2007 853.08 1125.04 137.87
2008 882.36 1041.70 130.44                 2008 882.36 1041.70 130.44
2009 490.79  985.09 149.65                 2009 490.79  985.09 149.65
2010 204.25  477.13  54.33                 2010 204.25  477.13  54.33
2011 170.02  512.50 109.23                 2011 170.02  512.50 109.23
2012 215.61  653.51 140.24                 2012 215.61  653.51 140.24
2013 454.69 1335.97 212.21                 2013 454.69 1335.97 212.21
2014 591.13 1433.57 169.55                 2014   0.00 1433.57 169.55
2015 574.45 1729.92  90.69                 2015 574.45 1729.92  90.69
2016 453.76 1737.39  91.61                 2016 448.81 1736.32  91.61
2017 385.67 1708.39 166.70                 2017 360.38 1708.39 166.70
2018 393.41 1752.99 169.85                 2018 279.90      NA 169.85
2019 358.39 1537.90 146.10
2020     NA 1141.99  37.46




# Look at differences by tow
load("W:\\ALL_USR\\JRW\\PacFIN & RACEBASE.R\\Main PacFIN Logbook Cleanup - 2018b\\Funcs and Data\\LB ShortForm No Hake Strat 13 Apr 2021.dmp")
LB.ShortForm.No.Hake.Strat.2018b <- LB.ShortForm.No.Hake.Strat


load("W:\\ALL_USR\\JRW\\PacFIN & RACEBASE.R\\Main PacFIN Logbook Cleanup - 2021\\Funcs and Data\\LB.ShortForm.No.Hake.Strat 13 Apr 2021.RData")


# Sablefish
names(LB.ShortForm.No.Hake.Strat.2018b)[grep('sablbs', names(LB.ShortForm.No.Hake.Strat.2018b))] <- 'sablbs.2018b'
LB.ShortForm.No.Hake.Strat <-  match.f(LB.ShortForm.No.Hake.Strat, LB.ShortForm.No.Hake.Strat.2018b, 'Key', 'Key', 'sablbs.2018b')


#Lingcod
names(LB.ShortForm.No.Hake.Strat.2018b)[grep('LCOD.kg', names(LB.ShortForm.No.Hake.Strat.2018b))] <- 'LCOD.kg.2018b'
LB.ShortForm.No.Hake.Strat <-  match.f(LB.ShortForm.No.Hake.Strat, LB.ShortForm.No.Hake.Strat.2018b, 'Key', 'Key', 'LCOD.kg.2018b')


#Dover
names(LB.ShortForm.No.Hake.Strat.2018b)[grep('dovlbs', names(LB.ShortForm.No.Hake.Strat.2018b))] <- 'dovlbs.2018b'
LB.ShortForm.No.Hake.Strat <-  match.f(LB.ShortForm.No.Hake.Strat, LB.ShortForm.No.Hake.Strat.2018b, 'Key', 'Key', 'dovlbs.2018b')

change( LB.ShortForm.No.Hake.Strat[LB.ShortForm.No.Hake.Strat$AGID %in% 'W', ])
change( LB.ShortForm.No.Hake.Strat[LB.ShortForm.No.Hake.Strat$AGID %in% 'O', ])
change( LB.ShortForm.No.Hake.Strat[LB.ShortForm.No.Hake.Strat$AGID %in% 'C', ])

dev.new()
plot(RYEAR, (sablbs - sablbs.2018b)/2204.6)
dev.new()
plot(RYEAR, (LCOD.kg - LCOD.kg.2018b)/1000)
dev.new()
plot(RYEAR, (dovlbs - dovlbs.2018b)/2204.6)




   
 # Count data in H & L  fishery 
  

https://www.middleprofessor.com/files/applied-biostatistics_bookdown/_book/generalized-linear-models-i-count-data.html

https://onlinestatbook.com/2/advanced_graphs/q-q_plots.html




# VAST


http://127.0.0.1:18572/library/DHARMa/html/plotQQunif.html

http://127.0.0.1:18572/library/FishStatsUtils/html/plot_results.html

https://github.com/florianhartig/DHARMa/issues/168


https://github.com/James-Thorson-NOAA/VAST/issues/214


http://127.0.0.1:18572/library/DHARMa/html/testDispersion.html

http://127.0.0.1:18572/library/FishStatsUtils/html/plot_quantile_diagnostic.html

https://cran.r-project.org/web/packages/DHARMa/vignettes/DHARMa.html


 # Team reveals amazing reconstructions of our ancestors to correct mistakes of the past
    
https://blog.frontiersin.org/2021/02/26/soft-tissue-reconstruction-human-evolution-early-hominins-art-science-collaboration-quantitative-methods-ensure-accurate-visual-represetations/


# Sign performance review
W:\ALL_USR\JRW\Personal\Accomplishments & Performance Review\2020-21







# Example of Lingcod lbs for 2019 
     ilines(list(world.h.land, world.h.borders, EEZ.Polygon.WestCoast, BankPolygon, CoastWidePolygon), c(-135, -116), c(29.5, 49.5), zoom = F)
     plot.bubble.zero.cross(LB.ShortForm[LB.ShortForm$RYEAR %in% 2019 & months(LB.ShortForm$DDATE) %in% "June", c("SET_LONG", "SET_LAT", "lcodlbs")], add = TRUE)
    
# Table of Lingcod lbs for thru 2020 (2020 nto complete as of 13 Apr 2021)
     change(LB.ShortForm[LB.ShortForm$InsideAllPoly,])
     r(agg.table(aggregate(list(Lcod.mt = lcodlbs/2204.6), list(Year = RYEAR, Agency = AGID), sum, na.rm = TRUE), Print = FALSE), 2)
   














