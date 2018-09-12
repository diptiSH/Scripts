#!/bin/bash
 # this is my first shell script.JGRJJD
        dates=(1997-12-27
1998-01-09
2001-01-03
2001-01-08
2001-01-12
2001-01-13
2001-12-12
2001-12-13
2003-01-02
2003-01-03
2003-01-20
2003-01-21
2003-01-24
2003-01-25
2003-12-23
2003-12-24
2003-12-29
2003-12-31
2004-01-01
2004-01-02
2004-01-03
2004-01-04
2004-01-05
2004-01-06
2004-01-14
2004-01-15
2004-01-16
2004-01-20
2004-12-19
2004-12-20
2004-12-23
2004-12-24
2004-12-25
2008-12-28
2008-12-31
2009-01-25
2010-01-02
2010-01-03
2010-01-08
2010-01-09
2010-01-10
2010-01-11
2010-01-12
2010-01-18
2010-01-19
2010-01-21
2010-01-22
2010-01-23
2010-01-24
2010-01-25
2010-01-26
2011-01-04
2011-01-05
2011-01-06
2011-01-07
2011-01-08
2011-01-09
2011-01-10
2011-01-11
2011-01-12
2011-01-13
2011-01-14
2011-01-15
2011-12-17
2011-12-18
2011-12-21
2011-12-22
2012-01-03
2012-01-04
2012-01-05
2012-01-06
2012-01-08
2012-12-16
2012-12-22
2012-12-26
2012-12-27
2012-12-28
2012-12-29
2012-12-30
2012-12-31
2013-01-05
2013-01-06
2013-01-08
2013-01-09
2013-12-22
2013-12-23
2013-12-24
2014-01-01
2014-01-05
2014-01-06
2014-01-07
2014-01-09
2014-01-10
2014-01-12
2014-01-17
2014-12-18
2014-12-19
2014-12-20
2014-12-21
2014-12-22
2014-12-29
2014-12-30
2015-01-15
2015-01-16
2015-01-24
2015-01-25
2015-01-26
2015-01-28

)
        #echo ${dates[*]}
       for i in "${dates[@]}"
       do
         cdo   -seldate,$i /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-200hPa-Dec-Jan-1979-2016.nc "$i"".nc"
                echo $i
                
          #echo item: $i
       done

     cdo mergetime *.nc /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/SOM2_ERA_1.5_200hPa.nc
     cdo timmean /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/SOM2_ERA_1.5_200hPa.nc /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/composite/CompSOM2_ERA_1.5_200hPa.nc
    for i in "${dates[@]}"
       do
        rm "$i"".nc"
                echo $i
                
          #echo item: $i
       done

 for i in "${dates[@]}"
       do
       cdo   -seldate,$i /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-500hPa-Dec-Jan-1979-2016.nc "$i"".nc"
        
echo $i
              
          #echo item: $i
        done
    cdo mergetime *.nc /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/SOM2_ERA_1.5_500hPa.nc
     cdo timmean /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/SOM2_ERA_1.5_500hPa.nc /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/composite/CompSOM2_ERA_1.5_500hPa.nc

 for i in "${dates[@]}"
       do
        rm "$i"".nc"
                echo $i
                
          #echo item: $i
       done

 for i in "${dates[@]}"
       do
 cdo   -seldate,$i /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-300hPa-Dec-Jan-1979-2016.nc "$i"".nc"

        echo $i
              
          #echo item: $i
       done
     cdo mergetime *.nc /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/SOM2_ERA_1.5_300hPa.nc
      cdo timmean /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/SOM2_ERA_1.5_300hPa.nc /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/composite/CompSOM2_ERA_1.5_300hPa.nc

 for i in "${dates[@]}"
       do
        rm "$i"".nc"
                echo $i
                
          #echo item: $i
       done

 for i in "${dates[@]}"
       do

cdo   -seldate,$i /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-850hPa-Dec-Jan-1979-2016.nc "$i"".nc"

        echo $i
              
          #echo item: $i
       done
   cdo mergetime *.nc /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/SOM2_ERA_1.5_850hPa.nc
    cdo timmean /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/SOM2_ERA_1.5_850hPa.nc /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/composite/CompSOM2_ERA_1.5_850hPa.nc

 for i in "${dates[@]}"
       do
        rm "$i"".nc"
                echo $i
                
          #echo item: $i
       done

 for i in "${dates[@]}"
       do

cdo   -seldate,$i /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-700hPa-Dec-Jan-1979-2016.nc "$i"".nc"


        echo $i
              
          #echo item: $i
       done
cdo mergetime *.nc /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/SOM2_ERA_1.5_700hPa.nc
 cdo timmean /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/SOM2_ERA_1.5_700hPa.nc /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/composite/CompSOM2_ERA_1.5_700hPa.nc

 for i in "${dates[@]}"
       do
        rm "$i"".nc"
                echo $i
                
          #echo item: $i
       done

 for i in "${dates[@]}"
       do
 cdo  -seldate,$i /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-SLP-Dec-Jan-1979-2016.nc "$i"".nc"
        echo $i
              
          #echo item: $i
       done
   cdo mergetime *.nc /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/SOM2_ERA_1.5_SLP.nc
    cdo timmean /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/SOM2_ERA_1.5_SLP.nc /home/dipti/Documents/data/ERA-1.5/SOM2_21Feb/composite/CompSOM2_ERA_1.5_SLP.nc

 

 for i in "${dates[@]}"
       do
        rm "$i"".nc"
                echo $i
                
          #echo item: $i
       done


   
