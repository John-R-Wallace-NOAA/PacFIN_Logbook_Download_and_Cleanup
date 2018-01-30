


# ================ Create BestDepth ======================================================

base::load("Funcs and Data/LB GIS Depths Dat 8 Dec 2017.dmp")

Dat$BestDepth.m <- Dat$DEPTH1 * 1.8288 # Fathoms to meters
Dat$BestDepth.m[is.na(Dat$BestDepth.m)] <- Dat$DepthGIS.m[is.na(Dat$BestDepth.m)]

    # ----- For midwater tows - change BestDepth.m default to the GIS depth since it appears that some midwater depths in PacFIN may be depth of the net. --------
    
    # Reported vs GIS depth for midwater hauls only.png
    change(Dat[Dat$GRID %in% 'MDT',])
    # change(Dat[Dat$GRID %in% 'MDT' & Dat$GoodTow,])  # Look again after GoodTow is created below
    xyplot(DepthGIS.m ~ DEPTH1*1.8288 | factor(RYEAR), panel = function(...) { panel.xyplot(...); panel.abline(0,1, col='red')}, xlab = "Reported Depth (meters)", ylab = "GIS Estimated Depth (meters)")
    
    Dat$BestDepth.m[Dat$GRID %in% 'MDT'] <- ifelse(!is.na(Dat$DepthGIS.m[Dat$GRID %in% 'MDT']), Dat$DepthGIS.m[Dat$GRID %in% 'MDT'], Dat$DEPTH1[Dat$GRID %in% 'MDT'] * 1.8288)


    # -----------  Look for reasonable midwater depth limit ---------------------

    change(Dat[Dat$InsideAllPoly & Dat$GRID %in% 'MDT', ])
    aggregate(list(BestDepth.ftm = BestDepth.m/1.8288), List(RYEAR), max, na.rm=T)
    Table(Dat[Dat$BestDepth.m/1.8288 >= 900, "GRID"], Dat[Dat$BestDepth.m/1.8288 >= 900, "RYEAR"])

    # -----------  Look for reasonable depth difference between GIS and reported depth ---------------------
    
    Dat$DepthDiff.m <- abs(Dat$DepthGIS.m - Dat$DEPTH1 * 1.8288 )
    histogram(~ DepthDiff.m | factor(RYEAR), data = Dat, panel= function(...) {panel.histogram(...); panel.abline(v=c(250,500))})

    
# ================ Create GoodTow ======================================================


################### Conditions for leaving in a tow ############################
#  A tow reported in a block before 1997 is in as long as the depth is less than 2000 meters and greater than -100, since a centroid
#      can be deeper than a tow within the block and some centorids are on land. (Used Imap::depthMeters() on all the centroids to check.)
# The depth also needs to be between 0 and 1,500 meters
################################################################################


# --- More restriction for poor depth reporting ---
# Changed depth difference limit from 500 to 250 meters after (re)running VAST with Region = "Other" and CA Current for Petrale Winter fishery 
#             and looking for reasonable depth differences between GIS and reported depth - see above
# Also changed the depth limit for non-midwater trawls to 1281 m (700 fathoms)
# DatG <- DatG[(abs(DatG$DEPTH1*1.8288 - DatG$DepthGIS.m) %<=% 250 | is.na(DatG$DEPTH1)) & DatG$DepthGIS.m %<=% 1281,] 

Dat.SAVE <- Dat


# Note again, that missing DEPTH1 stays in over being greater than 250 m from the GIS depth - better to be missing than far off
# Dat$InDepthDiffLimit <- abs(Dat$DepthGIS.m - Dat$DEPTH1 * 1.8288 ) < 500  | is.na(Dat$DEPTH1) # Absolute difference between DEPTH1 (fathoms) * 1.8288 and DepthGIS.m less than 500 meters or DEPTH1 can be missing

Dat$InDepthDiffLimit <- abs(Dat$DepthGIS.m - Dat$DEPTH1 * 1.8288 ) < 250 | is.na(Dat$DEPTH1) # Absolute difference between DEPTH1 (fathoms) * 1.8288 and DepthGIS.m less than 250 meters or DEPTH1 can be missing
Dat$InDepthLimit <- Dat$BestDepth.m > 0.0 & Dat$BestDepth.m < 1281   # Best Depth between 0 and 1281 meters (700 fathoms) for non-midwater trawls

# No longer using InsideEEZ this far down (see above)
# Dat$GoodTow <-  (Dat$InsideEEZ & Dat$InsideAllPoly & Dat$InDepthDiffLimit & Dat$InDepthLimit) | 
#               (!is.na(Dat$BLOCK) & Dat$RYEAR <= 1996 & Dat$BestDepth.m > -100.0 & Dat$BestDepth.m < 2000) | 
#                (Dat$InsideEEZ & Dat$InsideAllPoly & Dat$GRID %in% 'MDT' & Dat$BestDepth.m <= 900*1.8288 )

Dat$GoodTow <-  (Dat$InsideAllPoly & Dat$InDepthDiffLimit & Dat$InDepthLimit) | 
                (!is.na(Dat$BLOCK) & Dat$RYEAR <= 1996 & Dat$BestDepth.m > -100.0 & Dat$BestDepth.m < 2000) | 
                (Dat$InsideAllPoly & Dat$GRID %in% 'MDT' & Dat$BestDepth.m <= 900*1.8288 )
                
# Missing good tows are not good tows                
Table(Dat$RYEAR, Dat$GoodTow) 
Dat$GoodTow[is.na(Dat$GoodTow)] <- FALSE
Table(Dat$RYEAR, Dat$GoodTow) 

# Also removing any tows with missing lat or long
Dat <- Dat[!(is.na(Dat$Best_Lat) | is.na(Dat$Best_Long)), ]

Dat$InDepthDiffLimit <- NULL
Dat$InDepthLimit <- NULL
Dat$InsidePoly <- NULL
Dat$InsideBankPoly <- NULL


LB.ShortForm <- Dat[Dat$GoodTow,] 
save(LB.ShortForm, file= "Funcs and Data/LB Shortform Final Dat 25 Jan 2018.dmp")  



# ============================== Checks ========================================================


# Percent reduction in good tows
100 * ( 1 - sum(Dat$GoodTow)/nrow(Dat))

# Percent reduction in good tows by year
round(100*( 1- table(Dat[Dat$GoodTow,]$RYEAR)/Table(Dat$RYEAR)), 2)


# Reported vs GIS depth for non-midwater hauls only
windows()
change(Dat[!(Dat$GRID %in% 'MDT') & Dat$GoodTow,])
xyplot(DepthGIS.m ~ DEPTH1*1.8288 | factor(RYEAR), panel = function(...) { panel.xyplot(...); panel.abline(0,1, col='red')}, xlab = "Reported Depth (meters)", ylab = "GIS Estimated Depth (meters)")



# GoodTow with BestDepth.m
 # DEPTH1 (red, converted to meters). Jitter (blue) to show DepthGIS.m data in blocks; green is no jitter for DepthGIS.m
     graphics.off()
        # windows()
        dir.create("Figs/Lat_by_Depth_Clean/", recursive = TRUE)
        png("Figs/Lat_by_Depth_Clean/Lat_by_Depth_Clean%03d.png", 960, 960)
        List.6 <- list(); List.6[[1]] <- 1:6 + 1980; List.6[[2]] <- 7:12 + 1980; List.6[[3]] <- 13:18 + 1980; List.6[[4]] <- 19:24 + 1980; List.6[[5]] <- 25:30 + 1980; List.6[[6]] <- 31:35 + 1980
        for ( j in 1:6) {
          # windows()
           par(mfrow=c(2,3))
           for( i in List.6[[j]]) {
             DATA <- Dat[Dat$RYEAR %in% i & Dat$GoodTow, c("SET_LAT", "DEPTH1", "BestDepth.m")]
             try(plot(DATA$DEPTH1*1.8288, DATA$SET_LAT, col = 'red', pch=".", main = i, xlim= c(-3900, 3900), ylim = c(32, 49), xlab = "Depth (meters)", ylab= "Latitude"))
             abline( v = c(-1500, 1500), lty = 2, col = 'grey')
             if(i < 1997)
                 try(points(jitter(-DATA$BestDepth.m, 1.5, amount = 0), jitter(DATA$SET_LAT, 0.5, amount = 0), col = 'dodgerblue', pch="."))
             try(points(-DATA$BestDepth.m, DATA$SET_LAT, col = 'green', pch="."))
           }
         }
    graphics.off()


# How many new GIS depths by year (includes in and out of EEZ)
Table(Dat$RYEAR, is.na(Dat$DEPTH1) & !is.na(Dat$DepthGIS.m))

# How many new GIS depths by agency and year (includes in and out of area polygons)
Table(Dat$RYEAR, is.na(Dat$DEPTH1) & !is.na(Dat$DepthGIS.m), Dat$AGID)

# Total new GIS depths within the polygons is 22,941
sum(Table(is.na(Dat$DEPTH1[Dat$InsideAllPoly]) & !is.na(Dat$DepthGIS.m[Dat$InsideAllPoly]), Dat$RYEAR[Dat$InsideAllPoly])[,2])

# Within 1989 by 1 degree latitude blocks
Table(is.na(Dat$DEPTH1[Dat$RYEAR %in% 1989]) & !is.na(Dat$DepthGIS.m[Dat$RYEAR %in% 1989]), round(Dat$SET_LAT[Dat$RYEAR %in% 1989]))

#  Within the polygons there are no missing Lat/Long
Table(Dat$RYEAR[Dat$InsideAllPoly], is.na(Dat$SET_LAT[Dat$InsideAllPoly]) | is.na(Dat$SET_LONG[Dat$InsideAllPoly]))




 base::load('Funcs and Data/LB Shortform Blank Dat 10 Mar 2017.dmp')
 Dat.OLD <- Dat
 base::load('Funcs and Data/LB Shortform Final Dat 25 Jan 2018.dmp') 
 
 Table(Dat.OLD$RYEAR[Dat.OLD$GoodTow], Dat.OLD$AGID[Dat.OLD$GoodTow]) - Table(Dat$RYEAR[Dat$GoodTow], Dat$AGID[Dat$GoodTow])
 
 
ilines(list(world.h.land, world.h.borders, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom = F)

change(Dat.OLD[Dat.OLD$RYEAR < 1982 & Dat.OLD$AGID %in% 'C',])
points(SET_LONG, SET_LAT)


change(Dat.OLD[Dat.OLD$RYEAR < 1982 & Dat.OLD$AGID %in% 'C' & is.na(Dat.OLD$Best_Lat),])
points(SET_LONG - 2.5, SET_LAT, col='red')



change(Dat[Dat$RYEAR < 1982 & Dat$AGID %in% 'C',])
points(SET_LONG - 5, SET_LAT, col='green')

 
 
 


# Example of Petrale lbs by location June, 2000
          ilines(list(world.h.land, world.h.borders, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom = F)
          plot.bubble.zero.cross(Dat[Dat$RYEAR %in% 2000 & months(Dat$RDATE) %in% "June", c("SET_LONG", "SET_LAT", "ptrlbs")], add=T)

# Table of Petrale lbs by year and month and a table by year only
     change(Dat[Dat$InsideAllPoly,])
     (agg.table(aggregate(list(Ptrl.mt = ptrlbs/2048), list(Year = RYEAR, Month = months(RDATE)), sum), Print=F))[,c(5,4,8,1,9,7,6,2,12,11,10)]
     (PtrlYear <- aggregate(list(Ptrl.mt = ptrlbs/2048), list(Year = RYEAR), sum))


# ======================================================================================


xyplot(LB.ShortForm$DepthGIS.m ~ LB.ShortForm$DEPTH1*1.8288| factor(LB.ShortForm$RYEAR), panel = function(...) {panel.xyplot(...); panel.abline(0,1)})



















