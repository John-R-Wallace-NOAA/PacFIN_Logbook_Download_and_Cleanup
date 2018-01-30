
###########################
# Add missing lat/long centroid block locations - a few bad block numbers, but added 22k!
# Notes:
# - No block information for WA state agency data.
# - Only CA has both lat/long and block information for the same tow.
# - When there is missing lat/long tow data, California block informtion is only roughly correct and off of OR most tows are assigned the most southerly blocks in OR (see below).
# - For the California agency data off of California, most of the missing lat/long tows were assigned to a single local block with average longitude. 
# - In the end, block centroid lat/longs were only used for missing Oregon data, but that adds 21,949 more tows with lat/long
###########################


# base::load("Funcs and Data/LB Polygons Dat 30 Nov 2017.dmp") # Load if needed

# Centroids of logbook blocks - from Marlene Bellman
load("Funcs and Data/LogBookBlocks.dmp") 

# Blocks have nice coverage of the entire coast
windows()
ilines(list(world.h.land, world.h.borders, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom = F)
points( LogBookBlocks$CenLong, LogBookBlocks$CenLat, col='green')

# Match the block centroids into Dat by block adn rename
Dat <- match.f(Dat, LogBookBlocks, "BLOCK", "BLK10X10", c("CenLat", "CenLong"))
names(Dat)[names(Dat) %in% 'CenLat'] <- 'BlkCentrd_Lat'
names(Dat)[names(Dat) %in% 'CenLong'] <- 'BlkCentrd_Long'

# The range of block numbers in LogBookBlocks is [101, 1444], however there are 31 blocks in Dat outside this range.
range(LogBookBlocks$BLK10X10)
sum(Dat$BLOCK < 101 | Dat$BLOCK > 1444, na.rm = T)

# A look at the block centoids matched into Dat
windows()
ilines(list(world.h.land, world.h.borders, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom = F)
points( Dat$BlkCentrd_Long, Dat$BlkCentrd_Lat, col='green')

# Create a Best lat and long columns with block centroids used where SET_LAT and SET_LONG are missing
# The missing lat/long in Oregon were set to zero (data error or missing???) ZERO/ZERO IS A LEGIT LAT/LONG!! (but not on the West Coast)
Dat$SET_LAT[Dat$SET_LAT %in% 0] <- NA
Dat$SET_LONG[Dat$SET_LONG %in% 0] <- NA

Dat$Best_Lat <- Dat$SET_LAT
Dat$Best_Lat[is.na(Dat$Best_Lat)] <- Dat$BlkCentrd_Lat[is.na(Dat$Best_Lat)]

Dat$Best_Long <- Dat$SET_LONG
Dat$Best_Long[is.na(Dat$Best_Long)] <- Dat$BlkCentrd_Long[is.na(Dat$Best_Long)]


# The figures and table below show that the block number off of Oregon for California data (AGID = 'C') is wrong for 1997 - 2015 except for 2009
# Note that there are additional issues in 2001 - 2003.
# For the California agency data off of California, most of the missing lat/long tows were assigned to a single local block with average longitude 

    # Block centroid latitude by block and jitted block, note that for many of the later years of CA data, all tows above 42 degrees latitude are assigned the same or nearly the same block number
    windows()
    xyplot(BlkCentrd_Lat ~ BLOCK | factor(RYEAR), group = AGID, data = Dat, pch = c(1, 20), cex = c(0.8,0.4), auto = TRUE)
    windows()
    xyplot(BlkCentrd_Lat ~ jitter(BLOCK,500) | factor(RYEAR), group = AGID, data = Dat, pch = c(1, 20), cex = c(0.8,0.4), auto = TRUE)
    
    # Only CA data has both original reported lat/long and block information (expressed as block centroids) so that a comparison can be made.
    for ( AG in c('C', 'O', 'W')) {
      windows()
      print(xyplot(I(SET_LAT - BlkCentrd_Lat) ~ SET_LAT | factor(RYEAR), data = Dat[!(Dat$SET_LAT %in% 0) & Dat$AGID %in% AG,], panel = function(...) {panel.xyplot(...); panel.abline(v=42)}, main = AG))
    }
    Table(!is.na(Dat$BLOCK), !is.na(Dat$SET_LAT), Dat$AGID)
        
    # Block min and max number by year and state agency    
    change(Dat)
    cbind(aggregate(list(Block.Min = BLOCK), List(RYEAR, AGID), min, na.rm=T), Block.Max = aggregate(List(BLOCK), List(RYEAR, AGID), max, na.rm=T)[,3])
    
    # Only the most southerly logbook blocks off OR (above 42 degrees latitude) used for all CA agency tows
    rev(sort(Dat[Dat$AGID %in% 'C' & Dat$BlkCentrd_Lat > 42 & RYEAR %in% 1997, "BLOCK"]))  
    rev(sort(Dat[Dat$AGID %in% 'C' & Dat$BlkCentrd_Lat > 42 & RYEAR %in% 2015, "BLOCK"]))
    rev(sort(Dat[Dat$AGID %in% 'C' & Dat$BlkCentrd_Lat > 42 & RYEAR %in% 2009, "BLOCK"]))  # 2009 is ok
    
    # 22,103 more tows with lat/long added to Best lat/long from block centroids
    Table(Dat$RYEAR, !is.na(Dat$Best_Long), Dat$AGID) - Table(Dat$RYEAR, !is.na(Dat$SET_LONG), Dat$AGID)
    sum((Table(Dat$RYEAR, !is.na(Dat$Best_Long), Dat$AGID) - Table(Dat$RYEAR, !is.na(Dat$SET_LONG), Dat$AGID))[,2,]) # Total: 22,103
    sum((Table(Dat$RYEAR, !is.na(Dat$Best_Long), Dat$AGID) - Table(Dat$RYEAR, !is.na(Dat$SET_LONG), Dat$AGID))[,2,1]) # CA: 154
    sum((Table(Dat$RYEAR, !is.na(Dat$Best_Long), Dat$AGID) - Table(Dat$RYEAR, !is.na(Dat$SET_LONG), Dat$AGID))[,2,2]) # OR: 21,949
    
    # Map figure for 1999 showing that the block numbers (expressed as block centroids) given to CA tows off of OR are not correct
    windows()
    ilines(list(world.h.land, world.h.borders, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom = F)
    change(Dat[!is.na(Dat$SET_LAT) & !is.na(Dat$BlkCentrd_Long) & Dat$RYEAR %in% 1999, ])
    points(SET_LONG, SET_LAT, col='red', pch='.')
    points(BlkCentrd_Long, BlkCentrd_Lat, col='green')
    
    #  Most of the missing lat/long tows assigned to a single local block with average longitude for the CA data - first without jitter. CA in red, OR in blue, and WA in green (WA has no block information)
    windows()
    ilines(list(world.h.land, world.h.borders, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom = F)
    change(Dat[is.na(Dat$SET_LAT) & !is.na(Dat$Best_Long) & Dat$AGID %in% 'C',])
    points(Best_Long, Best_Lat, col='red')
    change(Dat[is.na(Dat$SET_LAT) & !is.na(Dat$Best_Long) & Dat$AGID %in% 'O',])
    points(Best_Long - 2.5, Best_Lat, col='blue')
    change(Dat[is.na(Dat$SET_LAT) & !is.na(Dat$Best_Long) & Dat$AGID %in% 'W',])
    points(Best_Long - 5, Best_Lat, col='green') # No WA blocks
    
    # Now with jitter on blocks for the CA data
    windows()
    ilines(list(world.h.land, world.h.borders, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom = F)
    change(Dat[is.na(Dat$SET_LAT) & !is.na(Dat$Best_Long) & Dat$AGID %in% 'C',])
    points(jitter(Best_Long, 500), Best_Lat, col='red')
    
    # Another related look with jittered block
    windows()
    xyplot(BlkCentrd_Lat ~ jitter(BLOCK,5) | factor(RYEAR), group = AGID, data = Dat[is.na(Dat$SET_LAT) & !is.na(Dat$Best_Long),], pch = c(1, 20), cex = c(0.8,0.4))
    
    
    # All block centroids by state agency (stagggered longitude). CA in red, OR in blue, and WA in green (WA has no block information)
    windows()
    ilines(list(world.h.land, world.h.borders, dat.eez.usa2.mat), c(-135, -116), c(29.5, 49.5), zoom = F)
    change(Dat[Dat$AGID %in% 'C'  & !is.na(Dat$BlkCentrd_Long),])
    points(BlkCentrd_Long, BlkCentrd_Lat, col='red', pch='.')
    
    change(Dat[Dat$AGID %in% 'O'  & !is.na(Dat$BlkCentrd_Long),])
    points(BlkCentrd_Long - 2, BlkCentrd_Lat, col='blue', pch='.')
    
    change(Dat[Dat$AGID %in% 'W'  & !is.na(Dat$BlkCentrd_Long) ,])
    points(BlkCentrd_Long - 4, BlkCentrd_Lat, col='green', pch='.') # No blocks for WA
    
    

# ********** Given the above issues with CA block data, CA was removed from the best lat/long **********

Dat$Best_Long[Dat$AGID %in% 'C' & is.na(Dat$SET_LONG)] <- NA
Dat$Best_Lat[Dat$AGID %in% 'C' & is.na(Dat$SET_LAT)] <- NA

# The totals now show zero additional tows added to Best_Long for California. (21,949 + 154 = 22,103 from above)
Table(Dat$RYEAR, !is.na(Dat$Best_Long), Dat$AGID) - Table(Dat$RYEAR, !is.na(Dat$SET_LONG), Dat$AGID)
sum((Table(Dat$RYEAR, !is.na(Dat$Best_Long), Dat$AGID) - Table(Dat$RYEAR, !is.na(Dat$SET_LONG), Dat$AGID))[,2,]) # Total: 21,949
sum((Table(Dat$RYEAR, !is.na(Dat$Best_Long), Dat$AGID) - Table(Dat$RYEAR, !is.na(Dat$SET_LONG), Dat$AGID))[,2,1]) # CA: 0
sum((Table(Dat$RYEAR, !is.na(Dat$Best_Long), Dat$AGID) - Table(Dat$RYEAR, !is.na(Dat$SET_LONG), Dat$AGID))[,2,2]) # OR: 21,949







