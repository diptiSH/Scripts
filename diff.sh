#!/bin/bash
 # this is my first shell script.JGRJJD
      

levels=(850hPa 500hPa 200hPa SLP)
 for l in "${levels[@]}"
     do
         echo $l
         cdo -timmean -selyear,1998/2016 /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-""$l""-Dec-Jan-1979-2016.nc comp_""$l""_1998-2016.nc
          cdo -timmean -selyear,1979/1997 /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-""$l""-Dec-Jan-1979-2016.nc comp_""$l""_1979-1997.nc
          cdo sub comp_""$l""_1998-2016.nc comp_""$l""_1979-1997.nc /home/dipti/Documents/data/ERA-1.5/after1997-before1997/diff_ERADAILY-1.5deg-""$l""-Dec-Jan.nc
          rm comp_""$l""_1998-2016.nc
          rm comp_""$l""_1979-1997.nc

done
