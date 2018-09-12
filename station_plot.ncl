; ==============================================================
; eof_0.ncl
;
;   - Reading given ascii file
;   - Pretty printing
;   - Calculating EOFs and Principal Components (ie: time series)
;   - Reconstructing the original array from EOFs and PCs

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;--------------------------------------------------------------------------------
; This procedure adds Golden, Denver, and Boulder to the given map
; using text strings.
;--------------------------------------------------------------------------------
procedure add_co_cities(wks,map)
local cities, city_lats, city_lons, mkres, txres
begin
   fname  = "lat.txt"       
  lat   = asciiread (fname,14, "float")
  fname  = "lon.txt"                                             
  lon   = asciiread (fname,14, "float")
 
  cities    = (/"Patna" , "Kolkata" , "Amritsar" , "Ambala" , "Hissar" , "Rohtak" , "New Delhi" , "Sonbhadra" , "Shahjahanpur" , "Bahraich" , "Lucknow" , "Gorakhpur" , "Allahabad" , "Varanasi"/)

  mkres               = True
  txres               = True
  mkres@gsMarkerSizeF = 10
  mkres@gsMarkerIndex = 16
  txres@txFontHeightF = 0.005  ; 0.02 if part of smaller map
  txres@txFont = "helvetica"
  txres@txJust = "BottomRight"
  map@cities_tx = gsn_add_text(wks,map,cities,lon,lat+0.05,txres)
end

begin


  fname  = "lat.txt"       
  lat   = asciiread (fname,14, "float")
  fname  = "lon.txt"                                             
  lon   = asciiread (fname,14, "float")
 

print(fname)



;

;===========================================================================
; Begin plotting section.
;
  wks = gsn_open_wks("pdf","Stations")              ; send graphics to PNG file
  gsn_define_colormap(wks,"WhViBlGrYeOrRe")      ; define a different color map
                
;
; Set up some map resources.
;
  mpres              = True
  mpres@gsnMaximize  = False             ; Maximize plot in frame.
  mpres@gsnFrame     = False            ; Don't advance the frame
  mpres@gsnDraw     = False            ; Don't Draw the frame
  mpres@mpOutlineOn           = True               ; turn on map outlines
  mpres@mpOutlineBoundarySets = "National" 
;
; Zoom in on India.
;
  mpres@mpMinLatF    = 8.0
  mpres@mpMaxLatF    = 35.
  mpres@mpMinLonF    = 65.
  mpres@mpMaxLonF    = 90.
mpres@mpFillColors = (/"transparent","transparent", \
  "transparent","transparent"/)    ;assign light gray to land masses

mpres@mpNationalLineThicknessF = 2.0 ; interior boundaries 
  mpres@mpGeophysicalLineThicknessF = 1.0 ; lines separating land/ocean 
mpres@tiMainString = "Stations used for identifying large scale fog events"
mpres@txFontHeightF = 0.013
mpres@gsnLeftString = " " 
mpres@gsnRightString = " "
  map1 = gsn_csm_map(wks,mpres)



;
;  Create logical variables to hold the marker and text resources.
;  These markers are different than the XY markers, because they are not
;  associated with an XY plot. You can put these markers on any plot.
;
  gsres               = True
  gsres@gsMarkerIndex = 16          ; Use filled dots for markers.
 gsres@gsMarkerSizeF          =  0.0005        ;-- set size of marker
;gsres@gsMarkerColor          = "purple"       ;-- marker color
gsres@gsMarkerIndex   = 16
colors  =(/"Red","Blue","Blue","Red","Black","Black","Red","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Red","Blue","Blue","Red","Black","Black","Red","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black", "Red","Red","Blue","Blue","Red","Black","Black","Red","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Red","Blue","Blue","Red","Black","Black","Red","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Red","Blue","Blue","Red","Black","Black","Red","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black", "Red","Red","Blue","Blue","Red","Black","Black","Red","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black","Black"/)
 

 
do i=0,13
 gsres@gsMarkerColor          = colors(i)      ;-- marker color
gsn_polymarker(wks,map1,lon(i),lat(i),gsres)


 end do

 add_co_cities(wks,map1)

draw(map1) 

frame(wks)    ; Advance the frame.

end




