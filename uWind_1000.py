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
    'stream'    : "oper",
    'levtype'   : "sfc",
    'param'     : "165.128/166.128/167.128/168.128",
    'dataset'   : "interim",
    'step'      : "12",
    'grid'      : "1.5/1.5",
    'time'      : "00/06/12/18",
    'date'      : "%s/to/%s"%(bdate,edate),
    'type'      : "an",
    'class'     : "ei",
    "format" : "netcdf",
    "target" : "ERA_SFCdata_12Z_%s_%s.nc"%(bdate,edate)
     })
            
