#!/bin/bash

 dates0=(1981-12-19
1982-01-12
1990-01-06
1996-12-16
1996-12-24
1996-12-25
1996-12-29
1997-01-04
1998-12-23
1998-12-24
2001-01-11
2003-01-11
2003-01-12
2003-01-14
2003-01-15
2005-12-22
2005-12-23
2005-12-24
2006-01-09
2006-01-10
2006-01-11
2006-01-24
2010-01-18
2010-01-19
2012-12-22
2013-01-05
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
            cdo   -seldate,$useDate /home/user/Documents/Data/ERA-1.5/ERADAILY-1.5deg-SLP_SFC-Dec-Jan-1979-2016.nc ""$useDate"".nc
                
          #echo item: $i
       done

        k=`expr $j - 7`
        echo $k

        cdo mergetime *.nc  /home/user/Documents/work/All_levels/OneSigma/Both_neg/""$k""ERA-1.5deg_SLP_SFC.nc
      # /home/user/Documents/work/me10Criterion/OneSigma_anom/00Z/nc_files  
    cdo timmean  /home/user/Documents/work/All_levels/OneSigma/Both_neg/""$k""ERA-1.5deg_SLP_SFC.nc  /home/user/Documents/work/All_levels/OneSigma/Both_neg/Comp""$k""ERA_1.5deg_SLP_SFC.nc

        rm /home/user/Documents/work/All_levels/OneSigma/Both_neg/""$k""ERA-1.5deg_SLP_SFC.nc


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
            cdo   -seldate,$useDate /home/user/Documents/Data/ERA-1.5/Daily_anomalies/ERAANOM-1.5deg-SLP_SFC-Dec-Jan-1979-2016.nc ""$useDate"".nc
                
          #echo item: $i
       done

        cdo mergetime *.nc  /home/user/Documents/work/All_levels/OneSigma/Both_neg/Anom""$k""ERA-1.5deg_SLP_SFC.nc
      # /home/user/Documents/work/me10Criterion/OneSigma_anom/00Z/nc_files  
    cdo timmean  /home/user/Documents/work/All_levels/OneSigma/Both_neg/Anom""$k""ERA-1.5deg_SLP_SFC.nc  /home/user/Documents/work/All_levels/OneSigma/Both_neg/Anom""$k""ERA_1.5deg_SLP_SFC.nc

        rm /home/user/Documents/work/All_levels/OneSigma/Both_neg/Anom""$k""ERA-1.5deg_SLP_SFC.nc

  for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'+'$j' day' +'%Y-%m-%d'`
           # echo $useDate
            #   echo $i
            rm ""$useDate"".nc
                
          #echo item: $i
       done


done


