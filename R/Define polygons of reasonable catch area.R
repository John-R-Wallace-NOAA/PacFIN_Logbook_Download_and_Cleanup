

# Define polygons of reasonable catch area by first using a convex hull (ahull() in the alphahull package) on data from 2010-2015, manually grab the points not 
#        in the hull and then use the non-convex hull function: inla.nonconvex.hull() from the INLA package. A second pass was required.


 ########## Define the coastwide and bank polygon only once using the EEZ polygon and data from 2010-2015 ###########
if(FALSE) {
      # Get coastwide polygon for everything except the bank
      
      DATA <- Dat[Dat$RYEAR %in% 2010:2015 & Dat$InsideEEZ & Dat$SET_LONG < -115, c("SET_LONG", "SET_LAT")]
      DATA <- DATA[!duplicated(paste(DATA$SET_LONG, DATA$SET_LAT)),]
      DATA <- DATA[ !(DATA$SET_LONG > -124.5475 & DATA$SET_LAT > 48.12235),]  # No Puget Sound
      DATA$Index <- 1:nrow(DATA)
      
      # png("Figs/Convex hull on the logbook data with outlying data.png")
      plot(DATA.ahull <-  ahull(DATA$SET_LONG, DATA$SET_LAT, alpha = 0.35), xlab = "Longitude", ylab="Latitude")
      
      
      PointsOut <- select.pts(DATA)
      PointsOut <- rbind(PointsOut, select.pts(DATA)) # Repeat as needed
      
      # Get polygon for the bank
      Bank <- select.pts(DATA)
      
      DATA.hull <- DATA[!(DATA$Index %in% rbind(PointsOut, Bank)$Index), ]
      
      plot(DATA.hull[,-3])
      lines(DATA.inla.boundary <- inla.nonconvex.hull(as.matrix(DATA.hull[,-3]), convex=0.2, res = c(49,84)), col='red')
      
      # Second pass
      
      (PointsOut2 <- select.pts(DATA.hull))
      PointsOut2 <- rbind(PointsOut2, select.pts(DATA.hull)) # Repeat as needed
      
      DATA.hull <- DATA[!(DATA$Index %in% rbind(PointsOut[-8,], PointsOut2, Bank)$Index), ]
      
      
      
      # imap(longrange=c(-129, -112.7), latrange=c(32.0, 50.5), zoom=F)
      windows(width = 4.5, height = 8.6)
      plot(DATA.hull[,-3], xlab = "Longitude", ylab="Latitude", xlim=c(-128, -117))
      # points(DATA.hull[,-3])
      lines(DATA.inla.boundary <- inla.nonconvex.hull(as.matrix(DATA.hull[,-3]), convex=0.2,  concave = 0.3, res = c(49,84)), col='red')
      # lines(DATA.inla.boundary <- inla.nonconvex.hull(as.matrix(DATA.hull[,-3]), convex=0.18, res = c(63,110)), col='green')
      # lines(DATA.inla.boundary <- inla.nonconvex.hull(as.matrix(DATA.hull[,-3]), convex=0.22, res = c(49,84)), col='blue')
      
      points(Bank, col='green')
      
      lines(Bank.inla.boundary <- inla.nonconvex.hull(as.matrix(Bank[,-3]), convex=0.2, concave = 0.3, res = c(49,84)), col='red')
      # lines(Bank.inla.boundary <- inla.nonconvex.hull(as.matrix(Bank[,-3]), convex=0.18, res = c(49,84)), col='green')
      
      points(DATA[(DATA$Index %in% rbind(PointsOut[-8,], PointsOut2)$Index), ], col='blue') # Data that is out
      
      
      
      CoastWidePolygon <- rbind(DATA.inla.boundary$loc, DATA.inla.boundary$loc[1,]) # Close up to create polygon
      BankPolygon <- rbind(Bank.inla.boundary$loc, Bank.inla.boundary$loc[1,]) # Close up to create polygon
      
      
      PointsOut.Bank <- rbind(PointsOut[-8,], PointsOut2, Bank)
      save(PointsOut.Bank, CoastWidePolygon, BankPolygon, file = 'Funcs and Data/Points.out.of.Dat.and.polygons.RData')

} else {

       load('Funcs and Data/EEZ.Polygon.WestCoast.RData')
       load('Funcs and Data/Points.out.of.Dat.and.polygons.Rdata')
              
      # Or load EEZ.Polygon.WestCoast, CoastWidePolygon, and BankPolygon from GitHub
      # download.file("https://cdn.jsdelivr.net/gh/John-R-Wallace/PacFIN_Logbook_Download_and_Cleanup@master/R/Funcs and Data/EEZ.Polygon.WestCoast.RData", "Funcs and Data/EEZ.Polygon.WestCoast.RData", mode = 'wb')
      # rgit::gitAFile("https://cdn.jsdelivr.net/gh/John-R-Wallace/PacFIN_Logbook_Download_and_Cleanup@master/R/Funcs and Data/EEZ.Polygon.WestCoast.RData", type = 'RData', File = "Funcs and Data/EEZ.Polygon.WestCoast.RData")
      # rgit::gitAFile("https://cdn.jsdelivr.net/gh/John-R-Wallace/PacFIN_Logbook_Download_and_Cleanup@master/R/Funcs and Data/Points.out.of.Dat.and.polygons.RData", type = 'RData', File = "Funcs and Data/Points.out.of.Dat.and.polygons.RData")
     
}


# Load the previously defined polygons from 2015 - if needed
# load("Funcs and Data/Points.out.of.Dat.and.polygons.RData")

# Create 'InsidePoly', 'InsideBankPoly' and 'InsideAllPoly' logical columns, TRUE is inside the polygon, FALSE is outside
# NOTE: !!!! sp::point.in.polygon() needs to return NA when latitude and/or longitude are NA, not 0 (logical FALSE)!!!!
Dat$InsidePoly <- as.logical(sp::point.in.polygon(Dat$SET_LONG, Dat$SET_LAT, CoastWidePolygon[,1], CoastWidePolygon[,2]))  
Dat$InsidePoly[is.na(Dat$SET_LONG) | is.na(Dat$SET_LAT)] <- NA
Dat$InsideBankPoly <- as.logical(sp::point.in.polygon(Dat$SET_LONG, Dat$SET_LAT, BankPolygon[,1], BankPolygon[,2])) 
Dat$InsideBankPoly[is.na(Dat$SET_LONG) | is.na(Dat$SET_LAT)] <- NA
Dat$InsideAllPoly <- Dat$InsidePoly | Dat$InsideBankPoly

# Save the Dat with polygon columns
save(Dat, file="Funcs and Data/LB Polygons Dat 12 Apr 2021.RData")


# Create figures showing the tows inside and outside the polygons. The figures are created both on the screen and saved to PNG files in Figs/PolygonInOut/
dir.create("Figs/PolygonInOut/", recursive = TRUE)

for(PNG in c(FALSE, TRUE)) { 
 
   if(PNG)
      png("Figs/PolygonInOut/PolygonInOut_All_Years.png", 3000, 3000)
   ilines(list(EEZ.Polygon.WestCoast, CoastWidePolygon, BankPolygon), z= F)
   points(Dat[Dat$InsideAllPoly, 'SET_LONG'], Dat[Dat$InsideAllPoly, 'SET_LAT'], col='green', pch='.', cex=2)
   points(Dat[!Dat$InsideAllPoly, 'SET_LONG'], Dat[!Dat$InsideAllPoly, 'SET_LAT'], col='red', pch='.', cex=2)
   if(PNG)
     dev.off() 
}   


# Lat/Long inside and outside the polygons (coast and bank polygons)
           
        for(PNG in c(FALSE, TRUE)) { 
 
           if(PNG)   
              png("Figs/PolygonInOut/PolygonInOut%03d.png", 960, 960)
           List <- list(); List[[1]] <- 1:6 + 1980; List[[2]] <- 7:12 + 1980; List[[3]] <- 13:18 + 1980; List[[4]] <- 19:24 + 1980; List[[5]] <- 25:30 + 1980; List[[6]] <- 31:36 + 1980; List[[7]] <- 37:38 + 1980
           for ( j in 1:7) {
              par(mfrow=c(2,3))
              for( i in List[[j]]) {
                plot(Dat[Dat$RYEAR %in% i & Dat$InsideAllPoly, c("SET_LONG", "SET_LAT")], col = 'dodgerblue', pch=20, cex=0.2, main = i, xlim = c(-135, -116.3) , ylim = c(32.3, 49.4))
                points(Dat[Dat$RYEAR %in% i & !Dat$InsideAllPoly, c("SET_LONG", "SET_LAT")], col = 'magenta')
              }
           }
           if(PNG) 
              dev.off() 
       }      






