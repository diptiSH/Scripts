#!/bin/bash

 #levels=(300hPa 200hPa 500hPa 700hPa 850hPa 2mTemp) #SLP)
       l=SLP
        #for l in "${levels[@]}" 
       #do    
      
       cdo timstd1 /home/iitm/Documents/backup/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-""$l""-Dec-Jan-1979-2016.nc /home/iitm/Documents/backup/Documents/data/ERA-1.5/ERA1.5_files/test/ERATimestd-1.5deg-""$l""-Dec-Jan-1979-2016.nc

      # done
