begin

finSLP=addfile("/home/iitm/Documents/Data/ERA-1.5/ERADAILY-1.5deg-SLP-Dec-Jan-1979-2016.nc","r")
;fin=addfile("","r")
;fin=addfile("","r")
;fin=addfile("","r")

slp_old=finSLP->msl



slp=slp_old/100.0

copy_VarMeta(slp_old,slp)


units=slp&time@units


printVarSummary(slp)


Dates=asciiread("fogDays_105.txt",-1,"string")
;print(Dates)
delim="-"              ; deliminator can be "," , "-" or " " etc
year=stringtointeger(str_get_field(Dates,1, delim))
;print(year)
month=stringtointeger(str_get_field(Dates,2, delim))
;print(month)
day=stringtointeger(str_get_field(Dates,3, delim))
;print(day)


testslp=new((/dimsizes(Dates),dimsizes(slp(0,:,0)),dimsizes(slp(0,0,:))/),typeof(slp))

printVarSummary(testslp)

do i=0,dimsizes(Dates)-1

JTime=cd_inv_calendar(year(i),month(i),day(i),00,00,00,units,0)
;print(JTime)
testslp(i,:,:)=slp({JTime},:,:)
;print(test(i,:,:))

end do

printVarSummary(testslp)	

comp_slp=dim_avg_n_Wrap(testslp,0)

printVarSummary(comp_slp)


wks = gsn_open_wks("eps","CompositeSLP")         ; send graphics to PNG file

  res = True
   res@mpFillOn = False
  res@mpCenterLonF = 80
  res@mpOutlineOn = True                            ; turn the map outline on
  ; res@mpGeophysicalLineColor = "Grey"
   ;res@mpGeophysicalLineThicknessF = 2.5
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
  res@cnFillPalette   = "MPL_rainbow";"BlueRed";"BlueDarkRed18"
  res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  res@cnMinLevelValF  = 999.0                   ; set the minimum contour level
  res@cnMaxLevelValF  = 1032.0                   ; set the maximum contour level
  res@cnLevelSpacingF = 3.0                     ; set the interval between contours
  res@gsnLeftString = ""                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
  res@tiMainString     = "Mean Sea Level Pressure (hPa)"          ; add title
plot1 = gsn_csm_contour_map(wks,comp_slp,res)    ; create and draw the temperature plot

  
end
