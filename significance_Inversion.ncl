begin

levs=(/"Inversion"/)

do l=0,0

evefname="/home/iitm/Documents/work/z00criterion/std1_moreThan13/nc_files/"+levs(l)+"/ERADAILY-1.5deg_1.5_"+levs(l)+".nc"
dayfname="/home/iitm/Documents/Data/ERA-1.5/ERADAILY-1.5deg-"+levs(l)+"-Dec-Jan-1979-2016_00Z.nc"
anomfname="/home/iitm/Documents/work/z00criterion/std1_moreThan13/nc_files/"+levs(l)+"/Anom_ERADAILY-1.5deg_1.5_"+levs(l)+".nc"

evfile=addfile(evefname,"r")
climfile=addfile(dayfname,"r")
anomfile=addfile(anomfname,"r")

anomGeo=anomfile->t


eventGeo=evfile->t
Geo=climfile->t


printVarSummary(eventGeo)
printVarSummary(Geo)
;printVarSummary(anomGeo)



xtmp = eventGeo(latitude|:,longitude|:,time|:)       ; reorder but do it only once [temporary]
  ytmp =Geo(latitude|:,longitude|:,time|:)
    
                                
  xAve = dim_avg_Wrap (xtmp)              ; calculate means at each grid point 
  yAve = dim_avg (ytmp)
  xVar = dim_variance (xtmp)         ; calculate variances
  yVar = dim_variance (ytmp)

 iflag= True                        ; population variance similar
  prob = ttest(xAve,xVar,38, yAve,yVar,2356, iflag, False) 
  printVarSummary(prob)


wks = gsn_open_wks("png",levs(l)+"_Inversion_t")         ; send graphics to PNG file
  
  res = True  
  res@mpFillOn = False
  res@mpMaxLatF = 90.                         ; specify the plot domain
  res@mpMinLatF = 0.                         ;                         
 ; res@mpMinLonF = -180                        ;
 ; res@mpMaxLonF = 180                        ;
  res@mpCenterLonF = 80
  res@mpOutlineOn = True	                    ; turn the map outline on
  res@gsnFrame     =  False                   ; do not advance the frame
  
 res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  res@cnMinLevelValF  = -3.0			; set the minimum contour level
  res@cnMaxLevelValF  = 3.0			; set the maximum contour level
  res@cnLevelSpacingF = 0.5			; set the interval between contours
  res@cnLineLabelsOn = False                  ; do not use line labels
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
  res@cnFillPalette   = "BlueDarkRed18"
  res@tiMainString = levs(l)+" Inversion anomaly "            ; set the main title
  res@gsnLeftString = ""                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""  
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)

  sres = res
  sres@gsnDraw         = False                      ; do not draw  
 sres@gsnFrame        = False                      ; do not advance frame
  sres@cnLevelSelectionMode = "ExplicitLevels" ; use explicit levels
  sres@cnFillOn = False                       ; do not color fill
  sres@cnMonoLineThickness =True
  sres@cnLineThicknessF = 3.0
  ;sres@cnMonoLineDashPattern  =True
  ;sres@cnLineDashPattern = 2
  sres@cnMonoLineColor = True
  sres@cnLineColor = "Green"
  sres@cnLinesOn = True                       ; turn the contour lines on
  sres@cnLineLabelsOn = True                  ; turn the line labels on
  sres@tiMainString = ""                      ; do not draw a main title
 ; sres@cnMonoFillPattern    = True
  ;sres@cnFillPattern   =3 
  delete(sres@cnLevels)                       ; needed as the size of the cnLevels attribute is about to change (next line)
 sres@gsLineDashPattern  = 4 
  sres@cnLevels = (/0.0,0.05/)              ; set a different set of contour levels
  ;sres@cnInfoLabelOrthogonalPosF = 0.4        ; push the InfoLabel down below the label bar
  sres@gsnPolar   = "NH" 
  ;prob=prob
 copy_VarMeta(xAve,anomGeo(0,:,:))
 copy_VarMeta(xAve,prob)
printVarSummary(xAve)
printVarSummary(anomGeo)

 
  plot = gsn_csm_contour_map_polar(wks,anomGeo(0,:,:),res)    ; create and draw the temperature plot
  plot2 = gsn_csm_contour_map_polar(wks,prob,sres)  ; create and draw the U-wind plot on top of the temperature plot
  
;---Add shading to second plot
  opt                  = True
  opt@gsnShadeFillType = "pattern"
 ; opt@gsnShadeHigh     = 2
  opt@gsnShadeMid = 11
  ;opt@gsnShadeDotSizeF = 1
  plot2 = gsn_contour_shade(plot2,0.0,0.05,opt)
  delete(opt)
  draw(plot2)
  frame(wks)                                  ; advance the frame
  printVarSummary(prob)
  printMinMax(prob,0)
end do
end
