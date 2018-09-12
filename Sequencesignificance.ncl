begin

levs=(/"500hPa","700hPa","850hPa","950hPa"/)
mins=(/-80,-50,-40,-30/)
maxs=(/80,50,40,30/)
ints=(/10,5,5,5/)

do l=0,0

do d = 0,14

evefname="/home/iitm/Documents/work/z00criterion/std1_moreThan13/nc_files/sequence/"+levs(l)+"/FogDay"+d+"_ERA_1.5_"+levs(l)+".nc"
dayfname="/home/iitm/Documents/Data/ERA-1.5/ERADAILY-1.5deg-"+levs(l)+"-Dec-Jan-1979-2016.nc"
anomfname="/home/iitm/Documents/work/z00criterion/std1_moreThan13/nc_files/sequence/"+levs(l)+"/AnomFogDay"+d+"_ERA_1.5_"+levs(l)+".nc"

evfile=addfile(evefname,"r")
climfile=addfile(dayfname,"r")
anomfile=addfile(anomfname,"r")




eventGeo=evfile->z
Geo=climfile->z
anomGeo=anomfile->z/9.81


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
  prob = ttest(xAve,xVar,8, yAve,yVar,2356, iflag, False) 
  printVarSummary(prob)


wks = gsn_open_wks("png",levs(l)+"_z_day"+d)         ; send graphics to PNG file
  
  res = True  
  res@mpFillOn = False
  res@mpMaxLatF = 90.                         ; specify the plot domain
  res@mpMinLatF = 0.                         ;                         
 ; res@mpMinLonF = -180                        ;
 ; res@mpMaxLonF = 180                        ;
  res@mpCenterLonF = 80
  res@mpOutlineOn = True	                    ; turn the map outline on
  res@gsnFrame     =  False                   ; do not advance the frame
  
  res@cnLevelSelectionMode = "ExplicitLevels" ; use explicit levels
  res@cnLevels = ispan(-60,60,10)             ; set the contour levels
  res@cnLineLabelsOn = False                  ; do not use line labels
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
  res@cnFillPalette   = "BlueDarkRed18"
  res@tiMainString = levs(l)+" Geopotential height anomaly "            ; set the main title
  res@gsnLeftString = ""                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""  
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)

  sres = res
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
  delete(sres@cnLevels)                       ; needed as the size of the cnLevels attribute is about to change (next line)
 sres@gsLineDashPattern  = 4 
  sres@cnLevels = (/0.01,0.05/)              ; set a different set of contour levels
  ;sres@cnInfoLabelOrthogonalPosF = 0.4        ; push the InfoLabel down below the label bar
  sres@gsnPolar   = "NH" 
  ;prob=prob
 copy_VarMeta(xAve,anomGeo(0,:,:))
 copy_VarMeta(xAve,prob)
printVarSummary(xAve)
printVarSummary(anomGeo)

 
  plot = gsn_csm_contour_map_polar(wks,anomGeo(0,:,:),res)    ; create and draw the temperature plot
  plot2 = gsn_csm_contour_map_polar(wks,prob,sres)  ; create and draw the U-wind plot on top of the temperature plot
  frame(wks)                                  ; advance the frame
delete(eventGeo)
delete(xtmp)
end do
end do
end
