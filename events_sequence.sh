#!/bin/bash
 # this is my first shell script.JGRJJD
        dates0=(2010-01-20	2010-01-19	2010-01-18	2010-01-17	2010-01-16	2010-01-15	2010-01-14	2010-01-13	2010-01-12	2010-01-11	2010-01-10	2010-01-09	2010-01-08	2010-01-07	2010-01-06 )
  dates1=(  2016-12-14	  2016-12-13	2016-12-12	2016-12-11	2016-12-10	2016-12-09	2016-12-08	2016-12-07	2016-12-06	2016-12-05	2016-12-04	2016-12-03	2016-12-02	2016-12-01	2016-11-30 )
 dates2=(   2015-02-01	2015-01-31	2015-01-30	2015-01-29	2015-01-28	2015-01-27	2015-01-26	2015-01-25	2015-01-24	2015-01-23	2015-01-22	2015-01-21	2015-01-20	2015-01-19	2015-01-18 )
  dates3=(     2016-01-14	2016-01-15	2016-01-16	2016-01-17	2016-01-18	2016-01-19	2016-01-20	2016-01-21	2016-01-22	2016-01-23	2016-01-24	2016-01-25	2016-01-26	2016-01-27	2016-01-28  )
        #echo ${dates[*]}
       j=7
       k=1
       for i in "${dates0[@]}"
       do
         cdo   -seldate,$i /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-200hPa-Dec-Jan-1979-2016.nc "/home/dipti/Documents/data/ERA-1.5/eventSequence/13Jan2010/200/""$j"".nc"
         cdo sub "/home/dipti/Documents/data/ERA-1.5/eventSequence/13Jan2010/200/""$j"".nc" /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERAClim-1.5deg-200hPa-Dec-Jan-1979-2016.nc   "/home/dipti/Documents/data/ERA-1.5/eventSequence/13Jan2010/200/Anom_200""$j"".nc"
   j=$((j-1))
      echo $j
   
                echo $i
                
          #echo item: $i
       done

 j=7
       for i in "${dates3[@]}"
       do
         cdo   -seldate,$i /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-200hPa-Dec-Jan-1979-2016.nc "/home/dipti/Documents/data/ERA-1.5/eventSequence/21Jan2016/200/""$j"".nc"
         cdo sub "/home/dipti/Documents/data/ERA-1.5/eventSequence/21Jan2016/200/""$j"".nc" /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERAClim-1.5deg-200hPa-Dec-Jan-1979-2016.nc   "/home/dipti/Documents/data/ERA-1.5/eventSequence/21Jan2016/200/Anom_200""$j"".nc"
    j=$((j-1))
      echo $j
                echo $i
                
          #echo item: $i
       done

 j=7
       for i in "${dates2[@]}"
       do
         cdo   -seldate,$i /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-200hPa-Dec-Jan-1979-2016.nc "/home/dipti/Documents/data/ERA-1.5/eventSequence/25Jan2015/200/""$j"".nc"
         cdo sub "/home/dipti/Documents/data/ERA-1.5/eventSequence/25Jan2015/200/""$j"".nc" /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERAClim-1.5deg-200hPa-Dec-Jan-1979-2016.nc   "/home/dipti/Documents/data/ERA-1.5/eventSequence/25Jan2015/200/Anom_200""$j"".nc"
   j=$((j-1))
      echo $j
                echo $i
                
          #echo item: $i
       done

j=7
       for i in "${dates1[@]}"
       do
         cdo   -seldate,$i /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERADAILY-1.5deg-200hPa-Dec-Jan-1979-2016.nc "/home/dipti/Documents/data/ERA-1.5/eventSequence/7Dec2016/200/""$j"".nc"
         cdo sub "/home/dipti/Documents/data/ERA-1.5/eventSequence/7Dec2016/200/""$j"".nc" /home/dipti/Documents/data/ERA-1.5/ERA1.5_files/test/ERAClim-1.5deg-200hPa-Dec-Jan-1979-2016.nc   "/home/dipti/Documents/data/ERA-1.5/eventSequence/7Dec2016/200/Anom_200""$j"".nc"
j=$((j-1))
      echo $j
                
          #echo item: $i
       done

     
    

