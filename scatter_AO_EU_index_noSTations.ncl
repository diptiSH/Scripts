begin

AO=asciiread("AO",120,"float")
EU=asciiread("EU",120,"float")
fogStations=asciiread("fogStations",120,"integer")

;print(fogStations)


;----------------------------------------------------------------------
; Open a PNG file and define the color table and marker table
;----------------------------------------------------------------------
  colors  = new(dimsizes(AO),"string")
  marks = new(dimsizes(AO),"integer")

  wks = gsn_open_wks ("eps","scatter")
 ; gsn_define_colormap(wks,colors)

;----------------------------------------------------------------------
; Set some plot resources
;----------------------------------------------------------------------
  res                    = True

  res@gsnDraw            = False       ; Don't draw plot
  res@gsnFrame           = False       ; Don't advance frame

;---Resources for X/Y axes.
  res@trYMinF            =  -3.0               ; min value on y-axis
  res@trYMaxF            =  3.0               ; max value on y-axis
  res@trXMinF            =  -7.0                  ; min value on x-axis
  res@trXMaxF            =  7.0

;---Title resources
  res@tiMainString       = "AO Vs EU"
  res@tiXAxisString      = "AO index"
  res@tiYAxisString      = "EU index"
  res@tiMainFontHeightF  = 0.03

;---Draw x and y reference lines

  res@gsnYRefLine     = 0 
  res@gsnXRefLine     = 0


;---XY marker resources
  res@xyMarkLineMode     = "Markers"
  res@xyMarkerSizeF      = 0.005
  ;res@xyMarkerThicknessF = 3.
  res@xyMonoMarkerColor  = False          ; Allow different colors for markers

 do i=0,104
  if (fogStations(i).le.20) then
     colors(i)="black"   
      marks(i)=4
;    print(colors(0)) 
  else 
 ;   print(colors(1))
    colors(i)="red"
    marks(i)=12
  end if
  
  
 end do



do i=105,119
     colors(i)="blue"
      marks(i)=16
end do


    res@xyMarkerColors     = colors     ; It's okay to list more than
                                          ; you need here
    res@xyMarkers          = marks


  plot = gsn_csm_xy (wks,transpose((/AO,AO/)), \
                         transpose((/EU,EU/)),res)
 

;----------------------------------------------------------------------
; Draw some markers and text.
;----------------------------------------------------------------------
  labels2  = (/"10-20 ",">20 and inversion",">20"/)
  markers1 = (/     4,     12,    16/)
  cols     = (/"black","red","blue"/)
  xpos2    = (/  0.21,   0.31,  0.56/)
  xpos3    = (/  0.23,   0.33,  0.58/)

  mkres               = True         ; Marker resources
  txres               = True         ; Text resources
  txres@txFontHeightF = 0.015
  txres@txJust        = "CenterLeft"
 ; mkres@xyMonoMarkerColor  = False
  do i = 0,2
   ;  mkres@gsMarkerThicknessF = 3.5
     mkres@gsMarkerSizeF      = 0.005
     mkres@gsMarkerIndex      = markers1(i)
     mkres@gsMarkerColor     = cols(i)   
     gsn_polymarker_ndc(wks,           xpos2(i),0.23,mkres)
     gsn_text_ndc      (wks,labels2(i),xpos3(i),0.23,txres)
  end do

 draw(plot)
 frame(wks)    ; Now advance the frame.

end
