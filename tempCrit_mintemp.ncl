begin 

files=asciiread("flist.txt",-1,"string")

print(files)

AllfogIndices=new((/26,35,2,31/),"integer")
AllmaxTemps=new((/26,35,2,31/),"float")
AllminTemps=new((/26,35,2,31/),"float")

do f=0,dimsizes(files)-1

filename=str_concat(files(f))

lines=asciiread(filename,-1,"string")
delim=","

printVarSummary(lines)

years=tointeger(str_get_field(lines,1,delim))
months=tointeger(str_get_field(lines,2,delim))
dates=tointeger(str_get_field(lines,3,delim))
fogIndices=tointeger(str_get_field(lines,4,delim))
maxTemps=tofloat(str_get_field(lines,5,delim))
minTemps=tofloat(str_get_field(lines,6,delim))

do i=0,dimsizes(lines)-1
do yr=1979,2013
  do mn=1,2
     if (mn.eq.2)then
      mon=12
      else
       mon=1
     end if
     do day=1,31
          if(years(i).eq.yr .and. months(i).eq.mon .and. dates(i).eq.day) then
           AllfogIndices(f,yr-1979,mn-1,day-1)=fogIndices(i)
           AllmaxTemps(f,yr-1979,mn-1,day-1)=maxTemps(i)
           AllminTemps(f,yr-1979,mn-1,day-1)=minTemps(i)
          end if
     end do
  end do
end do
end do
end do

AllmaxTemps@_FillValue = 999.9  
AllminTemps@_FillValue = 999.9  
AllfogIndices@_FillValue = 9  

printVarSummary(AllmaxTemps);(0,:,:,:))
;*********************************** get avg temp
avgMaxTemps=dim_avg_n(AllmaxTemps,0)
avgMinTemps=dim_avg_n(AllminTemps,0)

printVarSummary(avgMaxTemps)

minTempTS=ndtooned(avgMinTemps)
maxTempTS=ndtooned(avgMaxTemps)

asciiwrite("Avg_maxTemp_actual.txt",maxTempTS(0:2138))
asciiwrite("Avg_minTemp_actual.txt",minTempTS(0:2138))

;print(avgMaxTemps)

fogyyStations=dim_sum_n(AllfogIndices,0)
print(fogyyStations)

minTempTS=ndtooned(avgMinTemps)
fogTS=ndtooned(fogyyStations)

;***********************get daily climatology
avgDMaxTemps=dim_avg_n(AllmaxTemps,1)
avgDMinTemps=dim_avg_n(AllminTemps,1)

printVarSummary(avgDMaxTemps)


;******************get daily sdt dev
stdDMaxTemps=dim_stddev_n(AllmaxTemps,1)
stdDMinTemps=dim_stddev_n(AllminTemps,1)

printVarSummary(stdDMaxTemps)

;***********************get daily anomaly
anomDMaxTemps=AllmaxTemps
anomDMinTemps=AllminTemps
do yr=0,34
anomDMaxTemps(:,yr,:,:)=AllmaxTemps(:,yr,:,:)-avgDMaxTemps
anomDMinTemps(:,yr,:,:)=AllminTemps(:,yr,:,:)-avgDMinTemps
end do
;**********************************daily area average anomaly
AnomMaxTemps=dim_avg_n(anomDMaxTemps,0)
AnomMinTemps=dim_avg_n(anomDMinTemps,0)

printVarSummary(AnomMaxTemps)

minAnomTempTS=ndtooned(AnomMinTemps)
maxAnomTempTS=ndtooned(AnomMaxTemps)

asciiwrite("Avg_AnommaxTemp_actual.txt",maxAnomTempTS(0:2138))
asciiwrite("Avg_AnomminTemp_actual.txt",minAnomTempTS(0:2138))

;***********************get daily normalized anomaly
NormanomDMaxTemps=AllmaxTemps
NormanomDMinTemps=AllminTemps
do yr=0,34
NormanomDMaxTemps(:,yr,:,:)=anomDMaxTemps(:,yr,:,:)/stdDMaxTemps
NormanomDMinTemps(:,yr,:,:)=anomDMinTemps(:,yr,:,:)/stdDMinTemps
end do

;**********************************daily area average  normalized anomaly
NormAnomMaxTemps=dim_avg_n(NormanomDMaxTemps,0)
NormAnomMinTemps=dim_avg_n(NormanomDMinTemps,0)

printVarSummary(NormAnomMaxTemps)

NormminAnomTempTS=ndtooned(NormAnomMinTemps)
NormmaxAnomTempTS=ndtooned(NormAnomMaxTemps)

asciiwrite("Avg_NormAnommaxTemp_actual.txt",NormmaxAnomTempTS(0:2138))
asciiwrite("Avg_NormAnomminTemp_actual.txt",NormminAnomTempTS(0:2138))


wks = gsn_open_wks("png" ,"minTemp_foggyStations")

 res = True
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
  res@tiXAxisString = "Avg min temp"  ; axis string
  res@tiYAxisString = "All Stations"  ; axis string
 polyres                  = True
  polyres@gsLineThicknessF = 3.0
 
;printVarSummary(AllnoStations)
plot = gsn_csm_xy(wks,minTempTS(0:2138),fogTS(0:2138),res)

wks2 = gsn_open_wks("png" ,"maxTemp_foggyStations")
 res@tiXAxisString = "Avg max temp"  ; axis string
plot2 = gsn_csm_xy(wks2,maxTempTS(0:2138),fogTS(0:2138),res)

wks3 = gsn_open_wks("png" ,"AnommaxTemp_foggyStations")
 res@tiXAxisString = "Avg anomaly max temp"  ; axis string
plot3 = gsn_csm_xy(wks3,maxAnomTempTS(0:2138),fogTS(0:2138),res)

wks4 = gsn_open_wks("png" ,"AnomminTemp_foggyStations")
 res@tiXAxisString = "Avg anomaly min temp"  ; axis string
plot4 = gsn_csm_xy(wks4,minAnomTempTS(0:2138),fogTS(0:2138),res)


wks5 = gsn_open_wks("png" ,"NormAnommaxTemp_foggyStations")
 res@tiXAxisString = "Avg normalized anomaly max temp"  ; axis string
plot5 = gsn_csm_xy(wks5,NormmaxAnomTempTS(0:2138),fogTS(0:2138),res)

wks6 = gsn_open_wks("png" ,"NormAnomminTemp_foggyStations")
 res@tiXAxisString = "Avg anomaly normalized  min temp"  ; axis string
plot6 = gsn_csm_xy(wks6,NormminAnomTempTS(0:2138),fogTS(0:2138),res)


end
