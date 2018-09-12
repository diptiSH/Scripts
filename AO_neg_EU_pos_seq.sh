#!/bin/bash

 dates0=(1979-01-11
1981-01-17
1986-01-07
1986-01-08
1993-12-23
1994-01-06
1995-01-02
1997-01-03
1998-01-05
2000-12-29
2002-01-05
2003-01-20
2003-01-23
2003-01-24
2003-01-25
2004-01-02
2004-01-08
2004-01-10
2004-01-14
2005-12-28
2007-01-26
2008-01-07
2008-12-28
2010-01-20
2010-01-21
2010-01-22
2010-01-23
2010-01-24
2010-01-27
2011-01-08
2011-01-09
2011-01-12
2011-01-13
2011-01-14
)




ndays=( -7 -6 -5 -4 -3 -2 -1 0 1 2 3 4 5 6 7)
 for j in "${ndays[@]}"
     do
       
         echo $j
        for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'+'$j' day' +'%Y-%m-%d'`
            #echo $useDate
              # echo $i
            cdo   -seldate,$useDate /media/Seagate\ Backup\ Plus\ Drive/Data/ERA1.5_Data/merged_files/ERA_00_1.5Deg_19790101_20161231.nc ""$useDate"".nc
                
          #echo item: $i
       done

        k= $j
        echo $j

        cdo mergetime *.nc  /home/iitm/Documents/work/All_levels/AO_neg_EU_pos/""$j""ERA-1.5deg_AllLevels.nc
     
    cdo timmean  /home/iitm/Documents/work/All_levels/AO_neg_EU_pos/""$j""ERA-1.5deg_AllLevels.nc  /home/iitm/Documents/work/All_levels/AO_neg_EU_pos/Comp""$j""ERA_1.5deg_AllLevels.nc

        rm /home/iitm/Documents/work/All_levels/AO_neg_EU_pos/""$j""ERA-1.5deg_AllLevels.nc


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
            cdo   -seldate,$useDate /media/Seagate\ Backup\ Plus\ Drive/Data/ERA1.5_Data/merged_files/Anom_ERA_00_1.5Deg_19790101_20161231.nc ""$useDate"".nc
                
          #echo item: $i
       done

        cdo mergetime *.nc  /home/iitm/Documents/work/All_levels/AO_neg_EU_pos/Anom""$j""ERA-1.5deg_AllLevels.nc
       
    cdo timmean  /home/iitm/Documents/work/All_levels/AO_neg_EU_pos/Anom""$j""ERA-1.5deg_AllLevels.nc  /home/iitm/Documents/work/All_levels/AO_neg_EU_pos/Anom""$j""ERA_1.5deg_AllLevels.nc

        rm /home/iitm/Documents/work/All_levels/AO_neg_EU_pos/Anom""$j""ERA-1.5deg_AllLevels.nc

  for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'+'$j' day' +'%Y-%m-%d'`
           # echo $useDate
            #   echo $i
            rm ""$useDate"".nc
                
          #echo item: $i
       done


done


