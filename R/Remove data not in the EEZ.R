
# REMOVE all dataset that are not within the EEZ - there are quite a few of tows that are either inland or outside the EEZ. BE CAREFUL!

# Following [ https://rpubs.com/danielequs/199150 > Reading the VLIMAR/VLIZ global EEZ shapefile ] to get the EEZ polygon.

        lib("rgdal")
        lib("tools")
        lib("dplyr")
        lib("ggplot2")
        lib("sp")
        lib("tidyr")
        lib("tidyr")  # Needed to be loaded twice last time I tried - failed to load tidyr after depenencies were loaded!!
        lib("readr")
        # Imap attached in Main

        # Download EEZ.Polygon.WestCoast
        # path.eez.world.hr <- ("W:/ALL_USR/JRW/Assessment/Petrale - Melissa/R/EEZ")
        # fnam.eez.world.hr <- "World_EEZ_v8_2014_HR.shp"
        # eez.world.lr <- readOGR(dsn = path.eez.world.hr, layer = file_path_sans_ext(fnam.eez.world.hr))
        # dat.eez.usa2 <- fortify(eez.world.lr[eez.world.lr@data$Country == "United States", ])

        # EEZ.Polygon.WestCoast <- cbind(dat.eez.usa2$long[dat.eez.usa2$piece == 2], dat.eez.usa2$lat[dat.eez.usa2$piece == 2])         
        # save(EEZ.Polygon.WestCoast, file="EEZ.Polygon.WestCoast.dmp")

        load("Funcs and Data/EEZ.Polygon.WestCoast.dmp")


        #  Using for sample_frac (dplyr) for a fraction of the data
        ilines(list(world.h.land, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom=F)
        
        xyplot(SET_LAT ~ SET_LONG | factor(RYEAR), data = sample_frac(Dat, 0.10))  # Shows if any (0, 0) lat-long in 'Dat'
        xyplot(SET_LAT ~ SET_LONG | factor(RYEAR), data = sample_frac(Dat, 0.10), ylim = c(29.5, 50), xlim = c(-135, -116) )

        Dat$InsideEEZ <- as.logical(point.in.polygon(Dat$SET_LONG, Dat$SET_LAT, EEZ.Polygon.WestCoast[,1], EEZ.Polygon.WestCoast[,2]))  # Runs 30-60 mins.
        save(Dat, file="Funcs and Data/LB Shortform EEZ Dat 29 Nov 2017.dmp") # Backup for long run

        Data <- Dat[Dat$InsideEEZ, ]  # inside the EEZ
        DataOut <- Dat[!Dat$InsideEEZ, ] # Outside the EEZ
        nrow(Data)
        nrow(DataOut)
        
        ilines(EEZ.Polygon.WestCoast, col='red', z= F)
        points(Data$SET_LONG, Data$SET_LAT)

        ilines(EEZ.Polygon.WestCoast, col='red', z= F)
        points(DataOut$SET_LONG, DataOut$SET_LAT)

        xyplot(SET_LAT ~ SET_LONG | factor(RYEAR), data = sample_frac(Data, 0.10), ylim = c(29.5, 50), xlim = c(-135, -116) ) # Sample_frac() is in the 'dplyr' package
       
        ######  Consistent reporting of land tows for ~5 years in CA after block reporting stopped in 1997. Also bad in the North in 1993-94. See also the 6 figures per page below. ######
        xyplot(SET_LAT ~ SET_LONG | factor(RYEAR), data = sample_frac(DataOut, 0.10), ylim = c(29.5, 50), xlim = c(-135, -116) )  
        
        ilines(list(world.h.land, world.h.borders, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom = F)
        points(Data[Data$RYEAR %in% 1994, c("SET_LONG", "SET_LAT")], col = 'dodgerblue', pch=".")
        points(DataOut[DataOut$RYEAR %in% 1994, c("SET_LONG", "SET_LAT")], col = 'magenta')
        windows()
        ilines(list(world.h.land, dat.eez.usa2.mat), c(-125, -123), c(43.5, 44.5), zoom = F)
        points(DataOut[DataOut$RYEAR %in% 1994, c("SET_LONG", "SET_LAT")], col = 'magenta')
 
        windows()
        ilines(list(world.h.land, world.h.borders, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom = F)
        points(Data[Data$RYEAR %in% 1997, c("SET_LONG", "SET_LAT")], col = 'dodgerblue', pch=".")
        points(DataOut[DataOut$RYEAR %in% 1997, c("SET_LONG", "SET_LAT")], col = 'magenta')
        windows()
        ilines(list(world.h.land, dat.eez.usa2.mat), c(-125, -123), c(43.5, 44.5), zoom = F)
        points(DataOut[DataOut$RYEAR %in% 1997, c("SET_LONG", "SET_LAT")], col = 'magenta')

        windows()
        ilines(list(world.h.land, world.h.borders, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom = F)
        points(Data[Data$RYEAR %in% 2015, c("SET_LONG", "SET_LAT")], col = 'dodgerblue', pch=".")
        points(DataOut[DataOut$RYEAR %in% 2015, c("SET_LONG", "SET_LAT")], col = 'magenta')
      
        windows()
        ilines(list(world.h.land, world.h.borders, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom = F)
        points(Data[Data$RYEAR %in% 2000, c("SET_LONG", "SET_LAT")], col = 'dodgerblue', pch=".")
        points(DataOut[DataOut$RYEAR %in% 2000, c("SET_LONG", "SET_LAT")], col = 'magenta')

        # The centroid of the blocks in CA could be out of the EEZ while the actual tow in that block was still in the EEZ.
      
        windows()
        ilines(list(world.h.land, world.h.borders, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom = F)
        points(Data[Data$RYEAR %in% 1983, c("SET_LONG", "SET_LAT")], col = 'dodgerblue', pch=".")
        points(DataOut[DataOut$RYEAR %in% 1983, c("SET_LONG", "SET_LAT")], col = 'magenta')
      
       
        
        # In 1993-94 in the North, the bad reporting appears to spread both east and west. Those tows too far west, but still in the EEZ, 
        #           would also be suspect and out of range by depth in most cases, I would presume. ** This is why I needed to create the polygons of reasonable catch area. ** 
        # This is GIS depth derived from the Lat/Long at the beginning of a tow compared to "DEPTH1" of a tow which may have covered a wide range of depth.
        # Before 2002, it may be best to only assume the latitude is correct and include all tows,

 
# Lat/Long inside and outside the EEZ, longitudes > -115 removed
        graphics.off()
        windows()
        List.6 <- list(); List.6[[1]] <- 1:6 + 1980; List.6[[2]] <- 7:12 + 1980; List.6[[3]] <- 13:18 + 1980; List.6[[4]] <- 19:24 + 1980; List.6[[5]] <- 25:30 + 1980; List.6[[6]] <- 31:35 + 1980
        for ( j in 1:6) {
           windows()
           par(mfrow=c(2,3))
           for( i in List.6[[j]]) {
          
             DATA <- Dat[Dat$RYEAR %in% i & Dat$InsideEEZ & Dat$SET_LONG < -115, c("SET_LONG", "SET_LAT")]
            #  DATA$SET_LONG <- jitter(DATA$SET_LONG, 1, amount = 0)  # Jittering shows data hidden by the same block centroid
            #  DATA$SET_LAT <- jitter(DATA$SET_LAT, 0.5, amount = 0)

             plot(DATA, col = 'dodgerblue', pch=".", main = i, xlim = c(-135, -116.3) , ylim = c(32.3, 49.4))
             points(Dat[Dat$RYEAR %in% i & !Dat$InsideEEZ & Dat$SET_LONG < -115, c("SET_LONG", "SET_LAT")], col = 'magenta')
           }
         }



