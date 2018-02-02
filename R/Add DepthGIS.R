
# ==============================  GIS depth with depthMeters() =====================================================

# For all tows, add GIS depth with depthMeters() function which is now part of the Imap package 

# After first round most unique lat/longs pairs have GIS depths, so only the new lat/long pairs may need to be added (see below)
if(T) {

     Dat$LL.Key <- paste(Dat$SET_LONG, Dat$SET_LAT)
     LL.unique <- Dat[!duplicated(Dat$LL.Key), c("SET_LONG", "SET_LAT", "LL.Key")]
     dim(LL.unique)
     LL.unique$DepthGIS <- NA
     LL.unique <- LL.unique[!is.na(LL.unique$SET_LONG) | !is.na(LL.unique$SET_LAT),]
     LL.unique <- LL.unique[LL.unique$SET_LONG != 0,]
     
     system.time(LL.unique$DepthGIS[1:5000] <-  depthMeters(LL.unique[1:5000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique$DepthGIS[5001:10000] <-  depthMeters(LL.unique[5001:10000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique$DepthGIS[10001:20000] <-  depthMeters(LL.unique[10001:20000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique$DepthGIS[20001:30000] <-  depthMeters(LL.unique[20001:30000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique$DepthGIS[30001:40000] <-  depthMeters(LL.unique[30001:40000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique$DepthGIS[40001:50000] <-  depthMeters(LL.unique[40001:50000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique$DepthGIS[50001:60000] <-  depthMeters(LL.unique[50001:60000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique$DepthGIS[60001:70000] <-  depthMeters(LL.unique[60001:70000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique$DepthGIS[70001:80000] <-  depthMeters(LL.unique[70001:80000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique$DepthGIS[80001:90000] <-  depthMeters(LL.unique[80001:90000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique$DepthGIS[90001:100000] <- depthMeters(LL.unique[90001:100000, c("SET_LONG", "SET_LAT")]))
     
     save(LL.unique, file='LL.unique.1981-2015 05 Dec 2017.dmp')
       
     
     # On new R session 1
     load("LL.unique.1981-2015 05 Dec 2017.dmp")
     library(JRWToolBox)
     library(Imap)
     
     LL.unique.100k <- LL.unique[100001:200000, ]
     
     system.time(LL.unique.100k$DepthGIS[1:10000] <-  depthMeters(LL.unique.100k[1:10000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.100k$DepthGIS[10001:20000] <-  depthMeters(LL.unique.100k[10001:20000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.100k$DepthGIS[20001:30000] <-  depthMeters(LL.unique.100k[20001:30000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.100k$DepthGIS[30001:40000] <-  depthMeters(LL.unique.100k[30001:40000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.100k$DepthGIS[40001:50000] <-  depthMeters(LL.unique.100k[40001:50000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.100k$DepthGIS[50001:60000] <-  depthMeters(LL.unique.100k[50001:60000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.100k$DepthGIS[60001:70000] <-  depthMeters(LL.unique.100k[60001:70000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.100k$DepthGIS[70001:80000] <-  depthMeters(LL.unique.100k[70001:80000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.100k$DepthGIS[80001:90000] <-  depthMeters(LL.unique.100k[80001:90000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.100k$DepthGIS[90001:100000] <- depthMeters(LL.unique.100k[90001:100000, c("SET_LONG", "SET_LAT")]))
     
     save(LL.unique.100k, file = "LL.unique.100k.dmp")
     
     
     # On new R session 2
     load("LL.unique.1981-2015 05 Dec 2017.dmp")
     library(JRWToolBox)
     library(Imap)
     
     LL.unique.200k <- LL.unique[200001:300000, ]
     
     system.time(LL.unique.200k$DepthGIS[1:10000] <-  depthMeters(LL.unique.200k[1:10000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.200k$DepthGIS[10001:20000] <-  depthMeters(LL.unique.200k[10001:20000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.200k$DepthGIS[20001:30000] <-  depthMeters(LL.unique.200k[20001:30000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.200k$DepthGIS[30001:40000] <-  depthMeters(LL.unique.200k[30001:40000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.200k$DepthGIS[40001:50000] <-  depthMeters(LL.unique.200k[40001:50000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.200k$DepthGIS[50001:60000] <-  depthMeters(LL.unique.200k[50001:60000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.200k$DepthGIS[60001:70000] <-  depthMeters(LL.unique.200k[60001:70000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.200k$DepthGIS[70001:80000] <-  depthMeters(LL.unique.200k[70001:80000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.200k$DepthGIS[80001:90000] <-  depthMeters(LL.unique.200k[80001:90000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.200k$DepthGIS[90001:100000] <- depthMeters(LL.unique.200k[90001:100000, c("SET_LONG", "SET_LAT")]))
     
     save(LL.unique.200k, file = "LL.unique.200k.dmp")
     
     
     # On new R session 3
     load("LL.unique.1981-2015 05 Dec 2017.dmp")
     library(JRWToolBox)
     library(Imap)
     
     LL.unique.300k <- LL.unique[300001:nrow(LL.unique), ]  # number of rows = 459,035 
     
     system.time(LL.unique.300k$DepthGIS[1:10000] <-  depthMeters(LL.unique.300k[1:10000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.300k$DepthGIS[10001:20000] <-  depthMeters(LL.unique.300k[10001:20000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.300k$DepthGIS[20001:30000] <-  depthMeters(LL.unique.300k[20001:30000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.300k$DepthGIS[30001:40000] <-  depthMeters(LL.unique.300k[30001:40000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.300k$DepthGIS[40001:50000] <-  depthMeters(LL.unique.300k[40001:50000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.300k$DepthGIS[50001:60000] <-  depthMeters(LL.unique.300k[50001:60000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.300k$DepthGIS[60001:70000] <-  depthMeters(LL.unique.300k[60001:70000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.300k$DepthGIS[70001:80000] <-  depthMeters(LL.unique.300k[70001:80000, c("SET_LONG", "SET_LAT")]))
     system.time(LL.unique.300k$DepthGIS[80001:90000] <-  depthMeters(LL.unique.300k[80001:90000, c("SET_LONG", "SET_LAT")]))
     
     system.time(LL.unique.300k$DepthGIS[90001:(nrow(LL.unique) - 300000)] <- depthMeters(LL.unique.300k[90001:(nrow(LL.unique) - 300000), c("SET_LONG", "SET_LAT")]))
     
     save(LL.unique.300k, file = "LL.unique.300k.dmp")
     
     
     # Move LL.unique.100k.dmp, LL.unique.200k.dmp, and LL.unique.300k.dmp to the main R's working directory or add the paths below	 
     load("LL.unique.100k.dmp")
     load("LL.unique.200k.dmp")
     load("LL.unique.300k.dmp")
     
     LL.unique.All <- rbind(LL.unique[1:100000,], LL.unique.100k, LL.unique.200k, LL.unique.300k)
     LL.unique.All <- LL.unique.All[!duplicated(LL.unique.All$LL.Key),]
     
     names(LL.unique.All)[4] <- "DepthGIS.m"
     save(LL.unique.All, file = "Funcs and Data/LL.unique.All 05 Dec 2017.dmp")  # All unique lat/longs in and outside of the EEZ 1981-2015
    
} else {
     # Not sure if PacFIN Lat/Long tow locations with GIS depths, but no other meta-data would be allowed on GitHub - so no unique lat/longs pairs on GitHub for now
     download.file("https://cdn.rawgit.com/John-R-Wallace/PacFIN_Logbook_Download_and_Cleanup/master/R/Funcs and Data/Points.out.of.Dat.and.polygons.dmp", "Funcs and Data/LL.unique.All 05 Dec 2017.dmp", mode = 'wb')
}

# Match lat/long pair key to add DepthGIS.m (m = meters) to Dat from the saved unique lat/longs pairs.
load('Funcs and Data/LL.unique.All 05 Dec 2017.dmp')
Dat$LL.Key <- paste(Dat$Best_Long, Dat$Best_Lat)
Dat <- match.f(Dat, LL.unique.All, "LL.Key", "LL.Key", "DepthGIS.m")  

sum(is.na(Dat$DepthGIS.m)) # 46,222  (OLD = 68,173)
Table(Dat$RYEAR, is.finite(Dat$DepthGIS.m))


#  Find any new GIS depths (this may or may not be needed depending on the age of saved unique lat/longs pairs)

TF <- (!is.na(Dat$SET_LAT) & Dat$SET_LAT!= 0 & !is.na(Dat$SET_LONG) &  Dat$SET_LONG!= 0 & is.na(Dat$DepthGIS.m))
sum(TF) # 3
Missing.LL <- Dat[TF, c("SET_LONG", "SET_LAT")]
Missing.LL$LL.Key <- paste(Missing.LL$SET_LONG, Missing.LL$SET_LAT)
Missing.LL.Uniq <- Missing.LL[!duplicated(Missing.LL$LL.Key),]
nrow(Missing.LL.Uniq) # 3
Missing.LL.Uniq$DepthGIS.m <- depthMeters(Missing.LL.Uniq[, c("SET_LONG", "SET_LAT")])
Missing.LL <- match.f(Missing.LL, Missing.LL.Uniq, "LL.Key", "LL.Key", "DepthGIS.m")
Dat$DepthGIS.m[TF] <- Missing.LL$DepthGIS.m
sum(!is.na(Dat$SET_LAT) & Dat$SET_LAT!= 0 & !is.na(Dat$SET_LONG) &  Dat$SET_LONG!= 0 & is.na(Dat$DepthGIS.m)) 
# 1 tow left which is far outside the polygons 
Dat[!is.na(Dat$SET_LAT) & Dat$SET_LAT!= 0 & !is.na(Dat$SET_LONG) &  Dat$SET_LONG!= 0 & is.na(Dat$DepthGIS.m),]  


# For the Dat file, need to redo bimo (bimonthly), add Month as a factor, and change GRID and AGID to factors
Dat$bimo <- ceiling(as.numeric(recode.simple(months(Dat$RDATE, T) , cbind(c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"), 1:12)))/2)
Dat$GRID <- factor(Dat$GRID)
Dat$AGID <- factor(Dat$AGID)
Dat$Month <- factor(months(Dat$RDATE, T), c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"), order=T)
Dat$LL.Key <- NULL

Dat$SET_LAT[Dat$SET_LAT == 0] <- NA
Dat$SET_LONG[Dat$SET_LONG == 0] <- NA

save(Dat, file = "Funcs and Data/LB GIS Depths Dat 5 Dec 2017.dmp") # *** This 'Dat' has Month, DepthGIS.m, GRID and AGID as factors. Bimo is recalculated and LL.Key is removed.


