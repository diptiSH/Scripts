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
      "levtype": "pl",
      "levelist":"1/2/3/5/7/10/20/30/50/70/100/125/150/175/200/225/250/300/350/400/450/500/550/600/650/700/750/775/800/825/850/875/900/925/950/975/1000",
      "param": "60.128/129.128/130.128/131.128/132.128/133.128/135.128/138.128/155.128/157.128",
      "step": "0",
      "stream": "oper",
      "time": "00:00:00",
      "type": "an",
      "format" : "netcdf",
      "target" : "ERA_00_%s_%s.nc"%(bdate,edate)
       })
  



