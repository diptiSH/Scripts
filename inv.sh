#!/bin/bash
 # this is my first shell script.JGRJJD

ncrename -v t2m,t /home/iitm/Documents/work/26Stations_attributes/onday_wd_fog/nc_files/2mTemp/Comp_ERADAILY-1.5deg_1.5_2mTemp.nc

ncrename -v t2m,t /home/iitm/Documents/work/26Stations_attributes/onday_wd_fog/nc_files/2mTemp/Anom_ERADAILY-1.5deg_1.5_2mTemp.nc

cdo sellonlatbox,0,360,0,90 /home/iitm/Documents/work/26Stations_attributes/onday_wd_fog/nc_files/950hPa/Comp_ERADAILY-1.5deg_1.5_950hPa.nc /home/iitm/Documents/work/26Stations_attributes/onday_wd_fog/nc_files/950hPa/NHComp_ERADAILY-1.5deg_1.5_950hPa.nc

cdo sellonlatbox,0,360,0,90 /home/iitm/Documents/work/26Stations_attributes/onday_wd_fog/nc_files/950hPa/Anom_ERADAILY-1.5deg_1.5_950hPa.nc /home/iitm/Documents/work/26Stations_attributes/onday_wd_fog/nc_files/950hPa/NHAnom_ERADAILY-1.5deg_1.5_950hPa.nc

ncdiff /home/iitm/Documents/work/26Stations_attributes/onday_wd_fog/nc_files/950hPa/NHComp_ERADAILY-1.5deg_1.5_950hPa.nc /home/iitm/Documents/work/26Stations_attributes/onday_wd_fog/nc_files/2mTemp/Comp_ERADAILY-1.5deg_1.5_2mTemp.nc  /home/iitm/Documents/work/26Stations_attributes/onday_wd_fog/nc_files/Inversion/Comp_ERADAILY-1.5deg_1.5_Inversion.nc

ncdiff /home/iitm/Documents/work/26Stations_attributes/onday_wd_fog/nc_files/950hPa/NHAnom_ERADAILY-1.5deg_1.5_950hPa.nc /home/iitm/Documents/work/26Stations_attributes/onday_wd_fog/nc_files/2mTemp/Anom_ERADAILY-1.5deg_1.5_2mTemp.nc  /home/iitm/Documents/work/26Stations_attributes/onday_wd_fog/nc_files/Inversion/Anom_ERADAILY-1.5deg_1.5_Inversion.nc
