#!/bin/bash
 # this is my first shell script.JGRJJD
        dates=(1998-12-24
2001-01-03
2002-01-04
2002-01-08
2003-01-03
2003-01-07
2003-01-08
2003-01-12
2003-01-13
2003-01-15
2003-01-16
2003-01-19
2003-01-21
2003-01-24
2003-12-21
2003-12-22
2003-12-23
2003-12-24
2003-12-31
2004-01-01
2004-01-02
2004-01-03
2004-01-04
2004-01-05
2004-01-06
2004-01-15
2004-01-16
2004-12-23
2004-12-24
2004-12-25
2006-01-18
2008-12-28
2008-12-31
2009-01-05
2010-01-02
2010-01-03
2010-01-04
2010-01-06
2010-01-07
2010-01-08
2010-01-09
2010-01-10
2010-01-11
2010-01-12
2010-01-13
2010-01-14
2010-01-15
2010-01-17
2010-01-18
2010-01-19
2010-01-21
2010-01-22
2010-01-24
2010-01-25
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
2011-12-21
2011-12-22
2012-01-06
2012-12-16
2012-12-22
2012-12-23
2012-12-24
2012-12-26
2012-12-27
2012-12-28
2012-12-29
2012-12-30
2012-12-31
2013-01-06
2013-12-18
2013-12-19
2013-12-20
2013-12-21
2013-12-22
2013-12-23
2013-12-24
2014-01-01
2014-01-05
2014-01-06
2014-01-07
2014-01-10
2014-01-15
2014-01-16
2014-01-17
2014-01-19
2014-01-20
2014-01-22
2014-01-23
2014-01-24
2014-01-25
2014-01-29
2014-01-30
2014-01-31
2014-12-20
2014-12-21
2014-12-22
2014-12-23
2014-12-24
2014-12-25
2014-12-26
2014-12-27
2014-12-28
2014-12-29
2014-12-31
2015-01-07
2015-01-09
2015-01-12
2015-01-13
2015-01-14
2015-01-15
2015-01-16
2015-01-20
2015-01-24
2015-01-25
2015-12-10
2015-12-12
2016-01-01
2016-01-14
2016-01-15
2016-01-16
2016-01-17
2016-01-18
2016-01-19
2016-01-20
2016-01-21
2016-01-23
2016-01-24
2016-01-25
2016-01-26
2016-12-02
2016-12-06
2016-12-07
2016-12-08
2016-12-09
2016-12-10
2016-12-11
2016-12-12
2016-12-13
2016-12-14
2016-12-26
2016-12-27
2016-12-28
2016-12-29
2016-12-31
)
        #echo ${dates[*]}
       for i in "${dates[@]}"
       do
        echo $i
 cdo -sellonlatbox,30,150,0,70 -selvar,z,u,v,t -seldate,$i ERADAILY-1.5deg-200hPa-Dec-Jan-1979-2016.nc "/home/dipti/Documents/data/ERA-1.5/morethan13_wider_SA/200/""$i"".nc"
  cdo -sellonlatbox,30,150,0,70 -selvar,z,u,v,t -seldate,$i ERADAILY-1.5deg-500hPa-Dec-Jan-1979-2016.nc "/home/dipti/Documents/data/ERA-1.5/morethan13_wider_SA/500/""$i"".nc"
#cdo -sellonlatbox,30,150,0,70 -selvar,z,u,v,t -seldate,$i ERADAILY-1.5deg-300hPa-Dec-Jan-1979-2016.nc "/home/dipti/Documents/data/ERA-1.5/morethan13_wider_SA/300/""$i"".nc"
cdo -sellonlatbox,30,150,0,70 -selvar,z,u,v,t -seldate,$i ERADAILY-1.5deg-850hPa-Dec-Jan-1979-2016.nc "/home/dipti/Documents/data/ERA-1.5/morethan13_wider_SA/850/""$i"".nc"
#cdo -sellonlatbox,30,150,0,70 -selvar,z,u,v,t -seldate,$i ERADAILY-1.5deg-700hPa-Dec-Jan-1979-2016.nc "/home/dipti/Documents/data/ERA-1.5/morethan13_wider_SA/700/""$i"".nc"
#cdo -sellonlatbox,30,150,0,70 -seldate,$i ERADAILY-1.5deg-SLP-Dec-Jan-1979-2016.nc "/home/dipti/Documents/data/ERA-1.5/morethan13_wider_SA/SLP/""$i"".nc"
       
          #echo item: $i
       done


   
