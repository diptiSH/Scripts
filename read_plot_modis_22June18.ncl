begin


 f      = addfile("MOD08_D3.A2011353.061.2017329001002.hdf","r")


cl_top=short2flt(f->Cloud_Top_Pressure_Day_Mean)
cl_eRad=short2flt(f->Cloud_Effective_Radius_Liquid_Mean)
dimX   = dimsizes(cl_top)

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

  

   cl_eRad!0    = "LAT"                 ; name dimensions
   cl_eRad!1    = "LON"
   cl_eRad&LAT  =  LAT                  ; create coordinate variables
   cl_eRad&LON  =  LON

   cl_top!0    = "LAT"                 ; name dimensions
   cl_top!1    = "LON"
   cl_top&LAT  =  LAT                  ; create coordinate variables
   cl_top&LON  =  LON



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


                      fog_presence(j,i)=1
                  
             end if
        end if
    end if
  end if 

  end do
end do



;;;;;;;;;;;;;;;; plot


;wks = gsn_open_wks("png","Cloud_Fraction_Mean")         ; send graphics to PNG file
;wks = gsn_open_wks("png","Cloud_Fraction_Day_Mean")         ; send graphics to PNG file
;wks = gsn_open_wks("png","Cloud_Fraction_Nadir_Day_Mean")         ; send graphics to PNG file
;wks = gsn_open_wks("png","Cloud_Fraction_Day_Maximum")         ; send graphics to PNG file
wks = gsn_open_wks("png","cl_eRad")         ; send graphics to PNG file
  
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
  res@cnLineLabelsOn = True                 ; do not use line labels
 ; res@cnFillOn        = True                  ; color fill
 ; res@cnLinesOn       = True                 ; do not draw contour lines
  res@cnFillPalette   = "BlueDarkRed18"
  ;res@cnConstFEnableFill =True
 ; res@cnConstFLabelOn=False
 ; res@cnFillMode          = "RasterFill"     ; Turn on raster color
; res@cnLevelSelectionMode = "ManualLevels"    ; Manual contour invtervals
 ; res@cnMinLevelValF       = 0              ; Min level
 ; res@cnMaxLevelValF       = 1              ; Max level
  ;res@cnLevelSpacingF      = 1               ; interval
  
res@cnFillOn             = True
  ;res@cnFillColors         = (/"NavyBlue","Yellow"/)
   res@cnConstFEnableFill           = True
  res@cnConstFLabelBackgroundColor = "transparent"         ; Default is white
  ;res@cnLevelSelectionMode = "ExplicitLevels"
;---Use a value that's between the two values, 50 and 100.
  ;res@cnLevels             = (/0.5,1.5/) 
 

  plot2 = gsn_csm_contour_map(wks,cl_eRad,res)  ; create and draw the U-wind plot on top of the temperature plot
 

frame(wks)



end
