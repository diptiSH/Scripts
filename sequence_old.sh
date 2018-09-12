#!/bin/bash
 # this is my first shell script.JGRJJD
        dates0=(2008-12-29
2010-01-07
2010-01-13
2010-01-14
2010-01-15
2013-12-17
2013-12-18
2013-12-19
2013-12-20
2013-12-21
2014-01-20
2014-01-25
2014-01-29
2014-01-31
2014-12-23
2014-12-24
2014-12-25
2014-12-28
2014-12-31
2015-01-07
2015-01-08
2015-01-13
)

levels=(SST)
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
    cdo mergetime *.nc "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM1/""$l""/SOM1-""$j""_ERA_1.5_""$l"".nc"
    cdo timmean "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM1/""$l""/SOM1-""$j""_ERA_1.5_""$l"".nc" "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM1/""$l""/CompSOM1-""$j""_ERA_1.5_""$l"".nc"
     cdo sub "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM1/""$l""/CompSOM1-""$j""_ERA_1.5_""$l"".nc" /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERAClim-1.5deg-""$l""-Dec-Jan-1979-2016.nc  "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM1/""$l""/AnomSOM1-""$j""_ERA_1.5_""$l"".nc"

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
    cdo mergetime *.nc "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM1/""$l""/SOM1+""$j""_ERA_1.5_""$l"".nc"
    cdo timmean "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM1/""$l""/SOM1+""$j""_ERA_1.5_""$l"".nc" "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM1/""$l""/CompSOM1+""$j""_ERA_1.5_""$l"".nc"
     cdo sub "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM1/""$l""/CompSOM1+""$j""_ERA_1.5_""$l"".nc" /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERAClim-1.5deg-""$l""-Dec-Jan-1979-2016.nc  "/home/dipti/Documents/data/ERA-1.5/Daily_sequence/SOM1/""$l""/AnomSOM1+""$j""_ERA_1.5_""$l"".nc"

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

