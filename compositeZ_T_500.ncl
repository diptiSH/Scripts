begin

fin500=addfile("/home/iitm/Documents/Data/ERA-1.5/ERADAILY-1.5deg-500hPa-Dec-Jan-1979-2016.nc","r")
;fin=addfile("","r")
;fin=addfile("","r")
;fin=addfile("","r")

z500_old=fin500->z
t500_old=fin500->t

z500=z500_old/9.81
t500=t500_old-273.1

copy_VarMeta(z500_old,z500)
copy_VarMeta(t500_old,t500)

units=z500&time@units


printVarSummary(z500)
printVarSummary(t500)

Dates=asciiread("fogDays_105.txt",-1,"string")
;print(Dates)
delim="-"              ; deliminator can be "," , "-" or " " etc
year=stringtointeger(str_get_field(Dates,1, delim))
;print(year)
month=stringtointeger(str_get_field(Dates,2, delim))
;print(month)
day=stringtointeger(str_get_field(Dates,3, delim))
;print(day)


testz500=new((/dimsizes(Dates),dimsizes(z500(0,:,0)),dimsizes(z500(0,0,:))/),typeof(z500))
testt500=new((/dimsizes(Dates),dimsizes(t500(0,:,0)),dimsizes(t500(0,0,:))/),typeof(t500))
printVarSummary(testz500)

do i=0,dimsizes(Dates)-1

JTime=cd_inv_calendar(year(i),month(i),day(i),00,00,00,units,0)
;print(JTime)
testz500(i,:,:)=z500({JTime},:,:)
testt500(i,:,:)=t500({JTime},:,:)
;print(test(i,:,:))

end do

printVarSummary(testz500)	

comp_z500=dim_avg_n_Wrap(testz500,0)
comp_t500=dim_avg_n_Wrap(testt500,0)
printVarSummary(comp_z500)


wks = gsn_open_wks("eps","Composite500Z_T")         ; send graphics to PNG file

  res = True
  res@gsnDraw      =  False                   ; do not draw the plot
  res@gsnFrame     =  False                   ; do not advance the frame
    res@mpFillOn = False
  res@mpCenterLonF = 80
  res@mpOutlineOn = True                            ; turn the map outline on
   res@mpGeophysicalLineColor = "White"
   ;res@mpGeophysicalLineThicknessF = 2.5
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
  res@cnFillPalette   = "MPL_rainbow";"BlueRed";"BlueDarkRed18"
  res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  res@cnMinLevelValF  = -39.0                    ; set the minimum contour level
  res@cnMaxLevelValF  = -3.0                    ; set the maximum contour level
  res@cnLevelSpacingF = 3.0                     ; set the interval between contours
  res@gsnLeftString = ""                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
  res@tiMainString     = "500hPa Geopotential Height (m) and Temperature(C)"          ; add title
plot1 = gsn_csm_contour_map(wks,comp_t500,res)    ; create and draw the temperature plot

   sres                      = True              ; set up a second resource list
  sres@gsnDraw              = False             ; do not draw the plot
  sres@gsnFrame             = False             ; do not advance the frame
  sres@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  sres@cnMinLevelValF  = 5100                    ; set the minimum contour level
  sres@cnMaxLevelValF  = 5900                    ; set the maximum contour level
  sres@cnLevelSpacingF = 50                     ; set the interval between contours
  sres@gsnLeftString = ""                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  sres@gsnRightString = ""
 plot2 = gsn_csm_contour(wks,comp_z500,sres)    ; create and draw the temperature plot

overlay(plot1,plot2)
 draw(plot1)                                  ; draw the temperature plot (with the U-wind plot overlaid)
  frame(wks)    

end
