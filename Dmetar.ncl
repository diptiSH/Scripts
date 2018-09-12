begin

fileName="DELHI.txt"
;---Read in file as array of strings so we can parse each line
  lines = asciiread(fileName,-1,"string")

;print(lines)

  delim = ","

printVarSummary(lines)

 StationNames  =           str_get_field(lines,1,delim)
 years         =  tointeger(str_get_field(lines,3,delim))
 months        =  tointeger(str_get_field(lines,4,delim))
 dates         =  tointeger(str_get_field(lines,5,delim))
 hrs           =  tointeger(str_get_field(lines,6,delim))
 wind           =  tofloat(str_get_field(lines,8,delim))
 visibilities  =  tointeger(str_get_field(lines,10,delim))
  dTemp         =  tofloat(str_get_field(lines,25,delim))
  ;wTemp         =  tofloat(str_get_field(lines,26,delim))
 dewTemp       =  tofloat(str_get_field(lines,27,delim))



vis=new((/35,2,31/),"integer")
dryT=new((/35,2,31/),"float")
dewT=new((/35,2,31/),"float")
rh=new((/35,2,31/),"float")
win=new((/35,2,31/),"float")

cnt=0
do yr=1979,2013
    do mn=1,2
       if (mn.eq.2) then
          mon=12
       else
          mon=1
       end if
           do date=1,31
                 do i=0,dimsizes(lines)-1
                     if(years(i).eq.yr .and. months(i).eq.mon .and. dates(i).eq.date .and. hrs(i).eq.3) then
                       
                       dewT(yr-1979,mn-1,date-1)=dewTemp(i)
                             if(.not.ismissing(dTemp(i)) .and. .not.ismissing(dewTemp(i)) .and. .not.ismissing(wind(i))) then
                                rh(yr-1979,mn-1,date-1)=100*(exp((17.625*dewTemp(i))/(243.04+dewTemp(i)))/exp((17.625*dTemp(i))/(243.04+dTemp(i))))
                                vis(yr-1979,mn-1,date-1)=visibilities(i)
                               dryT(yr-1979,mn-1,date-1)=dTemp(i)
                                win(yr-1979,mn-1,date-1)=wind(i)
                                cnt=cnt+1
                             end if
                     end if
                 end do
           end do
     end do
end do


;print(rh)



;*********************get daily mean ydaymean


mdryT=dim_avg_n(dryT,0)
mdewT=dim_avg_n(dewT,0)
mrh=dim_avg_n(rh,0)
mwin=dim_avg_n(win,0)

printVarSummary(mdryT)


;*************************get daily anomaly

AdryT=new((/35,2,31/),"float")
AdewT=new((/35,2,31/),"float")
Arh=new((/35,2,31/),"float")
Awin=new((/35,2,31/),"float")
outString=new(cnt,"string")

cnt=0
do yr=0,34
    do mn=0,1
         do date=0,30
                          if(.not.ismissing(dryT(yr,mn,date)) .and. .not.ismissing(dewT(yr,mn,date)) .and. .not.ismissing(win(yr,mn,date))) then
                           AdryT(yr,mn,date)=dryT(yr,mn,date)-mdryT(mn,date)
                           AdewT(yr,mn,date)=dewT(yr,mn,date)-mdewT(mn,date)
                           Arh(yr,mn,date)=rh(yr,mn,date)-mrh(mn,date)
                           Awin(yr,mn,date)=win(yr,mn,date)-mwin(mn,date)    
                           outString(cnt)=tostring(yr+1979)+"-"+tostring(mn+1)+"-"+tostring(date+1)+","+tostring(dryT(yr,mn,date))+","+tostring(AdryT(yr,mn,date))+","+tostring(dewT(yr,mn,date))+","+tostring(AdewT(yr,mn,date))+","+tostring(rh(yr,mn,date))+","+tostring(Arh(yr,mn,date))+","+tostring(win(yr,mn,date))+","+tostring(Awin(yr,mn,date))+","+vis(yr,mn,date)                            
                            cnt=cnt+1
                         end if
           end do
     end do
end do

asciiwrite("out.txt",outString)

;;;;;;;;plots

wks = gsn_open_wks("png" ,"vis_vs_temp")
wks2 = gsn_open_wks("png" ,"vis_vs_rh")
wks3 = gsn_open_wks("png" ,"vis_vs_win")

 
 res = True

 res@xyMarkLineModes   = "Markers"                ; choose which have markers
 res@xyMarkers         =  16                      ; choose type of marker  
 res@xyMarkerColor     = "red"                    ; Marker color
 res@xyMarkerSizeF     = 0.003                     ; Marker size (default 0.01)
 res@gsnYRefLine           = 9.0             ; create a reference line  
 res@gsnXRefLine           = 0.0             ; create a reference line  
  ;res@trYMinF  = -1                  ; min value on y-axis
  ;res@trYMaxF  =  1                 ; max value on y-axis.0
  ;res@trXMinF  = -9                   ; min value on X-axis
  ;res@trXMaxF  =  9                   ; max value on X-axis
  res@tiXAxisString = "visibility"  ; axis string
  res@tiYAxisString = "temp"  ; axis string
 polyres                  = True
  polyres@gsLineThicknessF = 3.0

res                  = True    
;printVarSummary(AllnoStations)
vis2=ndtooned(vis)
rh2=ndtooned(rh)
win2=ndtooned(win)
dryT2=ndtooned(dryT)
plot = gsn_csm_xy(wks,vis2,dryT2,res)
res@tiYAxisString = "rh"  ; axis string
plot2 = gsn_csm_xy(wks2,vis2,rh2,res)
res@tiYAxisString = "wind"  ; axis string
plot3 = gsn_csm_xy(wks3,vis2,win2,res)

end
