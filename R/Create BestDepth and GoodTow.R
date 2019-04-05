


# ================ Create BestBtmDepth (meters) ======================================================
  
    base::load("Funcs and Data/LB GIS Depths Dat 25 Mar 2019.dmp") 
    
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
    Dat[Dat$DepthGIS.m %>>% 20000,]
    
    load("Funcs and Data\\EEZ.Polygon.WestCoast.dmp")
    load("Funcs and Data\\Points.out.of.Dat.and.polygons.dmp")
    
    dir.create("Figs")
    png(paste0("Figs/All Data on Coast.png"), 2000, 2000)
    ilines(list(world.h.land, world.h.borders, EEZ.Polygon.WestCoast, BankPolygon, CoastWidePolygon), c(-135, -116), c(29.5, 49.5), zoom = F)
    points(Dat[, c('SET_LONG', 'SET_LAT')], pch='.')
    # points(Dat[Dat$Key %in% 'O 1121790 7', c('SET_LONG', 'SET_LAT')], col= 'red') 
    ilines(list(world.h.land, world.h.borders, EEZ.Polygon.WestCoast, BankPolygon, CoastWidePolygon), add = TRUE, zoom = FALSE) 
    dev.off()
 
    # Midwater - without Dat$GoodTow (see below for with Dat$GoodTow)
    dir.create("Figs/GIS Depth by Reported Depth/", recursive = TRUE)
    for( i in unique(Dat$AGID)) {
      png(paste0("Figs/GIS Depth by Reported Depth/Depths, All Tows, MidWater,State ", i, ".png"), 960, 960)
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
    
dir.create("Figs/GIS Depth by Reported Depth/", recursive = TRUE)
for( i in unique(Dat$AGID)) {
  png(paste0("Figs/GIS Depth by Reported Depth/Depths, Good Tows, State ", i, ".png"), 960, 960)
  print(xyplot(DepthGIS.m ~ DEPTH1*1.8288 | factor(RYEAR), data = Dat[!Dat$GRID %in% 'MDT' & Dat$AGID %in% i & Dat$DepthGIS.m < 1500 & Dat$GoodTow & !(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long)),],
      panel = function(...) { panel.xyplot(...); panel.abline(0,1, col='red'); panel.abline(h = 0, col='green', lty =2)}, xlab = "Reported Depth (meters)", 
      ylab = "GIS Estimated Depth (meters)", main = paste0("State ", i, "; Non-Midwater; Good Tows Only")))
  dev.off()    
}
    
    
    # -----------  Look for reasonable midwater depth limit ---------------------
    change(Dat[Dat$InsideAllPoly & Dat$GRID %in% 'MDT', ])
    aggregate(list(BestBtmDepth.ftm = BestBtmDepth.m/1.8288), List(RYEAR), max, na.rm=T)
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

Dat$InDepthDiffLimit <- abs(Dat$DepthGIS.m - Dat$DEPTH1 * 1.8288 ) < 250 | is.na(Dat$DEPTH1) # Absolute difference between DEPTH1 (fathoms) * 1.8288 and DepthGIS.m less than 250 meters or DEPTH1 can be missing
Dat$InDepthLimit <- Dat$BestBtmDepth.m > 0.0 & Dat$BestBtmDepth.m < 1281   # Best Depth between 0 and 1281 meters (700 fathoms) for non-midwater trawls

Dat$GoodTow <-  (Dat$InsideAllPoly & Dat$InDepthDiffLimit & Dat$InDepthLimit) | 
                (!is.na(Dat$BLOCK) & Dat$RYEAR <= 1996 & Dat$BestBtmDepth.m > -100.0 & Dat$BestBtmDepth.m < 2000) | 
                (Dat$InsideAllPoly & Dat$GRID %in% 'MDT' & Dat$BestBtmDepth.m <= 900*1.8288 )
                
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

Dat$InDepthDiffLimit <- NULL
Dat$InDepthLimit <- NULL
Dat$InsidePoly <- NULL
Dat$InsideBankPoly <- NULL


LB.ShortForm <- Dat[Dat$GoodTow,] 
save(LB.ShortForm, file= "Funcs and Data/LB Shortform Final 25 Mar 2019.dmp")  



# ============================== Checks ========================================================


# ----- An old LB.ShortForm version is needed here for comparison ----

load("Funcs and Data\\LB Shortform Final Dat 25 Jan 2018.dmp")
Dat.OLD <- LB.ShortForm
Dat <- Dat.SAVE  # See above for Dat.SAVE

Table(Dat.OLD$RYEAR[Dat.OLD$GoodTow], Dat.OLD$AGID[Dat.OLD$GoodTow]) - Table(Dat$RYEAR[Dat$GoodTow], Dat$AGID[Dat$GoodTow])[-(36:38), ]

Table(is.na(Dat$SET_LAT) & !is.na(Dat$Best_Lat), Dat$RYEAR, Dat$AGID)


# Missing SET_LAT for OR for selected years
# YEARS <- 1981:2018
YEARS <- 1987
load("\\Funcs and Data\\EEZ.Polygon.WestCoast.dmp")
load("\\Funcs and Data\\Points.out.of.Dat.and.polygons.dmp")

ilines(list(world.h.land, world.h.borders, EEZ.Polygon.WestCoast, BankPolygon, CoastWidePolygon), c(-135, -116), c(29.5, 49.5), zoom = F)
change(Dat.OLD[Dat.OLD$RYEAR %in% YEARS & Dat.OLD$AGID %in% 'O',])
points(SET_LONG, SET_LAT)

change(Dat[Dat$RYEAR %in% YEARS & Dat$AGID %in% 'O' & is.na(Dat$SET_LAT),])
points(Best_Long - 2.5, Best_Lat, col='red')

change(Dat[Dat$RYEAR %in% YEARS & Dat$AGID %in% 'O',])
points(SET_LONG - 5, SET_LAT, col='green')
ilines(list(world.h.land, world.h.borders, EEZ.Polygon.WestCoast, BankPolygon, CoastWidePolygon), add = TRUE, zoom = FALSE) 
 
# ---------------------------------------------------

# Dat <- Dat.SAVE

# Percent reduction for good tows and missing lat/long
100 * ( 1 - sum(Dat$GoodTow & !(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long)))/nrow(Dat)) # 7.1% including 

# Percent reduction in good tows by year
round(100*( 1- table(Dat[Dat$GoodTow & !(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long)),]$RYEAR)/Table(Dat$RYEAR)), 2)


# Reported vs GIS depth for non-midwater hauls only
dev.new()

# Non-Midwater - with Dat$GoodTow & missing lat/long removed - compare without Dat$GoodTow and missing lat/longs above
for( i in unique(Dat$AGID)) {
  png(paste0("Figs/GIS Depth by Reported Depth/Depths, Good Tows, Non-MidWater,State ", i, ".png"), 960, 960)
  print(xyplot(DepthGIS.m ~ DEPTH1*1.8288 | factor(RYEAR), data = Dat[!Dat$GRID %in% 'MDT' & Dat$AGID %in% i & Dat$DepthGIS.m < 1500 & Dat$GoodTow & !(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long)),],
      panel = function(...) { panel.xyplot(...); panel.abline(0,1, col='red'); panel.abline(h = 0, col='green', lty =2)}, xlab = "Reported Depth (meters)", 
      ylab = "GIS Estimated Depth (meters)", main = paste0("State ", i, "; Non-Midwater; Good Tows Only")))
  dev.off()    
}



# GoodTow with BestBtmDepth.m
 # DEPTH1 (red, converted to meters). Jitter (blue) to show DepthGIS.m data in blocks; green is no jitter for DepthGIS.m
     graphics.off()
        # dev.new()
        dir.create("Figs/Lat_by_Depth_Clean/", recursive = TRUE)
        png("Figs/Lat_by_Depth_Clean/Lat_by_Depth_Clean%03d.png", 960, 960)
        List <- list(); List[[1]] <- 1:6 + 1980; List[[2]] <- 7:12 + 1980; List[[3]] <- 13:18 + 1980; List[[4]] <- 19:24 + 1980; List[[5]] <- 25:30 + 1980; List[[6]] <- 31:36 + 1980; List[[7]] <- 37:38 + 1980
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

# Total new GIS depths within the polygons is 22,941 for both 2015 and 2018
sum(Table(is.na(Dat$DEPTH1[Dat$InsideAllPoly]) & !is.na(Dat$DepthGIS.m[Dat$InsideAllPoly]), Dat$RYEAR[Dat$InsideAllPoly])[,2])

# Within 1989 by 1 degree latitude blocks
Table(is.na(Dat$DEPTH1[Dat$RYEAR %in% 1989]) & !is.na(Dat$DepthGIS.m[Dat$RYEAR %in% 1989]), round(Dat$SET_LAT[Dat$RYEAR %in% 1989]))

# Within the polygons there are no missing Lat/Long
Table(Dat$RYEAR[Dat$InsideAllPoly], is.na(Dat$SET_LAT[Dat$InsideAllPoly]) | is.na(Dat$SET_LONG[Dat$InsideAllPoly]))


 
load("Funcs and Data\\LB Shortform Final 25 Mar 2019.dmp")

# Example of Petrale lbs by location June, 2000
     ilines(list(world.h.land, world.h.borders, EEZ.Polygon.WestCoast, BankPolygon, CoastWidePolygon), c(-135, -116), c(29.5, 49.5), zoom = F)
     plot.bubble.zero.cross(LB.ShortForm[LB.ShortForm$RYEAR %in% 2000 & months(LB.ShortForm$DDATE) %in% "June", c("SET_LONG", "SET_LAT", "ptrlbs")], add=T)

# Table of Petrale lbs by year and month and a table by year only
     change(LB.ShortForm[LB.ShortForm$InsideAllPoly,])
     (agg.table(aggregate(list(Ptrl.mt = ptrlbs/2204.6), list(Year = RYEAR, Month = months(DDATE)), sum), Print=F))[,c(5,4,8,1,9,7,6,2,12,11,10)]
     (PtrlYear <- aggregate(list(Ptrl.mt = ptrlbs/2204.6), list(Year = RYEAR), sum))














