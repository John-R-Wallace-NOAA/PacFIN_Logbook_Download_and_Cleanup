
# ==============================  GIS depth with depthMeters() =====================================================

# For all tows, add GIS depth with depthMeters() function which is now part of the Imap package 

# After first round most unique lat/longs pairs have GIS depths, so only the new lat/long pairs need to be added (see below)
if(F) {

     Dat$LL.Key <- paste(Dat$SET_LONG, Dat$SET_LAT)
     LL.unique <- Dat[!duplicated(Dat$LL.Key), c("SET_LONG", "SET_LAT", "LL.Key")]
     dim(LL.unique)
     LL.unique$DepthGIS <- NA
     LL.unique <- LL.unique[!is.na(LL.unique$SET_LONG) | !is.na(LL.unique$SET_LAT),]
     LL.unique <- LL.unique[LL.unique$SET_LONG != 0,]
     
     # save(LL.unique, file='LL.unique.1981-2015 5 Oct 2015.dmp')
     
     
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
     
     save(LL.unique, file='LL.unique.1981-2015 6 Oct 2015.dmp')
       
     
     # On Vanilla R 1
     # load("W:\\ALL_USR\\JRW\\Assessment\\Petrale - Melissa\\R\\LL.unique.1981-2015 5 Oct 2015.dmp")
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
     
     
     # On Vanilla R 2
     # load("W:\\ALL_USR\\JRW\\Assessment\\Petrale - Melissa\\R\\LL.unique.1981-2015 5 Oct 2015.dmp")
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
     
     
     # On Vanilla R 3
     # load("W:\\ALL_USR\\JRW\\Assessment\\Petrale - Melissa\\R\\LL.unique.1981-2015 5 Oct 2015.dmp")
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
     
     
     
     load("W:\\ALL_USR\\JRW\\Assessment\\Petrale - Melissa\\R\\LL.unique.100k.dmp")
     load("W:\\ALL_USR\\JRW\\Assessment\\Petrale - Melissa\\R\\LL.unique.200k.dmp")
     load("W:\\ALL_USR\\JRW\\Assessment\\Petrale - Melissa\\R\\LL.unique.300k.dmp")
     
     LL.unique.All <- rbind(LL.unique[1:100000,], LL.unique.100k, LL.unique.200k, LL.unique.300k)
     LL.unique.All <- LL.unique.All[!duplicated(LL.unique.All$LL.Key),]
     
     names(LL.unique.All)[4] <- "DepthGIS.m"
     save(LL.unique.All, file = "Funcs and Data/LL.unique.All 06 Oct 2016.dmp")  # All unique lat/longs in and outside of the EEZ 1981-2015
     

Dat$LL.Key <- paste(Dat$SET_LONG, Dat$SET_LAT)
Dat$LL.Key[Dat$LL.Key == "NA NA"] <- NA
Dat <- match.f(Dat, LL.unique.All, "LL.Key", "LL.Key", "DepthGIS.m")
sum(is.na(Dat$DepthGIS.m)) # 68,173
Table(Dat$RYEAR, !is.na(Dat$DepthGIS.m))

# BLOCK_OR is either NA or '0' so remove - if it exists
Table(Dat$BLOCK_OR) 
Dat$BLOCK_OR <- NULL

save(Dat, file = "Petrale Dat 6 Oct 2016.dmp") # *** This 'Dat' has "InsideEEZ, LL.Key, and 'DepthGIS.m' ***
}

# A new LL.unique.All (LL.unique.All 05 Dec 2017.dmp) data frame was created using the older Dat (which has missing block centroid lat/long added in the first round)
# This is provided in 'Funcs and Data' and used below

            if(F) {
                # Get all unique lat/long GIS Depths from the older Dat
                Dat.NEW <- Dat
                base::load("Funcs and Data/LB Shortform Blank Dat 10 Mar 2017.dmp")
                Dat.OLD <- Dat
                Dat <- Dat.NEW
                rm(Dat.NEW)
                Dat.OLD$LL.Key <- paste(Dat.OLD$SET_LONG, Dat.OLD$SET_LAT)  
                LL.unique.All <- Dat.OLD[!duplicated(Dat.OLD$LL.Key), c('SET_LONG', 'SET_LAT', 'LL.Key', 'DepthGIS.m')]
                save(LL.unique.All, file= 'Funcs and Data/LL.unique.All 05 Dec 2017.dmp')
            }

# Match lat/long pair key to add DepthGIS.m (m = meters) to the new Dat from the saved unique lat/longs pairs.
load('Funcs and Data/LL.unique.All 05 Dec 2017.dmp')
Dat$LL.Key <- paste(Dat$Best_Long, Dat$Best_Lat)
Dat <- match.f(Dat, LL.unique.All, "LL.Key", "LL.Key", "DepthGIS.m")  

sum(is.na(Dat$DepthGIS.m)) # 46,222  (OLD = 68,173)
Table(Dat$RYEAR, is.finite(Dat$DepthGIS.m))



#  Find new GIS depths 

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


