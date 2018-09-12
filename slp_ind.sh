#!/bin/bash
 # this is my first shell script.JGRJJD
        dates=(1983-01-07
1990-01-04
1994-12-02
1997-01-05
1997-12-27
1998-01-08
1998-12-29
1999-01-21
2000-01-09
2001-01-19
2001-12-12
2001-12-25
2002-12-23
2003-01-23
2004-12-19
2007-01-01
2008-12-18
2009-01-02
2010-01-21
2011-01-09
2011-12-22
2012-12-29
)



 for i in "${dates[@]}"
       do
         cdo   -seldate,$i /home/iitm/Documents/Data/ERA-1.5/ERADAILY-1.5deg-SLP-Dec-Jan-1979-2016.nc  $i.nc
                echo $i
         cdo sub $i.nc /home/iitm/Documents/Data/ERA-1.5/ERA_Clim_SLP_Dec-Jan_1979-2016.nc /home/iitm/Documents/work/26Stations_attributes/without_rain/nc_files/sequence/SLP_chk/Anom_slp_$i.nc
                
          #echo item: $i
       done

      # cdo mergetime *.nc /home/iitm/Documents/work/26Stations_attributes/without_rain/nc_files/sequence/SLP_chk/slp.nc
   
      #cdo timmean /home/iitm/Documents/work/26Stations_attributes/without_rain/nc_files/sequence/SLP_chk/slp.nc /home/iitm/Documents/work/26Stations_attributes/without_rain/nc_files/sequence/SLP_chk/comp_slp.nc

#       cdo sub /home/iitm/Documents/work/26Stations_attributes/without_rain/nc_files/sequence/SLP_chk/comp_slp.nc /home/iitm/Documents/Data/ERA-1.5/ERA_Clim_SLP_Dec-Jan_1979-2016.nc /home/iitm/Documents/work/26Stations_attributes/without_rain/nc_files/sequence/SLP_chk/Anom_slp.nc

for i in "${dates[@]}"

   do
        rm $i.nc
                echo $i
                
          #echo item: $i
       done
