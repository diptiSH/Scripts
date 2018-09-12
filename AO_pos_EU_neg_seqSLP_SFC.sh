#!/bin/bash

 dates0=(1978-12-30
1987-12-23
1987-12-24
1989-12-28
1989-12-31
1990-01-07
1992-12-23
1992-12-25
1992-12-26
1997-01-06
1998-12-21
1998-12-22
1999-01-13
1999-01-14
1999-01-15
1999-12-30
2000-01-01
2000-01-02
2000-01-03
2001-01-08
2001-01-12
2001-01-13
2003-01-05
2003-01-06
2003-01-07
2003-01-08
2003-01-09
2003-01-10
2006-01-03
2006-01-05
2006-01-06
2007-01-03
2007-12-13
2011-12-20
2013-01-21
2013-01-22
2013-01-23
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

        cdo mergetime *.nc  /home/user/Documents/work/All_levels/OneSigma/AO_pos_EU_neg/""$k""ERA-1.5deg_SLP_SFC.nc
      # /home/user/Documents/work/me10Criterion/OneSigma_anom/00Z/nc_files  
    cdo timmean  /home/user/Documents/work/All_levels/OneSigma/AO_pos_EU_neg/""$k""ERA-1.5deg_SLP_SFC.nc  /home/user/Documents/work/All_levels/OneSigma/AO_pos_EU_neg/Comp""$k""ERA_1.5deg_SLP_SFC.nc

        rm /home/user/Documents/work/All_levels/OneSigma/AO_pos_EU_neg/""$k""ERA-1.5deg_SLP_SFC.nc


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

        cdo mergetime *.nc  /home/user/Documents/work/All_levels/OneSigma/AO_pos_EU_neg/Anom""$k""ERA-1.5deg_SLP_SFC.nc
      # /home/user/Documents/work/me10Criterion/OneSigma_anom/00Z/nc_files  
    cdo timmean  /home/user/Documents/work/All_levels/OneSigma/AO_pos_EU_neg/Anom""$k""ERA-1.5deg_SLP_SFC.nc  /home/user/Documents/work/All_levels/OneSigma/AO_pos_EU_neg/Anom""$k""ERA_1.5deg_SLP_SFC.nc

        rm /home/user/Documents/work/All_levels/OneSigma/AO_pos_EU_neg/Anom""$k""ERA-1.5deg_SLP_SFC.nc

  for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'+'$j' day' +'%Y-%m-%d'`
           # echo $useDate
            #   echo $i
            rm ""$useDate"".nc
                
          #echo item: $i
       done


done


