#!/bin/bash
 # this is my first shell script.JGRJJD
       levels=( 950hPa 200hPa 500hPa 700hPa 850hPa 2mTemp SLP)
       
      # levels=SLP
       for l in "${levels[@]}" 
       do    
      
     rm  /home/iitm/Documents/work/26Stations_attributes/other_days_Composites/nc_files/""$l""/1ERADAILY-1.5deg_1.5_""$l"".nc 
     rm  /home/iitm/Documents/work/26Stations_attributes/other_days_Composites/nc_files/""$l""/2ERADAILY-1.5deg_1.5_""$l"".nc        
  
  
 done
