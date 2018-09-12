#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
import calendar

server = ECMWFDataServer()
for year in range(1979, 2017):
 print ("YEAR" , year )
 for month in range(1,2):
  lastday1=calendar.monthrange(year,month)
  lastday=lastday1[1]
  bdate="%s%02d01"%(year,month)
  edate="%s%02d%s"%(year,month,lastday)
  print ("######### ERA-interim  #########")
  print ('get data from ', bdate,' to ',edate,' (YYYYMMDD)' )
  print ("################################")


  server.retrieve({
      "stream": "oper",
      "levtype" : "sfc",
      "param": "84.162",
      "dataset" : "interim",
      "step": "0",
      "grid" : "1.5/1.5",
       "time" : "00:00:00/12:00:00",
      "date" : "%s/to/%s"%(bdate,edate),
      "type": "an",
      "class" : "ei",
      "format" : "netcdf",
      "target" : "ERA_div_ver_int_moi_%s_%s.nc"%(bdate,edate)
       })
            





