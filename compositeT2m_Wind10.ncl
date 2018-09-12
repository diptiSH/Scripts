begin

fin2mT=addfile("/home/iitm/Documents/Data/ERA-1.5/ERA_u10v10t2mmsl-00UTC-1.5deg-dec-jan-1979-2016.nc","r")



t2m_old=fin2mT->t2m
u10=fin2mT->u10
v10=fin2mT->v10

t2m=t2m_old-273.1


copy_VarMeta(t2m_old,t2m)

units=t2m&time@units


printVarSummary(u10)
printVarSummary(v10)

printVarSummary(t2m)


Dates=asciiread("fogDays_105.txt",-1,"string")
;print(Dates)
delim="-"              ; deliminator can be "," , "-" or " " etc
year=stringtointeger(str_get_field(Dates,1, delim))
;print(year)
month=stringtointeger(str_get_field(Dates,2, delim))
;print(month)
day=stringtointeger(str_get_field(Dates,3, delim))
;print(day)


testu10=new((/dimsizes(Dates),dimsizes(u10(0,:,0)),dimsizes(u10(0,0,:))/),typeof(u10))
testv10=new((/dimsizes(Dates),dimsizes(v10(0,:,0)),dimsizes(v10(0,0,:))/),typeof(v10))
testt2m=new((/dimsizes(Dates),dimsizes(t2m(0,:,0)),dimsizes(t2m(0,0,:))/),typeof(t2m))
printVarSummary(testu10)

do i=0,dimsizes(Dates)-1

JTime=cd_inv_calendar(year(i),month(i),day(i),00,00,00,units,0)
;print(JTime)
testu10(i,:,:)=u10({JTime},:,:)
testv10(i,:,:)=v10({JTime},:,:)
testt2m(i,:,:)=t2m({JTime},:,:)
;print(test(i,:,:))

end do

printVarSummary(testu10)	

comp_u10=dim_avg_n_Wrap(testu10,0)
comp_v10=dim_avg_n_Wrap(testv10,0)
comp_t2m=dim_avg_n_Wrap(testt2m,0)
printVarSummary(comp_u10)

colors = (/"white","royal blue","green","Yellow","brown","red","pink"/)



wks = gsn_open_wks("eps","Compositet2m_10mWind")         ; send graphics to PNG file
gsn_define_colormap(wks,"MPL_rainbow")             ; choose colormap
  res = True
  res@mpFillOn = False
  res@mpCenterLonF = 80
  res@mpOutlineOn = True                            ; turn the map outline on
   res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
   res@mpGeophysicalLineColor = "White"
 ; res@cnFillPalette        = colors
  res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  res@cnMinLevelValF  = -36                  ; set the minimum contour level
  res@cnMaxLevelValF  =24                   ; set the maximum contour level
  res@cnLevelSpacingF = 6                     ; set the interval between contours
  res@gsnLeftString = ""                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
   res@stArrowLengthF     = 0.005               ; default is dynamic
  ;res@stLengthCheckCount = 5                    ; default is 35
  res@stArrowStride      = 1
  res@stLineStartStride  = 1                    ; default is 2
  res@stMinArrowSpacingF = 0.03                 ; default is 0.0             
  res@stStepSizeF        = 0.001                ; default is dynamic
  ; res@stLineColor = "gray30"
  res@stMinDistanceF     = 0.03                 ; distance between lines
  res@stMinLineSpacingF  = 0.005                
  res@gsnSpreadColors     = True                ; use full colormap
 ; res@gsnSpreadColorStart = 2 
  ;res@gsnSpreadColorEnd   = -3 
   
  res@tiMainString     = "2m Tempeature (C) Surface Winds (m/s)"          ; add title
plot1 = gsn_csm_streamline_contour_map_polar(wks,comp_u10,comp_v10,comp_t2m,res)    ; create and draw the temperature plot

  

end
