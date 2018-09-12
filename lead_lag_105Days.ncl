begin

;;;;;;;; input files

fin500=addfile("/home/iitm/Documents/Data/ERA-1.5/ERAAnom500hPa-00UTC-1.5deg-dec-jan-1979-2016.nc","r")

z500_old=fin500->z
z500=z500_old/9.81
copy_VarMeta(z500_old,z500)

units=z500&time@units
print(units)


printVarSummary(z500)



Dates=asciiread("fogDays_105.txt",-1,"string")
;print(Dates)
delim="-"              ; deliminator can be "," , "-" or " " etc
year=stringtointeger(str_get_field(Dates,1, delim))
;print(year)
month=stringtointeger(str_get_field(Dates,2, delim))
;print(month)
day=stringtointeger(str_get_field(Dates,3, delim))
;print(day)


testz500=new((/6,dimsizes(Dates),dimsizes(z500(0,:,0,0)),dimsizes(z500(0,0,:,0)),dimsizes(z500(0,0,0,:))/),typeof(z500))
printVarSummary(testz500)

timesteps=(/-7,-5,-3,-1,1,3/)


do i=0,dimsizes(Dates)-1
JTime=cd_inv_calendar(year(i),month(i),day(i),00,00,00,units,0)
;print(year(i)+" "+month(i)+" "+day(i))

if((year(i).eq.1979 .and. month(i).eq.1 .and. day(i).le.7 ))then
else
do k=0,5
delta = timesteps(k)*24.0   ;;;;;;;  ; Convert delta to hours, since our calendar units are hours
;print(JTime)
Time2=JTime+delta
testz500(k,i,0,:,:)=z500({Time2},0,:,:)
end do
end if
end do



printVarSummary(testz500)	

comp_z500=new((/6,dimsizes(z500(0,0,:,0)),dimsizes(z500(0,0,0,:))/),typeof(z500))


wks = gsn_open_wks("eps","Lead_lag_FogDays105")         ; send graphics to PNG file
  plot=new(6,"graphic")

  res = True
  res@gsnDraw      =  False                   ; do not draw the plot
  res@gsnFrame     =  False                   ; do not advance the frame
  ;res@mpFillOn = False
  res@mpCenterLonF = 80
  res@mpOutlineOn = True  
  res@gsnLeftString = ""                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""
  res@gsnPolar   = "NH"   
  res@gsnContourNegLineDashPattern = 2     
 ; res@mpGridAndLimbOn  = "False"        ; turn off lat/lon lines

 ; res@tmXBLabelsOn   = False            ; no labels or tick marks
 ; res@tmYLLabelsOn   = False
 ; res@gsnTickMarksOn = False
 ; res@tmXBOn         = False
 ; res@tmXTOn         = False 
 ; res@tmYLOn         = False 
 ; res@tmYROn         = False        

  res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  res@cnMinLevelValF  = -60                  ; set the minimum contour level
  res@cnMaxLevelValF  =60                   ; set the maximum contour level
  res@cnLevelSpacingF = 10                     ; set the interval between contours    
   ;res@cnLevelSelectionMode = "ExplicitLevels" ; use explicit levels
  ; res@cnLevels = (/-50,-40,-30,-20,-10,10,20,30,40,50/)
  res@gsnContourZeroLineThicknessF = 0.0
  res@cnInfoLabelOn = False
 ; res@cnExplicitLineLabelsOn = True
   res@cnLineLabelInterval        = 1             ; default = 2
  res@cnLineLabelPlacementMode   = "constant"    ; choose constant label method
  ;res@cnLineLabelStrings = (/-50,-30,-10,10,30,50/)

do k=0,5
 comp_z500(k,:,:)=dim_avg_n_Wrap(testz500(k,:,0,:,:),0)
 res@gsnCenterString = "Lag "+sprinti("%+0.1i", timesteps(k))
 plot(k) = gsn_csm_contour_map(wks,comp_z500(k,:,:),res)    ; create the  plot
 plot(k) = ColorNegDashZeroPosContour(plot(k),"red","magenta","blue")
end do

;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots
  gsn_panel(wks,plot,(/3,2/),resP)          ; now draw as one plot

end
