#!/bin/bash

 dates0=(1979-01-04
1981-01-10
1985-12-31
1986-01-01
1993-12-16
1993-12-30
1994-12-26
1996-12-27
1997-12-29
2000-12-22
2001-12-29
2003-01-13
2003-01-16
2003-01-17
2003-01-18
2003-12-26
2004-01-01
2004-01-03
2004-01-07
2005-12-21
2007-01-19
2007-12-31
2008-12-21
2010-01-13
2010-01-14
2010-01-15
2010-01-16
2010-01-17
2010-01-20
2011-01-01
2011-01-02
2011-01-05
2011-01-06
2011-01-07
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

        cdo mergetime *.nc  /home/user/Documents/work/All_levels/OneSigma/AO_neg_EU_pos/""$k""ERA-1.5deg_SLP_SFC.nc
      # /home/user/Documents/work/me10Criterion/OneSigma_anom/00Z/nc_files  
    cdo timmean  /home/user/Documents/work/All_levels/OneSigma/AO_neg_EU_pos/""$k""ERA-1.5deg_SLP_SFC.nc  /home/user/Documents/work/All_levels/OneSigma/AO_neg_EU_pos/Comp""$k""ERA_1.5deg_SLP_SFC.nc

        rm /home/user/Documents/work/All_levels/OneSigma/AO_neg_EU_pos/""$k""ERA-1.5deg_SLP_SFC.nc


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

        cdo mergetime *.nc  /home/user/Documents/work/All_levels/OneSigma/AO_neg_EU_pos/Anom""$k""ERA-1.5deg_SLP_SFC.nc
      # /home/user/Documents/work/me10Criterion/OneSigma_anom/00Z/nc_files  
    cdo timmean  /home/user/Documents/work/All_levels/OneSigma/AO_neg_EU_pos/Anom""$k""ERA-1.5deg_SLP_SFC.nc  /home/user/Documents/work/All_levels/OneSigma/AO_neg_EU_pos/Anom""$k""ERA_1.5deg_SLP_SFC.nc

        rm /home/user/Documents/work/All_levels/OneSigma/AO_neg_EU_pos/Anom""$k""ERA-1.5deg_SLP_SFC.nc

  for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'+'$j' day' +'%Y-%m-%d'`
           # echo $useDate
            #   echo $i
            rm ""$useDate"".nc
                
          #echo item: $i
       done


done


