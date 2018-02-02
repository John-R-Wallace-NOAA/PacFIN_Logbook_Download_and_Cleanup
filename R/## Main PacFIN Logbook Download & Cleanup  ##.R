
# Main PacFIN Logbook Download & Cleanup


################################# Set the PacFIN Logbook Download directory and load required packages ######################

# Edit the working directory below as desired, the source()'d R code (see below) needs to be in this directory and the save()'d support 
#      data frames (e.g. polygon files) will be put into the subdirectory 'Funcs and Data'.  All saved data frames will also be in 'Funcs and Data'.
    
setwd("C:/PacFIN Logbook Download & Cleanup") 
dir.create('Funcs and Data')

# GitHub, INLA, and CRAN package loads 

   if (!any(installed.packages()[, 1] %in% "devtools"))  install.packages('devtools')  

   devtools::install_github("John-R-Wallace/JRWToolBox", quiet = T)
   if (!any(installed.packages()[, 1] %in% "JRWToolBox"))
       stop('JRWToolBox is not installed, an attempt to install failed (check for GitHub internet access)')
   require(JRWToolBox)
   
   # JRWToolBox::lib() will install and update both GitHub and CRAN packages only if needed and regardless will load the package into the R session
   
   lib("John-R-Wallace/Imap") # GitHub

   if (!any(installed.packages()[, 1] %in% "INLA")) 
      source("http://www.math.ntnu.no/inla/givemeINLA.R")  
   require(INLA)
     
   lib(alphahull)  # CRAN
   lib(lattice)
   lib(rgdal)
   lib(dplyr)
   lib(ggplot2)
   lib(sp)
   lib(MASS)

    
###################################################################################################

# ----- PacFIN Logbook Download & Cleanup -----

# Source Code: Download LB data from PacFIN 1981-2015.R >> Create shortform table (Dat) with given species in columns.R >> Define polygons of reasonable catch area.R >>
#               Add missing Latlong centroid block locations.R >> Add DepthGIS.R >> Create BestDepth and GoodTow.R

# Data file names: LBData.1981.2015.Dec2017.dmp >> LB Polygons Dat 8 Dec 2017.dmp >> LB GIS Depths Dat 8 Dec 2017.dmp >> LB Shortform Final Dat 25 Jan 2018.dmp  >> LB ShortForm No Hake Strat 26 Jan 2018.dmp

# R objects: LBData.1981.2015 >> Dat >> Dat >> LB.ShortForm >> LB.ShortForm.No.Hake.Strat 
 
# *** Note that, in practice, the sourced R code would be stepped through, not just sourced in its entirety. ***
 
     # Download LB data from PacFIN 
     # Set PacFIN.Login and PacFIN.PW for PacFIN server
     PacFIN.Login <- "<Your PacFIN Login Name>"
     PacFIN.PW <- "**********"
     source('Download LB data from PacFIN 1981-2015.R') 
        # Skip above
        # base::load('Funcs and Data/LBData.1981.2015.Nov2017.dmp')  LBData.1981.2015.Nov2017 in R 
        # Using the base's load() here since JRWToolBox::load() is slower.  JRWToolBox::load() shows information about the loaded data frame, but it is slower since it loads twice.
     
     
     # Create LB Shortform (Unique tows in rows - species catch in columns). Note that the data frame 'Dat' has all tows.  A data frame called 'LB.ShortForm' with only good tows is created below.
     source('Create shortform table (Dat) with given species in columns.R')
        # Skip all above
        # load("Funcs and Data/LB Shortform unfiltered Dat 8 Dec 2017.dmp")

        
     # Remove data not in the EEZ
     source('Remove data not in the EEZ.R') 
          
     # Define the coastwide and bank polygon only once using the EEZ polygon and data from 2010-2015 
     # ***** Unless this is changed by committee or there is some significant change in where fish are caught (major undersea earthquake?), then I see no reason to change 
     #        these polygons. I plan to use them in the future and they will be provided for others in GitHub *****     
     source('Define polygons of reasonable catch area.R')  # The code for defining the polygons of reasonable catch area is in a FALSE 'if' statement in lieu of code to download polygons from GitHub.
        # Skip all above
        # load("Funcs and Data/LB Polygons Dat 8 Dec 2017.dmp") # Dat in R

        
     # Add missing lat/long centroid block locations and GIS depth
     source('Add missing Latlong centroid block locations.R')           
     source('Add DepthGIS.R')
        # Skip all above
        # load("Funcs and Data/LB GIS Depths Dat 8 Dec 2017.dmp") # Dat in R

        
     # Create 'BestDepth' and 'GoodTow' columns
     source('Create BestDepth and GoodTow.R')  # Looking for a reasonable midwater depth limit is here
        # Skip all of above
        # load('Funcs and Data/LB Shortform Final Dat 25 Jan 2018.dmp') # LB.ShortForm in R

        
     # Add additional species to LB Shortform base file and remove the Hake Strategy tows (*** May want to leave in Hake tows for Sablefish ***)
     # ******** LB.ShortForm is 'Dat' with only good tows (LB.ShortForm <- Dat[Dat$GoodTow,]) ******
     source('Add species to LB Shortform.R') # LB.ShortForm <- Dat[Dat$GoodTow,] is in here
        # Skip all of above:
        # load('Funcs and Data/LB ShortForm No Hake Strat 26 Jan 2018.dmp') # LB.ShortForm.No.Hake.Strat in R
        
        
        
        
        
