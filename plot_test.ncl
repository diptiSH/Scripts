begin

f=addfile("ERA_nclfiltered-21day-lowpass-1.5deg-500hPa-Dec-Jan-1980-2016_20W-160E20-75N.nc","r")
z=f->z(0,:,:)


;*******************

;plot

;*******************
  wks = gsn_open_wks("png", "test")
  res               = True
  ;res@gsnMaximize   = True
  res@cnFillOn      = "True"
  res@cnLinesOn     = True
  res@cnFillPalette  = "BlueDarkRed18"
  res@cnInfoLabelOn  = True
  res@cnLineLabelsOn = True
 ; res@mpOutlineBoundarySets="Geophysical"
 ; res@mpOutlineDrawOrder ="PostDraw"
  res@mpOutlineOn=True
  res@gsnAddCyclic =False
  res@lbLabelBarOn   = True ;force label bar on
 ;  res@lbLabelBarOn    = False 
   res@lbLabelBarOn = True
    res@mpMinLatF              = 20.0              ; map area
  res@mpMaxLatF              = 75.0                ; latitudes
  res@mpMinLonF              = -20.0              ; and
  res@mpMaxLonF              = 160.0               ; longitudes
  plot = gsn_csm_contour_map(wks, z, res)
end
