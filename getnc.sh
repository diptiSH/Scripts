#!/bin/bash
 # this is my first shell script.JGRJJD
        dates=(1979-01-10
1979-01-11
1979-12-13
1983-01-06
1983-01-07
1983-01-08
1987-12-15
1990-01-03
1990-01-04
1990-01-05
1993-01-01
1994-12-02
1996-01-12
1998-12-19
1998-12-29
1999-01-01
1999-01-02
1999-01-18
1999-01-19
1999-12-27
2000-01-06
2000-01-23
2001-01-09
2001-01-10
2001-01-11
2001-01-13
2001-01-16
2001-12-12
2001-12-16
2001-12-19
2001-12-27
2002-01-01
2002-01-02
2002-01-03
2003-12-24
2004-01-02
2004-01-03
2004-01-08
2004-01-10
2004-01-11
2004-01-12
2004-01-13
2004-01-14
2004-01-15
2004-12-17
2004-12-18
2004-12-28
2004-12-29
2005-12-29
2006-01-18
2006-12-29
2007-01-01
2008-12-17
2008-12-27
2008-12-31
2009-01-02
2010-01-21
2010-01-22
2011-01-09
2011-01-10
2011-01-11
2011-01-12
2011-01-13
2011-12-15
2011-12-16
2011-12-17
2011-12-19
2011-12-21
2011-12-22
2011-12-23
2012-12-22
2013-01-08
2013-01-09
)
     #levels=( Inversion)
      levels=( 500hPa 700hPa 850hPa 2mTemp SLP 950hPa)
       
      
       for l in "${levels[@]}" 
       do    
       echo ${dates[*]}
       for i in "${dates[@]}"
       do
      #cdo   -seldate,$i /home/iitm/Documents/Data/ERA-1.5/ERADAILY-1.5deg-""$l""-Dec-Jan-1979-2016_00Z.nc "$i"".nc"
          cdo   -seldate,$i /home/iitm/Documents/Data/ERA-1.5/ERADAILY-1.5deg-""$l""-Dec-Jan-1979-2016.nc "$i"".nc"
                echo $i
           
          #echo item: $i

       done

#/home/iitm/Documents/work/inv_sub_posex2003/nc_files
     
     cdo mergetime *.nc /home/iitm/Documents/work/inv_sub_posex2003/nc_files/""$l""/ERADAILY-1.5deg_1.5_""$l"".nc
    cdo timmean /home/iitm/Documents/work/inv_sub_posex2003/nc_files/""$l""/ERADAILY-1.5deg_1.5_""$l"".nc /home/iitm/Documents/work/inv_sub_posex2003/nc_files/""$l""/Comp_ERADAILY-1.5deg_1.5_""$l"".nc
    cdo sub /home/iitm/Documents/work/inv_sub_posex2003/nc_files/""$l""/Comp_ERADAILY-1.5deg_1.5_""$l"".nc  /home/iitm/Documents/Data/ERA-1.5/ERAClim-1.5deg-""$l""-Dec-Jan-1979-2016.nc /home/iitm/Documents/work/inv_sub_posex2003/nc_files/""$l""/Anom_ERADAILY-1.5deg_1.5_""$l"".nc

 #cdo sub /home/iitm/Documents/work/inv_sub_posex2003/nc_files/""$l""/Comp_ERADAILY-1.5deg_1.5_""$l"".nc  /home/iitm/Documents/Data/ERA-1.5/ERAClim-1.5deg-""$l""-Dec-Jan-1979-2016_00Z.nc /home/iitm/Documents/work/inv_sub_posex2003/nc_files/""$l""/Anom_ERADAILY-1.5deg_1.5_""$l"".nc
  for i in "${dates[@]}"
       do
                        # echo $i
                
         rm "$i"".nc"
       done

 done
