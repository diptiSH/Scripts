
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;--------------------------------------------------------------------------------
; 
;--------------------------------------------------------------------------------
procedure add_co_cities(wks,map)
local cities, city_lats, city_lons, mkres, txres
begin
   fname  = "lat.txt"       
  lat   = asciiread (fname,26, "float")
  fname  = "lon.txt"                                             
  lon   = asciiread (fname,26, "float")
  ;cities =(/"Haldia" , "Mukhin" , "Churk" , "Gorakhpur" , "Hoshiarpur" , "Amritsar" , "Kapurthala" , "Jalandhar" , "Ferozepore" , "Bathinda" , "Ludhiana" , "Patiala" , "Ambala" , "Chandigarh" , "Uttar Kashi" , "Pauri" , "Tehri" , "Munsyari" , "Hissar" , "Sagrur" , "Karnal" , "Nainital" , "Mukteswar" , "Pantnagar" , "Askote" , "Dharchula" , "Rohtak" , "Narhaul" , "Gurgao" , "N Delhi P" , "N Delhi S" , "Shahajahanpur" , "Kheri" , "Hardoi" , "Bahraich" , "Gonda" , "Basti" , "Gwalior" , "Kanpur" , "Lucknow" , "Faizabad" , "Sultanpur" , "Gorakhpur(pbo)" , "Azamgarh" , "Raxaul" , "Motihari" , "Muzaffarpur" , "Darbhanga" , "Supaul" , "Forbesganj" , "Sheopur" , "Shivpuri" , "Datia" , "Nowgong" , "Fatehpur" , "Banda" , "Allahabad" , "Jaunpur" , "Varanasi " , "Gazipur" , "BHU" , "Ballia" , "Arrah" , "Chapra" , "Patna" , "Bhagalpur" , "Sabour" , "Purnea" , "Nimach" , "Rajgarh" , "Guna" , "Tikamgarh" , "Khajuraho" , "Panna" , "Satna" , "Rewa" , "Sidhi" , "Daltonganj" , "Dehri" , "Gaya" , "Jamui" , "Dumka" , "Behrampore" , "Ratlam" , "Ujjain" , "Shajapur" , "Bairagarh" , "Vidisha" , "Sagar" , "Raisen" , "Damoh" , "Jabalpur" , "Umaria" , "Hazaribag" , "Ranchi" , "Dhanbad" , "Purulia" , "Bankura" , "Shantiniketan" , "Burdwan" , "Suri" , "Krishnanagar" , "Bagati" , "Malanjkhand" , "Dhar" , "Alirajpur" , "Indore" , "Kannod" , "Hoshangabad" , "Panchmarhi" , "Chindwara" , "Narsinghpur" , "Seoni" , "Mandla" , "Chaibasa" , "Jamshedpur" , "Jamshedpur(2)" , "Midnapore" , "Uluberia" , "Kolkata (Ali)" , "Dumdum" , "Diamond harbour" , "Canning" , "Khargone" , "Khandwa" , "Betul" , "Contai" , "Digha" , "Sagar island" , "Sandheads"/) 

  cities    = (/"1" , "2" , "3" , "4" , "5" , "6" , "7" , "8" , "9" , "10" , "11" , "12" , "13" , "14" , "15" , "16" , "17" , "18" , "19" , "20" , "21" , "22" , "23" , "24" , "25" , "26" /)

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
  lat   = asciiread (fname,26, "float")
  fname  = "lon.txt"                                             
  lon   = asciiread (fname,26, "float")
  fname = "input.txt"
  input = asciiread (fname,26, "float")

print(fname)



;

;===========================================================================
; Begin plotting section.
;
  wks = gsn_open_wks("png","26Stations_fog_days")              ; send graphics to PNG file
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
mpres@tiMainString = "fog days "
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
 gsres@gsMarkerSizeF          =  0.004        ;-- set size of marker
;gsres@gsMarkerColor          = "purple"       ;-- marker color
gsres@gsMarkerIndex   = 16

minIn=min(input)
maxIn=max(input)
ran=(maxIn-minIn)/5.0

cl1=minIn+ran
cl2=cl1+ran
cl3=cl2+ran
cl4=cl3+ran

 
do i=0,25

if(input(i) .lt. cl1) then
 gsres@gsMarkerColor          = "yellow"      ;-- marker color
else if(input(i) .ge. cl1 .and. input(i) .lt. cl2 ) then
 gsres@gsMarkerColor          = "red"      ;-- marker color
else if(input(i) .ge. cl2 .and. input(i) .lt. cl3 ) then
 gsres@gsMarkerColor          = "green"      ;-- marker color
else if(input(i) .ge. cl3 .and. input(i) .lt. cl4 ) then
 gsres@gsMarkerColor          = "blue"      ;-- marker color
else
  gsres@gsMarkerColor          = "black"      ;-- marker color
end if
end if
end if
end if


gsn_polymarker(wks,map1,lon(i),lat(i),gsres)
 end do

 add_co_cities(wks,map1)

colors=(/"yellow","red","green","blue","black"/)
labels=(/"x<"+cl1,cl1+"<=x<"+cl2,cl2+"<=x<"+cl3,cl3+"<=x<"+cl4,"x>="+cl4/)
txres               = True
  txres@txFontHeightF = 0.012

 xleg = (/0.07,0.07,0.32,0.32,0.57,0.57/)   ; Location of
  xtxt = (/0.16,0.16,0.41,0.41,0.66,0.66/)   ; legend markers
  yleg = (/0.14,0.10,0.14,0.10,0.14,0.10/)   ; and text
  ytxt = (/0.14,0.10,0.14,0.10,0.14,0.10/)   ; strings.

do i=0,4
;
; Add marker and text for the legend.
      gsres@gsMarkerColor      = colors(i)
      gsres@gsMarkerIndex   = 16
      gsn_polymarker_ndc(wks,          xleg(i),yleg(i),gsres)
      gsn_text_ndc      (wks,labels(i),xtxt(i),ytxt(i),txres)

end do

draw(map1) 

frame(wks)    ; Advance the frame.

end




