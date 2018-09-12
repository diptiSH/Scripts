#!/bin/bash
 # this is my first shell script.JGRJJD
       #levels=( 950hPa 200hPa 500hPa 700hPa 850hPa 2mTemp SLP Inversion)
       
       levels=Inversion
       for l in "${levels[@]}" 
       do    
      
     cdo mergetime  /home/iitm/Documents/work/26Stations_attributes/other_days_Composites/nc_files/""$l""/1ERADAILY-1.5deg_1.5_""$l"".nc /home/iitm/Documents/work/26Stations_attributes/other_days_Composites/nc_files/""$l""/2ERADAILY-1.5deg_1.5_""$l"".nc /home/iitm/Documents/work/26Stations_attributes/other_days_Composites/nc_files/""$l""/ERADAILY-1.5deg_1.5_""$l"".nc

       cdo timmean /home/iitm/Documents/work/26Stations_attributes/other_days_Composites/nc_files/""$l""/ERADAILY-1.5deg_1.5_""$l"".nc /home/iitm/Documents/work/26Stations_attributes/other_days_Composites/nc_files/""$l""/Comp_ERADAILY-1.5deg_1.5_""$l"".nc
     cdo sub /home/iitm/Documents/work/26Stations_attributes/other_days_Composites/nc_files/""$l""/Comp_ERADAILY-1.5deg_1.5_""$l"".nc  /home/iitm/Documents/Data/ERA-1.5//ERAClim-1.5deg-""$l""-Dec-Jan-1979-2016.nc /home/iitm/Documents/work/26Stations_attributes/other_days_Composites/nc_files/""$l""/Anom_ERADAILY-1.5deg_1.5_""$l"".nc

       
  
  
 done
