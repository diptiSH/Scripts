#!/bin/bash

 dates0=(1981-01-09
1983-01-08
2003-01-19
2004-12-22
2007-01-20
2007-01-21
2007-01-22
2011-12-15
)




ndays=( 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14)
 for j in "${ndays[@]}"
     do
         echo $j
        for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'+'$j' day' +'%Y-%m-%d'`
            #echo $useDate
              # echo $i
            cdo   -seldate,$useDate /home/user/Documents/Data/ERA-1.5/ERADAILY-1.5deg-AllLevels-Dec-Jan-1979-2016.nc ""$useDate"".nc
                
          #echo item: $i
       done

        k=`expr $j - 7`
        echo $k

        cdo mergetime *.nc  /home/user/Documents/work/All_levels/OneSigma/Both_pos/""$k""ERA-1.5deg_AllLevels.nc
      # /home/user/Documents/work/me10Criterion/OneSigma_anom/00Z/nc_files  
    cdo timmean  /home/user/Documents/work/All_levels/OneSigma/Both_pos/""$k""ERA-1.5deg_AllLevels.nc  /home/user/Documents/work/All_levels/OneSigma/Both_pos/Comp""$k""ERA_1.5deg_AllLevels.nc

        rm /home/user/Documents/work/All_levels/OneSigma/Both_pos/""$k""ERA-1.5deg_AllLevels.nc


  for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'+'$j' day' +'%Y-%m-%d'`
            #echo $useDate
             #  echo $i
            rm ""$useDate"".nc
                
          #echo item: $i
       done

   for i in "${dates0[@]}"
           do
            useDate=`date --date=$i'+'$j' day' +'%Y-%m-%d'`
            #echo $useDate
             #  echo $i
            cdo   -seldate,$useDate /home/user/Documents/Data/ERA-1.5/Daily_anomalies/ERAANOM-1.5deg-AllLevels-Dec-Jan-1979-2016.nc ""$useDate"".nc
                
          #echo item: $i
       done

        cdo mergetime *.nc  /home/user/Documents/work/All_levels/OneSigma/Both_pos/Anom""$k""ERA-1.5deg_AllLevels.nc
      # /home/user/Documents/work/me10Criterion/OneSigma_anom/00Z/nc_files  
    cdo timmean  /home/user/Documents/work/All_levels/OneSigma/Both_pos/Anom""$k""ERA-1.5deg_AllLevels.nc  /home/user/Documents/work/All_levels/OneSigma/Both_pos/Anom""$k""ERA_1.5deg_AllLevels.nc

        rm /home/user/Documents/work/All_levels/OneSigma/Both_pos/Anom""$k""ERA-1.5deg_AllLevels.nc

  for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'+'$j' day' +'%Y-%m-%d'`
           # echo $useDate
            #   echo $i
            rm ""$useDate"".nc
                
          #echo item: $i
       done


done


