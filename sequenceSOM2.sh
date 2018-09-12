#!/bin/bash
 # this is my first shell script.JGRJJD
        dates0=(2003-01-24
2004-12-24
2008-12-28
2010-01-08
2010-01-09
2010-01-21
2010-01-22
2010-01-24
2010-01-25
2011-01-07
2011-01-08
2011-01-09
2011-01-10
2011-12-21
2011-12-22
2012-12-28
2012-12-29
2012-12-31
2013-12-23
2014-01-17
2014-12-22
2014-12-29
2015-01-25
2016-01-17
2016-01-23
2016-01-25
 )

levels=(200hPa 300hPa 500hPa 700hPa 850hPa SLP)
 for l in "${levels[@]}"
     do
         echo $l

ndays=( 1 2 3 4 5 6 7)

  for j in "${ndays[@]}"
     do
         echo $j
        for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'-'$j' day' +'%Y-%m-%d'`
            echo $useDate
               echo $i
             cdo   -seldate,$useDate /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-""$l""-Dec-Jan-1979-2016.nc "$useDate"".nc"
                
          #echo item: $i
       done
    cdo mergetime *.nc "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM2/""$l""/SOM2-""$j""_ERA_1.5_""$l"".nc"
    cdo timmean "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM2/""$l""/SOM2-""$j""_ERA_1.5_""$l"".nc" "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM2/""$l""/CompSOM2-""$j""_ERA_1.5_""$l"".nc"
     cdo sub "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM2/""$l""/CompSOM2-""$j""_ERA_1.5_""$l"".nc" /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERAClim-1.5deg-""$l""-Dec-Jan-1979-2016.nc  "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM2/""$l""/AnomSOM2-""$j""_ERA_1.5_""$l"".nc"

     echo $j
        for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'-'$j' day' +'%Y-%m-%d'`
            echo $useDate
               echo $i
            rm "$useDate"".nc"
                
          #echo item: $i
       done

done


ndays=( 0 1 2 3 4 5 6 7)
 for j in "${ndays[@]}"
     do
         echo $j
        for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'+'$j' day' +'%Y-%m-%d'`
            echo $useDate
               echo $i
             cdo   -seldate,$useDate /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-""$l""-Dec-Jan-1979-2016.nc "$useDate"".nc"
                
          #echo item: $i
       done
    cdo mergetime *.nc "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM2/""$l""/SOM2+""$j""_ERA_1.5_""$l"".nc"
    cdo timmean "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM2/""$l""/SOM2+""$j""_ERA_1.5_""$l"".nc" "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM2/""$l""/CompSOM2+""$j""_ERA_1.5_""$l"".nc"
     cdo sub "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM2/""$l""/CompSOM2+""$j""_ERA_1.5_""$l"".nc" /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERAClim-1.5deg-""$l""-Dec-Jan-1979-2016.nc  "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM2/""$l""/AnomSOM2+""$j""_ERA_1.5_""$l"".nc"

     echo $j
        for i in "${dates0[@]}"
       do
            useDate=`date --date=$i'+'$j' day' +'%Y-%m-%d'`
            echo $useDate
               echo $i
            rm "$useDate"".nc"
                
          #echo item: $i
       done

done

done



