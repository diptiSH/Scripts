#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
import calendar

server = ECMWFDataServer()
for year in range(2016, 2017):
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
      "class": "ei",
      "dataset": "interim",
      "date" : "%s/to/%s"%(bdate,edate),
      "expver": "1",
      "grid": "1.5/1.5",
      "levtype": "sfc",
       "param": "167.128",
      "step": "0",
      "stream": "oper",
      "time": "00:00:00",
      "type": "an",
      "format" : "netcdf",
      "target" : "ERA_surf_temp_%s_%s.nc"%(bdate,edate)
       })

            





