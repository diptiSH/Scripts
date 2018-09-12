begin


 f      = addfile("MOD08_D3.A2016021.061.2017325090655.hdf","r")

 printVarSummary(f)

vars=getfilevarnames(f)

;print(vars(401:500))

AOD=short2flt(f->Aerosol_Optical_Depth_Land_Mean)
cl_top=short2flt(f->Cloud_Top_Pressure_Day_Mean)
cl_frac=short2flt(f->Cloud_Fraction_Day_Mean)
cl_eRad=short2flt(f->Cloud_Effective_Radius_Liquid_Mean)


printVarSummary(cl_eRad)


   dimX   = dimsizes(cl_frac )

   NLAT   = dimX(0)                 ; sst grid size X(NLAT,MLON)
   MLON   = dimX(1)
print(NLAT)
print(MLON)



;***************************************************************
; Extract/generate geographical information associated with X
; Create meta data and associate meta data with variable [data object]
;***************************************************************
 
   latS   = f@SW_Point_Latitude
   lonW   = f@SW_Point_Longitude
   latN   = abs(latS)
   lonE   = abs(lonW)

   LAT    = latGlobeFo(NLAT, "LAT", "latitude" , "degrees_north")
  ; LAT    = LAT(::-1)               
   LON    = lonGlobeFo(MLON, "LON", "longitude", "degrees_east")   ; 0 to 360 (nominal)
   ;LON    = (/ LON - 180. /)      ; make -180 to 180 (nominal)
   LON&LON= LON                   ; update coordinates

   cl_top!0    = "LAT"                 ; name dimensions
   cl_top!1    = "LON"
   cl_top&LAT  =  LAT                  ; create coordinate variables
   cl_top&LON  =  LON

   AOD!1    = "LAT"                 ; name dimensions
   AOD!2    = "LON"
   AOD&LAT  =  LAT                  ; create coordinate variables
   AOD&LON  =  LON

   cl_frac!0    = "LAT"                 ; name dimensions
   cl_frac!1    = "LON"
   cl_frac&LAT  =  LAT                  ; create coordinate variables
   cl_frac&LON  =  LON

   cl_eRad!0    = "LAT"                 ; name dimensions
   cl_eRad!1    = "LON"
   cl_eRad&LAT  =  LAT                  ; create coordinate variables
   cl_eRad&LON  =  LON

printVarSummary(cl_eRad)

fog_presence=new((/NLAT,MLON/),"integer")

printVarSummary(fog_presence)

   fog_presence!0    = "LAT"                 ; name dimensions
   fog_presence!1    = "LON"
   fog_presence&LAT  =  LAT                  ; create coordinate variables
   fog_presence&LON  =  LON
printVarSummary(fog_presence)
;;;;;;;;;;;;;;;; Fog detection Algorithm

do i=0,MLON-1
  do j=0,NLAT-1
    ;print( cl_top(j,i))
;;;;;;;;;;;; cloud top criteria
  if(.not.(ismissing(cl_top(j,i)))) then
   if(cl_top(j,i).ge.780 .and. cl_top(j,i).lt.1000 )then

;;;;;;;;;;;; cloud effective radius
        if(.not.(ismissing(cl_eRad(j,i)))) then       
             if(cl_eRad(j,i).lt.14.0)then

;;;;;;;;;;;;;;;;;;; cloud fraction criteria
               ; if(.not.(ismissing( cl_frac(j,i)))) then       
                ;   if( cl_frac(j,i).eq.1)then
                      fog_presence(j,i)=1
                 ;  end if
               ; end if
             end if
        end if
    end if
  end if 

  end do
end do


;;;;;;;;;;;;;;;; plot


wks = gsn_open_wks("png","fog")         ; send graphics to PNG file
  
  res = True  
  res@mpFillOn = False
  res@mpMaxLatF = 40.                         ; specify the plot domain
  res@mpMinLatF = 0.                         ;                         
  res@mpMinLonF = 60                      ;
  res@mpMaxLonF = 100                        ;
 ; res@mpCenterLonF = 80
  res@mpOutlineOn = True	                    ; turn the map outline on
  res@mpOutlineBoundarySets="National"
  res@gsnFrame     =  False                   ; do not advance the frame
  res@mpCountyLineColor="black"
  res@cnLineLabelsOn = False                  ; do not use line labels
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = True                 ; do not draw contour lines
  res@cnFillPalette   = "BlueDarkRed18"
  res@cnConstFEnableFill =True
 ; res@cnConstFLabelOn=False
  sres = res
 ;sres@gsnDraw         = False                      ; do not draw  
 sres@gsnFrame        = False     

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
     ; needed as the size of the cnLevels attribute is about to change (next line)
  sres@gsLineDashPattern  = 4 
   sres@cnLevelSelectionMode = "ExplicitLevels" ; use explicit levels
  ; sres@cnLevels = (/780,1000/)   ;cloud top
    sres@cnLevels = (/14,15/)   

   
  plot2 = gsn_csm_contour_map(wks,fog_presence,res)  ; create and draw the U-wind plot on top of the temperature plot
 ; plot = gsn_csm_contour_map(wks,cl_top,sres)    ; cloud top
   plot = gsn_csm_contour_map(wks,cl_eRad,sres)    ; create and draw the temperature plot
 ;  plot = gsn_csm_contour_map(wks,fog_presence,res)    ; create and draw the temperature plot

frame(wks)

end
