begin


;*********************inversion file
fInv=addfile("/home/user/Documents/Data/ERA-1.5/ERADAILY-1.5deg-Inversion-Dec-Jan-1979-2016_00Z.nc","r")
t_old=fInv->t
printVarSummary(t_old)
inv=t_old(:,{24:32},{74:86})
printVarSummary(inv)

 lat2d = inv&latitude
  lon2d = inv&longitude

print(lat2d)
print(lon2d)

  lat   = (/ 24.39 , 31.38 , 30.2 , 30.23 , 29.1 , 29.42 , 29.02 , 28.5 , 28.34 , 28.35 , 27.53 , 27.54 , 27.23 , 27.34 , 26.45 , 26.15 , 26.45 , 26.07 , 26.56 , 25.27 , 25.27 , 25.24 , 25.18 , 25.45 , 25.36 , 24.45  /) 

 ; user specified coordinate pairs
  lon   = (/ 83.06 , 74.52 , 76.28 , 76.46 , 75.44 , 77.02 , 79.28 , 76.35 , 77.07 , 77.12 , 79.54 , 80.48 , 80.1 , 81.36 , 80.53 , 82 , 83.22 , 85.24 , 80.5 , 81.41 , 82.52 , 83.33 , 83.01 , 84.1 , 85.1 , 84.57  /)

                                          ; return 2d subscripts
  nlat =  ind_nearest_coord (  lat, lat2d , 0)
  nlon =  ind_nearest_coord (  lon, lon2d , 0)


printVarSummary(nlat)

;exit
avg_Inv=new(2356,double,0.0)
avg_Inv=inv(:,nlat(0),nlon(0))

printVarSummary(inv(:,nlat(0),nlon(0)))
printVarSummary(avg_Inv)


;printVarSummary(avg_t2m)
;print(w(:,nlat(0),nlon(0)))

; *********** avg over desired points


do l=0,25

;print(nlat(l))

avg_Inv=avg_Inv+inv(:,nlat(l),nlon(l))

end do

avg_Inv=avg_Inv/26.0

AAvg_inv=avg_Inv
printVarSummary(AAvg_inv)
print(AAvg_inv(0))
;copy_VarMeta(inv,masked_inv)
;printVarSummary(masked_inv)
printVarSummary(AAvg_inv)


;*********************get daily mean ydaymean
dailyMYTs=new((/38,62/),"double")

j=0
do i=0,2355,62
dailyMYTs(j,:)=AAvg_inv(i:i+61)
j=j+1
end do

ydaymean=dim_avg_n(dailyMYTs,0)

printVarSummary(ydaymean)

;*********************get daily std ydaystd


ydaystd=dim_stddev_n(dailyMYTs,0)

printVarSummary(ydaystd)


;*************************get daily anomaly

dailyMYAnom=new((/38,62/),"double")

j=0
do i=0,2355,62
dailyMYAnom(j,:)=AAvg_inv(i:i+61)-ydaymean
j=j+1
end do

printVarSummary(dailyMYAnom)

print(dailyMYAnom(24,61))

dailyAnom=ndtooned(dailyMYAnom)

;print(dailyAnom(0))
;print(dailyAnom(55))
;print(dailyAnom(685))
;print(dailyAnom(1050))
;print(dailyAnom(2355))

;****************************get daily standard normal anomaly


dailyMYstdNAnom=new((/38,62/),"double")

j=0
do i=0,2355,62
dailyMYstdNAnom(j,:)=dailyAnom(i:i+61)/ydaystd
j=j+1
end do

dailyStdNAnom=ndtooned(dailyMYstdNAnom)

;print(dailyStdNAnom(0))
;print(dailyStdNAnom(55))
;print(dailyStdNAnom(685))
;print(dailyStdNAnom(1050))
;print(dailyStdNAnom(2355))


;****************get number of days

 print(num(dailyStdNAnom.gt.1.0))
 print(num(dailyStdNAnom.gt.0.0))

;*************get extreme days and get no of foggy stations for them

noStations=asciiread("foggyStations.txt",2139,"integer") 
dates=asciiread("dates.txt",2139,"string")

moreThan13Day=0
positiveAnomDay=0
oneSigmaAnomDay=0
do i=0,2138
    if(noStations(i) .gt. 13)then
      moreThan13Day=moreThan13Day+1
   if(dailyStdNAnom(i).gt.0) then
       positiveAnomDay=positiveAnomDay+1
     
           if(dailyStdNAnom(i).gt.1) then
            oneSigmaAnomDay=oneSigmaAnomDay+1
           end if
     end if
  
   end if
end do
print(moreThan13Day)
print(oneSigmaAnomDay)
print(positiveAnomDay)


dateListMT13=new(moreThan13Day,"string")
dateListPosAnom=new(positiveAnomDay,"string")
dateList1SigmaAnom=new(oneSigmaAnomDay,"string")
moreThan13Day=0
positiveAnomDay=0
oneSigmaAnomDay=0


do i=0,2138
    if(noStations(i) .gt. 13)then
        dateListMT13(moreThan13Day)=dates(i)
      moreThan13Day=moreThan13Day+1
   if(dailyStdNAnom(i).gt.0) then
       dateListPosAnom(positiveAnomDay)=dates(i)
       positiveAnomDay=positiveAnomDay+1
     
           if(dailyStdNAnom(i).gt.1) then
            dateList1SigmaAnom(oneSigmaAnomDay)=dates(i)
            oneSigmaAnomDay=oneSigmaAnomDay+1
           end if
     end if
  
   end if
end do



asciiwrite ("moreThan13_00Z.txt" , dateListMT13)
asciiwrite ("PositivemoreThan13_00Z.txt" , dateListPosAnom)
asciiwrite ("OneSigmamoreThan13_00Z.txt" , dateList1SigmaAnom)


;;;;;;;;plots

wks = gsn_open_wks("png" ,"StdNAnomPAInversion_00Z")

 
 res = True
 ;res@tiMainString     = no_of_days+" Fog Days  00Z for "+ext(p)          ; add title
 res@xyMarkLineModes   = "Markers"                ; choose which have markers
 res@xyMarkers         =  16                      ; choose type of marker  
 res@xyMarkerColor     = "red"                    ; Marker color
 res@xyMarkerSizeF     = 0.003                     ; Marker size (default 0.01)
 res@gsnYRefLine           = 13.0             ; create a reference line  
 res@gsnXRefLine           = 0.0             ; create a reference line  
  ;res@trYMinF  = -1                  ; min value on y-axis
  ;res@trYMaxF  =  1                 ; max value on y-axis.0
  ;res@trXMinF  = -10                   ; min value on X-axis
  ;res@trXMaxF  =  10                   ; max value on X-axis
  res@tiXAxisString = "Standard Normal Anomaly of Point Averaged Inversion 00Z"  ; axis string
  res@tiYAxisString = "All Stations"  ; axis string
 polyres                  = True
  polyres@gsLineThicknessF = 3.0

res                  = True    
;printVarSummary(AllnoStations)
plot = gsn_csm_xy(wks,dailyStdNAnom(0:2138),noStations(0:2138),res)

asciiwrite("Z00InvActual.txt",AAvg_inv)
asciiwrite("Anom00ZInv.txt",dailyAnom)
asciiwrite("NormAnom00ZInv.txt",dailyStdNAnom)


end
