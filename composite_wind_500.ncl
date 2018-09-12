begin

fin500=addfile("/home/iitm/Documents/Data/ERA-1.5/ERADAILY-1.5deg-500hPa-Dec-Jan-1979-2016.nc","r")
;fin=addfile("","r")
;fin=addfile("","r")
;fin=addfile("","r")

u500=fin500->u
v500=fin500->v



units=u500&time@units


printVarSummary(u500)
printVarSummary(v500)

Dates=asciiread("fogDays_105.txt",-1,"string")
;print(Dates)
delim="-"              ; deliminator can be "," , "-" or " " etc
year=stringtointeger(str_get_field(Dates,1, delim))
;print(year)
month=stringtointeger(str_get_field(Dates,2, delim))
;print(month)
day=stringtointeger(str_get_field(Dates,3, delim))
;print(day)


testu500=new((/dimsizes(Dates),dimsizes(u500(0,:,0)),dimsizes(u500(0,0,:))/),typeof(u500))
testv500=new((/dimsizes(Dates),dimsizes(v500(0,:,0)),dimsizes(v500(0,0,:))/),typeof(v500))
printVarSummary(testu500)

do i=0,dimsizes(Dates)-1

JTime=cd_inv_calendar(year(i),month(i),day(i),00,00,00,units,0)
;print(JTime)
testu500(i,:,:)=u500({JTime},:,:)
testv500(i,:,:)=v500({JTime},:,:)
;print(test(i,:,:))

end do

printVarSummary(testu500)	

comp_u500=dim_avg_n_Wrap(testu500,0)
comp_v500=dim_avg_n_Wrap(testv500,0)
printVarSummary(comp_u500)

colors = (/"white","royal blue","green","Yellow","brown","red","pink"/)

comp_wind_speed=wind_speed(comp_u500,comp_v500)

wks = gsn_open_wks("eps","Composite500_winds")         ; send graphics to PNG file
gsn_define_colormap(wks,"precip3_16lev")             ; choose colormap
  res = True
  res@mpFillOn = False
  res@mpCenterLonF = 80
  res@mpOutlineOn = True                            ; turn the map outline on
   res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
 ; res@cnFillPalette        = colors
  res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  res@cnMinLevelValF  = 10                    ; set the minimum contour level
  res@cnMaxLevelValF  =35                   ; set the maximum contour level
  res@cnLevelSpacingF = 5                     ; set the interval between contours
  res@gsnLeftString = ""                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
   res@stArrowLengthF     = 0.005               ; default is dynamic
  ;res@stLengthCheckCount = 5                    ; default is 35
  res@stArrowStride      = 1
  res@stLineStartStride  = 1                    ; default is 2
  res@stMinArrowSpacingF = 0.03                 ; default is 0.0             
  res@stStepSizeF        = 0.001                ; default is dynamic
   res@stLineColor = "gray30"
  res@stMinDistanceF     = 0.03                 ; distance between lines
  res@stMinLineSpacingF  = 0.005                
  res@gsnSpreadColors     = True                ; use full colormap
 ; res@gsnSpreadColorStart = 2 
  ;res@gsnSpreadColorEnd   = -3 
   
  res@tiMainString     = "500hPa Horizontal Winds m/s"          ; add title
plot1 = gsn_csm_streamline_contour_map_polar(wks,comp_u500,comp_v500,comp_wind_speed,res)    ; create and draw the temperature plot

  

end
