#!/usr/bin/env python
from ecmwfapi import ECMWFDataServer
server = ECMWFDataServer()
server.retrieve({
    "class": "ei",
    "dataset": "interim",
    "date": "1979-01-01/to/1979-01-31",
    "expver": "1",
    "grid": "0.75/0.75",
    "levtype": "sfc",
    "param": "165.128/166.128",
    "step": "0",
    "stream": "oper",
    "time": "00:00:00/12:00:00",
    "type": "an",
    "format"    : "netcdf",
    "target": "output.nc",
})
server.retrieve({
    "class": "ei",
    "dataset": "interim",
    "date": "1979-01-01/to/1979-01-31",
    "expver": "1",
    "grid": "0.75/0.75",
    "levtype": "sfc",
    "param": "165.128/166.128/176.128/177.128/178.128/179.128/208.128/209.128/210.128/211.128",
    "step": "3/6/9/12",
    "stream": "oper",
    "time": "00:00:00/12:00:00",
    "type": "fc",
    "format"    : "netcdf",
    "target": "output2.nc",
})
