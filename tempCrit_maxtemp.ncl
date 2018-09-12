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

;print(avgMaxTemps)

fogyyStations=dim_sum_n(AllfogIndices,0)
print(fogyyStations)

maxTempTS=ndtooned(avgMaxTemps)
fogTS=ndtooned(fogyyStations)
wks = gsn_open_wks("png" ,"maxTemp_foggyStations")

 
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
  res@tiXAxisString = "Avg max temp"  ; axis string
  res@tiYAxisString = "All Stations"  ; axis string
 polyres                  = True
  polyres@gsLineThicknessF = 3.0
 
;printVarSummary(AllnoStations)
plot = gsn_csm_xy(wks,maxTempTS(0:2138),fogTS(0:2138),res)


end
