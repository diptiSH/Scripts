#!/bin/bash
 # this is my first shell script.JGRJJD
        dates0=(1979-01-05
1989-12-29
1992-12-26
1998-12-23
1999-01-15
2000-01-03
2001-01-09
2004-01-04
2004-12-23
2005-12-23
2007-01-21
2010-01-16
2011-01-07
2011-12-16
)

levels=(950hPa 500hPa 700hPa 850hPa 2mTemp SLP )
 for l in "${levels[@]}"
     do
         echo $l

ndays=( 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14)
 for j in "${ndays[@]}"
     do
         echo $j
        for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'+'$j' day' +'%Y-%m-%d'`
            echo $useDate
               echo $i
            cdo   -seldate,$useDate /home/iitm/Documents/Data/ERA-1.5/ERADAILY-1.5deg-""$l""-Dec-Jan-1979-2016.nc ""$useDate"".nc
                
          #echo item: $i
       done


     cdo mergetime *.nc /home/iitm/Documents/work/z00criterion/std1_moreThan13/nc_files/sequence3/""$l""/FogDay""$j""_ERA_1.5_""$l"".nc
    cdo timmean /home/iitm/Documents/work/z00criterion/std1_moreThan13/nc_files/sequence3/""$l""/FogDay""$j""_ERA_1.5_""$l"".nc /home/iitm/Documents/work/z00criterion/std1_moreThan13/nc_files/sequence3/""$l""/CompFogDay""$j""_ERA_1.5_""$l"".nc
     cdo sub /home/iitm/Documents/work/z00criterion/std1_moreThan13/nc_files/sequence3/""$l""/CompFogDay""$j""_ERA_1.5_""$l"".nc /home/iitm/Documents/Data/ERA-1.5//ERAClim-1.5deg-""$l""-Dec-Jan-1979-2016.nc  /home/iitm/Documents/work/z00criterion/std1_moreThan13/nc_files/sequence3/""$l""/AnomFogDay""$j""_ERA_1.5_""$l"".nc

     echo $j
        for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'+'$j' day' +'%Y-%m-%d'`
            echo $useDate
               echo $i
            rm ""$useDate"".nc
                
          #echo item: $i
       done

done

done



