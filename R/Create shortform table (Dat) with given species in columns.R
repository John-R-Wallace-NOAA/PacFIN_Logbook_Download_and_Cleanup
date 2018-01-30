        
#########################################################################################################################################        
# Calculate species lbs and CPUE in shortform - each row of 'Dat' will be a unique tow and the species lbs will be in columns
# These species in lbs are used in the calculation of 'Strategy' in the 'Add species to LB Shortform Dat.R' script        
#########################################################################################################################################                
        
    # Species or species group aggregate catch function
    source("Funcs and Data/PacFIN.Logbook.Catch.Effort.Sp.R") 
    #  base::load("Funcs and Data/LBData.1981.2015.Nov2017.dmp")  # Load if needed

             
    # Species added, including nominal groups
    MH.List <- list(ptrlbs = c("PTR1", "PTRL"), dovlbs = c("DOVR", "DVR1"), thdlbs = c("LSP1", "SSP1"), sablbs = c("SABL", "SBL1"), whtlbs = "PWHT", POPlbs = c("POP1", "POP2", "UPOP"))
    
    # Not added yet ;
      #"fltlbs"    flatfish lbs
      #"rcklbs"    rockfish lbs

    # Create 'Dat' shortform
    Dat <- PacFIN.Logbook.Catch.Effort.Sp(MH.List[[1]], LBData = LBData.1981.2015.Nov2017)
    cat("\n", names(MH.List)[1], "\n")
    names(Dat)[ncol(Dat)] <- names(MH.List)[1]

    for ( i in 2:length(MH.List)) {
        cat("\n", names(MH.List)[i], "\n")
        tmp <- PacFIN.Logbook.Catch.Effort.Sp(MH.List[[i]], LBData = LBData.1981.2015.Nov2017)
        names(tmp)[ncol(tmp)] <- names(MH.List)[i]
        Dat <- cbind(Dat, tmp[,ncol(tmp), drop=F])
    }

    

         
    # How much data in the bimonthly categories
        Table(Dat$bimo)  

    # Number of records by year and bimonthly
        (a1 <- Table(Dat$RYEAR, Dat$bimo))    # you see some difference between years
                (a1 <- table(Dat$RYEAR, Dat$bimo))    # NA's are small enough to ignore for the figures
    # a1 changed to proportions            
        (a2 <- t(apply(a1, 1, function(x) x/sum(x))))
        
        windows()
        # nf <- par(mar=c(3,3,3,3), oma=c(1,1,1,1))
        par(mfrow=c(2,1))
        matplot(unique(Dat$RYEAR), a1, type="l", main="Change in the number of tows by year and season", xlab="Years",ylab="Tows", col=rainbow(7), lwd=2, lty=1)
        legend("topright", legend=seq(1,6), col=rainbow(7), lwd=2, lty=1, cex=0.8)
        matplot(unique(Dat$RYEAR), a2, type="l", main="Change in the proportion of tow by year and season", xlab="Years",ylab="Tows", col=rainbow(7), lwd=2, lty=1)
        legend("topright", legend=seq(1,6), col=rainbow(7), lwd=2, lty=1, cex=0.8)

     # Number of blocks by year and percent missing
            Table(Dat$RYEAR, is.finite(Dat$BLOCK))
            100*sum(is.na(Dat$BLOCK))/length(Dat$BLOCK) # Percent of missing blocks is 54.51%  (58.85% - OLD)

        # Some catch histograms
            windows();par(mfrow=c(2,2))
            hist(Dat$ptrlbs, xlim=c(0,1000), breaks=c(seq(0,999,by=10), 1000, max(Dat$ptrlbs, na.rm=T)))
            hist(Dat$dovlbs, xlim=c(0,1000), breaks=c(seq(0,999,by=10), 1000, max(Dat$dovlbs)))
            hist(Dat$thdlbs, xlim=c(0,1000), breaks=c(seq(0,999,by=10), 1000, max(Dat$thdlbs)))
            hist(Dat$sablbs, xlim=c(0,1000), breaks=c(seq(0,999,by=10), 1000, max(Dat$sablbs)))
            ## Species dover and sablefish have a really wide tail in their distribution 

    # save 'Dat'
    save(Dat, file="Funcs and Data/LB Shortform unfiltered Dat 29 Nov 2017.dmp")


   
   
   