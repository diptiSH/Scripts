begin

;*********************Elevation file
fmask=addfile("/home/iitm/Documents/Data/mask/ERA-1.5deg-elevation.nc","r")
data=fmask->z
elev=data(:,{24:32},{74:86})
printVarSummary(elev)
delete(fmask)
;*********************inversion file
fInv=addfile("/home/iitm/Documents/Data/ERA-1.5/ERADAILY-1.5deg-Inversion-Dec-Jan-1979-2016_00Z.nc","r")
t_old=fInv->t
printVarSummary(t_old)
t=t_old(:,{24:32},{74:86})
printVarSummary(t)
inv=linint2_Wrap(t&longitude,t&latitude,t,True,elev&longitude,elev&latitude,0);t(:,{24:32},{-180:180})
printVarSummary(inv)
delete(fInv)
;*********************700 hPa verticle velocity file
fomega=addfile("/home/iitm/Documents/Data/ERA-1.5/ERADAILY-1.5deg-700hPa-Dec-Jan-1979-2016.nc","r")
w_old=fomega->w
printVarSummary(w_old)
w=w_old(:,{24:32},{74:86})
printVarSummary(w)
omega=linint2_Wrap(w&longitude,w&latitude,w,True,elev&longitude,elev&latitude,0);t(:,{24:32},{-180:180})
printVarSummary(omega)
delete(fomega)

;************************* mask region more than 500 m height
maskVar=where(elev.lt.500,1,0)
copy_VarMeta(elev,maskVar)
printVarSummary(maskVar)

;********************** avg inversion for region less than 500 m

maskVar_conf=conform(inv,maskVar(0,:,:),(/1,2/))
printVarSummary(maskVar_conf)

masked_inv= mask(inv,(maskVar_conf.lt.1),False)
AAvg_inv=dim_avg_n_Wrap(masked_inv,(/1,2/))
printVarSummary(AAvg_inv)
print(AAvg_inv(0))
copy_VarMeta(inv,masked_inv)
printVarSummary(masked_inv)
delete(maskVar_conf)

maskVar_conf=conform(omega,maskVar(0,:,:),(/1,2/))
printVarSummary(maskVar_conf)

masked_omega= mask(omega,(maskVar_conf.lt.1),False)
AAvg_omega=dim_avg_n_Wrap(masked_omega,(/1,2/))
printVarSummary(AAvg_omega)
print(AAvg_omega(0))
copy_VarMeta(omega,masked_omega)
printVarSummary(masked_omega)


;********************** area averaged  inversion mean and standard deviation

meanAAinv=avg(AAvg_inv)
stdAAinv=stddev(AAvg_inv)
Anominv=(AAvg_inv-meanAAinv)/stdAAinv

;print(meanAAinv)
;print(stdAAinv)

meanAAomega=avg(AAvg_omega)
stdAAomega=stddev(AAvg_omega)
Anomomega=(AAvg_omega-meanAAomega)/stdAAomega

;print(meanAAomega)
;print(stdAAomega)


;*************get extreme days and get no of foggy stations for them

noStations=asciiread("foggyStations.txt",2139,"integer")
dates=asciiread("dates.txt",2139,"string")
;print(noStations)
 print(num(AAvg_inv.gt.(meanAAinv+stdAAinv)))


extremeDay=0
do i=0,2138
   if(AAvg_inv(i).gt.(meanAAinv+stdAAinv)) then
        if(noStations(i) .gt. 13)then
     
        extremeDay=extremeDay+1
     end if
  
   end if
end do


stationList=new(extremeDay,"integer")
indices=new(extremeDay,"integer")
dateList=new(extremeDay,"string")
invList=new(extremeDay,"double")
extremeDay=0
do i=0,2138
   if(AAvg_inv(i).gt.(meanAAinv+stdAAinv)) then
      if(noStations(i) .gt. 13)then
      indices(extremeDay)=i
       stationList(extremeDay)=noStations(i)
      dateList(extremeDay)=dates(i)
       invList(extremeDay)=(AAvg_inv(i)-meanAAinv)/stdAAinv
        extremeDay=extremeDay+1
     end if
   end if
end do
;print(extremeDay)
;print(stationList)
;print(max(stationList))
;print(min(stationList))
;print(dateList)


 asciiwrite ("Z00_moreThan13_1std.txt" ,  dateList)
 asciiwrite ("Inv_Z00_moreThan13_1std.txt" ,  invList)
 asciiwrite ("Inv_Z00_ALl.txt" ,  Anominv)
 asciiwrite("omega_all_day.txt",Anomomega)


;print(indices)
;print(num(stationList.gt.20))
;print(num(stationList.gt.11))
;print(num(stationList.gt.12))
;print(num(stationList.gt.15))





;************************************* code to chk masking of inv
 ;wks = gsn_open_wks("png" ,"ce")       ;send graphics to PNG file

 ; res                       = True      ;plot mods desired

;  res@gsnMaximize           = True      ;Make plot fit the frame
 ; res@cnFillOn              = True      ;turn on color fill
 ; res@cnLinesOn             = False     ;turn of contour lines
 ; res@cnLevelSpacingF       = 0.5       ;contour spacing
 ; res@cnFillPalette         = "BlAqGrYeOrRe"
 ; res@lbOrientation         = "Vertical"

  ;res@gsnAddCyclic          = False     ;data already has cyclic point
				        ;this must also be set for any zoom


; Note that the gsn_csm_*map* templates automatically set 
 ;res@mpLimitMode="LatLon" ;for you. If you are plotting a 
                          ;different projection, you may have to set this resource.

  ;res@mpMinLatF            = 23       ; range to zoom in on
  ;res@mpMaxLatF            =  33.
  ;res@mpMinLonF            =  73.
  ;res@mpMaxLonF            = 87.

  ;res@tiMainString = "Default map tickmark labels"
  ;plot = gsn_csm_contour_map(wks,inv(0,:,:), res)




;************************************* code to chk masking
; wks = gsn_open_wks("png" ,"ce")      ; send graphics to PNG file

;  res                       = True     ; plot mods desired

 ; res@gsnMaximize           = True     ; Make plot fit the frame
 ; res@cnFillOn              = True     ; turn on color fill
 ; res@cnLinesOn             = False    ; turn of contour lines
 ; res@cnLevelSpacingF       = 0.5      ; contour spacing
 ; res@cnFillPalette         = "BlAqGrYeOrRe"
 ; res@lbOrientation         = "Vertical"

  ;res@gsnAddCyclic          = False    ; data already has cyclic point
				       ; this must also be set for any zoom

;
; Note that the gsn_csm_*map* templates automatically set 
; res@mpLimitMode="LatLon" for you. If you are plotting a 
; different projection, you may have to set this resource.
;
  ;res@mpMinLatF            = 23      ; range to zoom in on
  ;res@mpMaxLatF            =  33.
  ;res@mpMinLonF            =  73.
  ;res@mpMaxLonF            = 87.

  ;res@tiMainString = "Default map tickmark labels"
  ;plot = gsn_csm_contour_map(wks,inv(0,:,:), res)
print(meanAAinv)
print(stdAAinv)


end
