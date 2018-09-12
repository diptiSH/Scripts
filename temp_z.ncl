begin

levs=(/"500hPa","700hPa","850hPa","950hPa"/)
low_vals=(/-3.2,-4.0,-5.0,-2.5/)
high_vals=(/3.2,4.0,5.0,2.5/)
int_vals=(/0.4,0.5,0.5,0.25/)



do l=0,3 


geopFile=addfile("/home/iitm/Documents/work/z00criterion/std1_moreThan13/nc_files/"+levs(l)+"/Anom_ERADAILY-1.5deg_1.5_"+levs(l)+".nc","r")

anomGeo=geopFile->t
printVarSummary(anomGeo)



  testprob = geopFile ->z
  prob=testprob/9.8
  copy_VarMeta(testprob,prob)
  

wks = gsn_open_wks("png","Anom_temp_z_"+levs(l))         ; send graphics to PNG file
  
  res = True  
  res@mpFillOn = False
  res@mpMaxLatF = 90.                         ; specify the plot domain
  res@mpMinLatF = 0.                         ;                         
  res@mpMinLonF = -100                      ;
  res@mpMaxLonF = 180                        ;
  res@mpCenterLonF = 80
  res@mpOutlineOn = True	                    ; turn the map outline on
  res@gsnFrame     =  False                   ; do not advance the frame
  
   res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
 res@cnMinLevelValF  = low_vals(l)			; set the minimum contour level
 res@cnMaxLevelValF  = high_vals(l)			; set the maximum contour level
 res@cnLevelSpacingF = int_vals(l)			; set the interval between contours
  res@cnLineLabelsOn = False                  ; do not use line labels
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
  res@cnFillPalette   = "BlueDarkRed18"
  res@tiMainString = "Temperature and Geopotential height anomaly "+levs(l)            ; set the main title
  res@gsnLeftString = ""                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""  
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)

  sres = res
  sres@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
 sres@cnMinLevelValF  = -140			; set the minimum contour level
 sres@cnMaxLevelValF  = 140			; set the maximum contour level
 sres@cnLevelSpacingF = 10
  sres@cnFillOn = False                       ; do not color fill
  sres@cnMonoLineThickness =True
  sres@cnLineThicknessF = 3.0
  ;sres@cnMonoLineDashPattern  =True
  ;sres@cnLineDashPattern = 2
  sres@cnMonoLineColor = True
  sres@cnLineColor = "Black"
  sres@cnLinesOn = True                       ; turn the contour lines on
  sres@cnLineLabelsOn = True                  ; turn the line labels on
  sres@tiMainString = ""                      ; do not draw a main title
  delete(sres@cnLevels)                       ; needed as the size of the cnLevels attribute is about to change (next line)
 sres@gsLineDashPattern  = 4 
 sres@gsnContourNegLineDashPattern = 2
  ;sres@cnLevels = (/0.01,0.05/)              ; set a different set of contour levels
  ;sres@cnInfoLabelOrthogonalPosF = 0.4        ; push the InfoLabel down below the label bar
  sres@gsnPolar   = "NH" 
  ;prob=prob
 ;copy_VarMeta(xAve,anomGeo(0,:,:))
 ;copy_VarMeta(xAve,prob)
;printVarSummary(xAve)
printVarSummary(prob)

  ;plot = gsn_csm_contour_map(wks,anomGeo(0,:,:),res)    ; create and draw the temperature plot
 ; plot2 = gsn_csm_contour_map(wks,prob,sres)  ; create and draw the U-wind plot on top of the temperature plot
 
  plot = gsn_csm_contour_map_polar(wks,anomGeo(0,:,:),res)    ; create and draw the temperature plot
  plot2 = gsn_csm_contour_map_polar(wks,prob(0,:,:),sres)  ; create and draw the U-wind plot on top of the temperature plot
  frame(wks)                                  ; advance the frame
end do
end
