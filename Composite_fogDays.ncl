begin

;;;;;;;; input files

fin500=addfile("/home/iitm/Documents/Data/ERA-1.5/ERA500hPa-00UTC-1.5deg-dec-jan-1979-2016.nc","r")
fin2mT=addfile("/home/iitm/Documents/Data/ERA-1.5/ERA_u10v10t2mmsl-00UTC-1.5deg-dec-jan-1979-2016.nc","r")

;;;;;;;;; Read Variables
z500_old=fin500->z
t500_old=fin500->t
u500=fin500->u
v500=fin500->v
t2m_old=fin2mT->t2m
u10=fin2mT->u10
v10=fin2mT->v10
slp_old=fin2mT->msl

;;;;;;; Convert to appropriate units
z500=z500_old/9.81
t500=t500_old-273.1
t2m=t2m_old-273.1
slp=slp_old/100.0

copy_VarMeta(z500_old,z500)
copy_VarMeta(t500_old,t500)
copy_VarMeta(t2m_old,t2m)
copy_VarMeta(slp_old,slp)

units=z500&time@units


printVarSummary(z500)
printVarSummary(t500)
printVarSummary(u500)
printVarSummary(v500)
printVarSummary(u10)
printVarSummary(v10)
printVarSummary(t2m)
printVarSummary(slp)

;;;;;;;;; read Dates to make composites
Dates=asciiread("fogDays_105.txt",-1,"string")
;print(Dates)
delim="-"              ; deliminator can be "," , "-" or " " etc
year=stringtointeger(str_get_field(Dates,1, delim))
;print(year)
month=stringtointeger(str_get_field(Dates,2, delim))
;print(month)
day=stringtointeger(str_get_field(Dates,3, delim))
;print(day)


;;;;;;;;; Define variables to hold values before making composites
testz500=new((/dimsizes(Dates),dimsizes(z500(0,0,:,0)),dimsizes(z500(0,0,0,:))/),typeof(z500))
testt500=new((/dimsizes(Dates),dimsizes(t500(0,0,:,0)),dimsizes(t500(0,0,0,:))/),typeof(t500))
testu500=new((/dimsizes(Dates),dimsizes(u500(0,0,:,0)),dimsizes(u500(0,0,0,:))/),typeof(u500))
testv500=new((/dimsizes(Dates),dimsizes(v500(0,0,:,0)),dimsizes(v500(0,0,0,:))/),typeof(v500))
testu10=new((/dimsizes(Dates),dimsizes(u10(0,:,0)),dimsizes(u10(0,0,:))/),typeof(u10))
testv10=new((/dimsizes(Dates),dimsizes(v10(0,:,0)),dimsizes(v10(0,0,:))/),typeof(v10))
testt2m=new((/dimsizes(Dates),dimsizes(t2m(0,:,0)),dimsizes(t2m(0,0,:))/),typeof(t2m))
testslp=new((/dimsizes(Dates),dimsizes(slp(0,:,0)),dimsizes(slp(0,0,:))/),typeof(slp))

;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(Dates)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),00,00,00,units,0)
	testz500(i,:,:)=z500({JTime},0,:,:)
	testt500(i,:,:)=t500({JTime},0,:,:)
	testu500(i,:,:)=u500({JTime},0,:,:)
	testv500(i,:,:)=v500({JTime},0,:,:)
	testu10(i,:,:)=u10({JTime},:,:)
	testv10(i,:,:)=v10({JTime},:,:)
	testt2m(i,:,:)=t2m({JTime},:,:)
	testslp(i,:,:)=slp({JTime},:,:)

end do


;;;;;;;;; Average over time to get composite values
comp_z500=dim_avg_n_Wrap(testz500,0)
comp_t500=dim_avg_n_Wrap(testt500,0)
comp_u500=dim_avg_n_Wrap(testu500,0)
comp_v500=dim_avg_n_Wrap(testv500,0)
comp_u10=dim_avg_n_Wrap(testu10,0)
comp_v10=dim_avg_n_Wrap(testv10,0)
comp_t2m=dim_avg_n_Wrap(testt2m,0)
comp_slp=dim_avg_n_Wrap(testslp,0)

comp_wind_speed=wind_speed(comp_u500,comp_v500)


wks = gsn_open_wks("eps","Composite500Z_T_SLP")         ; send graphics to PNG file


;;;;;;;;;;; resources for 500Z and 500T
  res = True
  res@gsnDraw      =  False                   ; do not draw the plot
  res@gsnFrame     =  False                   ; do not advance the frame
    res@mpFillOn = False
  res@mpCenterLonF = 80
  res@mpOutlineOn = True                            ; turn the map outline on
   res@mpGeophysicalLineColor = "white"
   ;res@mpGeophysicalLineThicknessF = 2.5
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
  res@cnFillPalette   = "precip3_16lev";"BlueRed";"BlueDarkRed18"
  res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  res@cnMinLevelValF  = -39.0                    ; set the minimum contour level
  res@cnMaxLevelValF  = -3.0                    ; set the maximum contour level
  res@cnLevelSpacingF = 3.0                     ; set the interval between contours
  res@gsnLeftString = "a)"                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
 ; res@tiMainString     = "500hPa Geopotential Height (m) and Temperature(C)"          ; add title
    res@gsnCenterString = "500hPa Geopotential Height (m) and Temperature(C)"
  res@tiMainFontHeightF = 0.015
  res@lbOrientation="Vertical"
plot1 = gsn_csm_contour_map(wks,comp_t500,res)    ; create and draw the temperature plot

   sres                      = True              ; set up a second resource list
  sres@gsnDraw              = False             ; do not draw the plot
  sres@gsnFrame             = False             ; do not advance the frame
  sres@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  sres@cnMinLevelValF  = 5100                    ; set the minimum contour level
  sres@cnMaxLevelValF  = 5900                    ; set the maximum contour level
  sres@cnLevelSpacingF = 50                     ; set the interval between contours
  sres@cnInfoLabelOn = False
  sres@gsnLeftString = ""                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  sres@gsnRightString = ""
 plot2 = gsn_csm_contour(wks,comp_z500,sres)    ; create and draw the temperature plot

overlay(plot1,plot2)
plot_500ZT=plot1

;;;;;;;;;;; resources for SLP
resSLP = True
   resSLP@gsnDraw      =  False                   ; do not draw the plot
  resSLP@gsnFrame     =  False                   ; do not advance the frame
   resSLP@mpFillOn = False
  resSLP@mpCenterLonF = 80
  resSLP@mpOutlineOn = True                            ; turn the map outline on
  ; resSLP@mpGeophysicalLineColor = "Grey"
   ;resSLP@mpGeophysicalLineThicknessF = 2.5
  resSLP@cnFillOn        = True                  ; color fill
  resSLP@cnLinesOn       = False                 ; do not draw contour lines
  resSLP@cnFillPalette   = "precip3_16lev";"BlueRed";"BlueDarkRed18"
  resSLP@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  resSLP@cnMinLevelValF  = 999.0                   ; set the minimum contour level
  resSLP@cnMaxLevelValF  = 1032.0                   ; set the maximum contour level
  resSLP@cnLevelSpacingF = 3.0                     ; set the interval between contours
  resSLP@gsnLeftString = "b)"                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  resSLP@gsnRightString = ""
  resSLP@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
  ;resSLP@tiMainString     = "Mean Sea Level PresSLPsure (hPa)"          ; add title
   resSLP@gsnCenterString = "Mean Sea Level PresSLPsure (hPa)" 
  resSLP@tiMainFontHeightF = 0.015
  resSLP@lbOrientation="Vertical"
plotSLP = gsn_csm_contour_map(wks,comp_slp,resSLP)    ; create and draw the temperature plot

;;;;;;;;;;;;;;;;;;;; 500 wind reswind500ources
gsn_define_colormap(wks,"precip3_16lev")             ; choose colormap
  reswind500 = True
  reswind500@gsnDraw      =  False                   ; do not draw the plot
  reswind500@gsnFrame     =  False                   ; do not advance the frame
  reswind500@mpFillOn = False
  reswind500@mpCenterLonF = 80
  reswind500@mpOutlineOn = True                            ; turn the map outline on
   reswind500@cnFillOn        = True                  ; color fill
  reswind500@cnLinesOn       = False                 ; do not draw contour lines
 ; reswind500@cnFillPalette        = colors
  reswind500@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  reswind500@cnMinLevelValF  = 10                    ; set the minimum contour level
  reswind500@cnMaxLevelValF  =35                   ; set the maximum contour level
  reswind500@cnLevelSpacingF = 5                     ; set the interval between contours
  reswind500@gsnLeftString = "c)"                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  reswind500@gsnRightString = ""
  reswind500@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
   reswind500@stArrowLengthF     = 0.005               ; default is dynamic
  ;reswind500@stLengthCheckCount = 5                    ; default is 35
  reswind500@stArrowStride      = 1
  reswind500@stLineStartStride  = 1                    ; default is 2
  reswind500@stMinArrowSpacingF = 0.03                 ; default is 0.0             
  reswind500@stStepSizeF        = 0.001                ; default is dynamic
   reswind500@stLineColor = "gray30"
  reswind500@stMinDistanceF     = 0.03                 ; distance between lines
  reswind500@stMinLineSpacingF  = 0.005                
  reswind500@gsnSpreadColors     = True                ; use full colormap
 ; reswind500@gsnSpreadColorStart = 2 
  ;reswind500@gsnSpreadColorEnd   = -3 
   reswind500@lbOrientation="Vertical"
  ;reswind500@tiMainString     = "500hPa Horizontal Winds m/s"          ; add title
   reswind500@gsnCenterString = "500hPa Horizontal Winds m/s"
  reswind500@tiMainFontHeightF = 0.015
plotWind500 = gsn_csm_streamline_contour_map_polar(wks,comp_u500,comp_v500,comp_wind_speed,reswind500)    ; create and draw the temperature plot

;;;;;;;;;;;;;;;;; Resources for 2m temp and wind 10m 
gsn_define_colormap(wks,"precip3_16lev")             ; choose colormap
  reswind10T2m = True
  reswind10T2m@gsnDraw      =  False                   ; do not draw the plot
  reswind10T2m@gsnFrame     =  False                   ; do not advance the frame
  reswind10T2m@mpFillOn = False
  reswind10T2m@mpCenterLonF = 80
  reswind10T2m@mpOutlineOn = True                            ; turn the map outline on
   reswind10T2m@cnFillOn        = True                  ; color fill
  reswind10T2m@cnLinesOn       = False                 ; do not draw contour lines
   reswind10T2m@mpGeophysicalLineColor = "white"
 ; reswind10T2m@cnFillPalette        = colors
  reswind10T2m@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  reswind10T2m@cnMinLevelValF  = -36                  ; set the minimum contour level
  reswind10T2m@cnMaxLevelValF  =24                   ; set the maximum contour level
  reswind10T2m@cnLevelSpacingF = 6                     ; set the interval between contours
  reswind10T2m@gsnLeftString = "d)"                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  reswind10T2m@gsnRightString = ""
  reswind10T2m@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
   reswind10T2m@stArrowLengthF     = 0.005               ; default is dynamic
  ;reswind10T2m@stLengthCheckCount = 5                    ; default is 35
  reswind10T2m@stArrowStride      = 1
  reswind10T2m@stLineStartStride  = 1                    ; default is 2
  reswind10T2m@stMinArrowSpacingF = 0.03                 ; default is 0.0             
  reswind10T2m@stStepSizeF        = 0.001                ; default is dynamic
  ; reswind10T2m@stLineColor = "gray30"
  reswind10T2m@stMinDistanceF     = 0.03                 ; distance between lines
  reswind10T2m@stMinLineSpacingF  = 0.005                
  reswind10T2m@gsnSpreadColors     = True                ; use full colormap
 ; reswind10T2m@gsnSpreadColorStart = 2 
  ;reswind10T2m@gsnSpreadColorEnd   = -3 
  reswind10T2m@lbOrientation="Vertical"
  ;reswind10T2m@tiMainString     = "2m Tempeature (C) Surface Winds (m/s)"          ; add title
   reswind10T2m@gsnCenterString = "2m Tempeature (C) Surface Winds (m/s)"  
  reswind10T2m@tiMainFontHeightF = 0.015
plotwind10T2m = gsn_csm_streamline_contour_map_polar(wks,comp_u10,comp_v10,comp_t2m,reswind10T2m)    ; create and draw the temperature plot

 ;drawNDCGrid(wks) 


;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots
  gsn_panel(wks,(/plot_500ZT,plotSLP,plotWind500,plotwind10T2m/),(/2,2/),resP)          ; now draw as one plot

end
