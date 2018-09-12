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
      "class": "ei",
      "dataset": "interim",
      "date" : "%s/to/%s"%(bdate,edate),
      "expver": "1",
      "grid": "1.5/1.5",
      "levtype": "sfc",
      "param": "168.128",
      "step": "0",
      "stream": "oper",
      "time": "00:00:00/12:00:00",
      "type": "an",
      "format" : "netcdf",
      "target" : "ERA_2m_dewT_%s_%s.nc"%(bdate,edate)
       })

            





