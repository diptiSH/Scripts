#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
import calendar

server = ECMWFDataServer()
for day in range(15, 16):
 edate="201501%02d"%(day)
 print ("######### ERA-interim  #########")
 print ('get data for ',edate,' (YYYYMMDD)' )
 print ("################################")


 server.retrieve({
     "stream": "oper",
     "levtype" : "sfc",
     "param": "134.128/139.128/151.128/159.128/165.128/166.128/167.128/168.128/170.128/183.128/236.128/246.228/247.228",
     "dataset" : "era5",
     "time" : "00:00:00/01:00:00/02:00:00/03:00:00/04:00:00/05:00:00/06:00:00/07:00:00/08:00:00/09:00:00/10:00:00/11:00:00/12:00:00/13:00:00/14:00:00/15:00:00/16:00:00/17:00:00/18:00:00/19:00:00/20:00:00/21:00:00/22:00:00/23:00:00",
     "expver": "1",
     "date" : "%s"%(edate),
     "type" : "an",
     "class" : "ea",
     "format" : "grib2",
     "target" : "ERA5_sfc_global_%s.grib2"%(edate)
      })
            
