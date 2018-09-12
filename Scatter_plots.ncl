begin
;************************foogy stations
noStations=asciiread("foggyStations.txt",2139,"integer")
;*********************975hPa file
fOmega=addfile("/media/Seagate Backup Plus Drive/desktop_backup_1_june_18/Documents/Data/ERA-1.5/ERADAILY-1.5deg-975hPa-Dec-Jan-1979-2016.nc","r")
w=fOmega->w
omega=w(:,{24:32},{74:86})
printVarSummary(omega)
delete(fOmega)
;*********************Elevation file
fmask=addfile("/home/iitm/Documents/Data/mask/ERA-1.5deg-elevation.nc","r")
data=fmask->z
elev=data(:,{24:32},{74:86})
printVarSummary(elev)
delete(fmask)
;*********************inversion file
fInv=addfile("/media/Seagate Backup Plus Drive/desktop_backup_1_june_18/Documents/Data/ERA-1.5/ERADAILY-1.5deg-Inversion-Dec-Jan-1979-2016.nc","r")
t_old=fInv->t
printVarSummary(t_old)
t=t_old(:,{24:32},{74:86})
printVarSummary(t)
inv=linint2_Wrap(t&longitude,t&latitude,t,True,elev&longitude,elev&latitude,0);t(:,{24:32},{-180:180})
printVarSummary(inv)
delete(fInv)

;*********************Surface variabels file relative humidity, 2m dew point temp, 2m temp, mean sea level pressure
ft2m=addfile("/media/Seagate Backup Plus Drive/desktop_backup_1_june_18/Documents/Data/ERA-1.5/ERADAILY-1.5deg-2mTemp-Dec-Jan-1979-2016.nc","r")
t2m_old=ft2m->t2m
printVarSummary(t_old)
t2m=t2m_old(:,{24:32},{74:86})
printVarSummary(t2m)
delete(ft2m)

fmsl=addfile("/media/Seagate Backup Plus Drive/desktop_backup_1_june_18/Documents/Data/ERA-1.5/ERADAILY-1.5deg-SLP-Dec-Jan-1979-2016.nc","r")
msl_old=fmsl->msl
printVarSummary(t_old)
msl=msl_old(:,{24:32},{74:86})
printVarSummary(msl)
delete(fmsl)



;************************* mask region more than 500 m height
maskVar=where(elev.lt.500,1,0)
copy_VarMeta(elev,maskVar)
printVarSummary(maskVar)

;********************** avg omega and inversion for region less than 500 m

maskVar_conf=conform(inv,maskVar(0,:,:),(/1,2/))
printVarSummary(maskVar_conf)

masked_inv= mask(inv,(maskVar_conf.lt.1),False)
AAvg_inv=dim_avg_n_Wrap(masked_inv,(/1,2/))
printVarSummary(AAvg_inv)
print(AAvg_inv(0))
copy_VarMeta(inv,masked_inv)
printVarSummary(masked_inv)


masked_omega= mask(omega,(maskVar_conf.lt.1),False)
AAvg_omega=dim_avg_n_Wrap(masked_omega,(/1,2/))
printVarSummary(AAvg_omega)
print(AAvg_omega(0))
copy_VarMeta(omega,masked_omega)
printVarSummary(masked_omega)


masked_t2m= mask(t2m,(maskVar_conf.lt.1),False)
AAvg_t2m=dim_avg_n_Wrap(masked_t2m,(/1,2/))
printVarSummary(AAvg_t2m)
print(AAvg_t2m(0))
copy_VarMeta(t2m,masked_t2m)
printVarSummary(masked_t2m)


masked_msl= mask(msl,(maskVar_conf.lt.1),False)
AAvg_msl=dim_avg_n_Wrap(masked_msl,(/1,2/))
printVarSummary(AAvg_msl)
print(AAvg_msl(0))
copy_VarMeta(msl,masked_msl)
printVarSummary(masked_msl)

stringArray=(/"inv","omega","t2m","msl"/)
avgArray=(/AAvg_inv(0:2138),AAvg_omega(0:2138),AAvg_t2m(0:2138),AAvg_msl(0:2138)/)
printVarSummary(avgArray)
;*********************************scatter plot

do i=0,dimsizes(stringArray)-1
  wks = gsn_open_wks ("png","scatter_"+stringArray(i))
  res                    = True
  res@tiMainString       = " Number of stations reporting fog Vs "+stringArray(i)
  res@tiXAxisString      = "Number of stations reporting fog"
  res@tiYAxisString      = stringArray(i)
  res@tiMainFontHeightF  = 0.03
  res@xyMarkLineMode     = "Markers"
  res@xyMarkerSizeF      = 0.001
  res@xyMarkerThicknessF = 3.
  res@xyMonoMarkerColor  = True         ; Allow different colors for markers
  res@xyMarker           = 16
  res@xyMarkerColor      = "red" 
 plot = gsn_csm_xy (wks,noStations,avgArray(i,:),res)

end do



end
