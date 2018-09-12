#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
import calendar

server = ECMWFDataServer()
for year in range(1979, 2017):
 print ("YEAR" , year )
 for month in range(12,13):
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
      "param": "169.128/175.128/176.128/177.128",
      "dataset" : "interim",
      "step": "12",
      "grid" : "1.5/1.5",
      "time" : "12",
      "date" : "%s/to/%s"%(bdate,edate),
      "type": "fc",
      "class" : "ei",
      "format" : "netcdf",
      "target" : "ERA_surf_rad_%s_%s.nc"%(bdate,edate)
       })
            





