; ==============================================================
; eof_1.ncl
;
; Concepts illustrated:
;   - Calculating EOFs
;   - Drawing a time series plot
;   - Using coordinate subscripting to read a specified geographical region
;   - Rearranging longitude data to span -180 to 180
;   - Calculating symmetric contour intervals
;   - Drawing filled bars above and below a given reference line
;   - Drawing subtitles at the top of a plot
;   - Reordering an array
; ==============================================================
; NCL V6.4.0 has new functions eofunc_n_Wrap and 
; eofunc_ts_n_Wrap that allow you to calculate the EOFs without 
; first having to first reorder the data. See eof_1_640.ncl.
; ==============================================================
; Calculate EOFs of the Sea Level Pressure over the North Atlantic.
; ==============================================================
; The slp.mon.mean file can be downloaded from:
; http://www.esrl.noaa.gov/psd/data/gridded/data.ncep.reanalysis.surface.html
; ==============================================================
; These files are loaded by default in NCL V6.2.0 and newer
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"

begin
; ==============================================================
; User defined parameters that specify region of globe and
; ==============================================================
  latS   =  24
  latN   = 32 
  lonL   =74
  lonR   =  86

  yrStrt = 1979
  yrLast = 2013

  season = "DJF"    ; choose Dec-Jan-Feb seasonal mean

  neof   = 3      ; number of EOFs
  optEOF = True       
  optEOF@jopt = 0   ; This is the default; most commonly used; no need to specify.
;;optEOF@jopt = 1   ; **only** if the correlation EOF is desired

  optETS = False

; ==============================================================
; Open the file: Read only the user specified period
; ==============================================================
  f      = addfile ("/home/iitm/Documents/Data/mask/masked_ERADAILY-1.5deg-inversion-Dec-Jan-1979-2013.nc", "r")

  TIME   = f->time
  YYYY   = cd_calendar(TIME,-1)/100                 ; entire file
  iYYYY  = ind(YYYY.ge.yrStrt .and. YYYY.le.yrLast)

  t    = f->t
   inv = t(latitude|:,longitude|:,time|:)
  printVarSummary(inv)                              ; variable overview






; =================================================================
; Reorder (lat,lon,time) the *weighted* input data
; Access the area of interest via coordinate subscripting
; =================================================================
  xw     = inv({latitude|latS:latN},{longitude|lonL:lonR},time|:)
  x      = inv(time|:,{latitude|latS:latN},{longitude|lonL:lonR})

printVarSummary(xw)

  eof      = eofunc_Wrap(xw, neof, optEOF)      
  eof_ts   = eofunc_ts_Wrap (xw, eof, optETS)

  printVarSummary( eof )                         ; examine EOF variables
  printVarSummary( eof_ts )




;============================================================
; PLOTS
;============================================================
  wks = gsn_open_wks("png","eof")         ; send graphics to PNG file
  plot = new(neof,graphic)                ; create graphic array
                                          ; only needed if paneling
; EOF patterns

  res                      = True         
  res@gsnDraw              = False        ; don't draw yet
  res@gsnFrame             = False        ; don't advance frame yet

  res@gsnAddCyclic         = False        ; plotted dataa are not cyclic
 
  res@mpFillOn             = False        ; turn off map fill
  res@mpMinLatF            = latS         ; zoom in on map
  res@mpMaxLatF            = latN
  res@mpMinLonF            = lonL
  res@mpMaxLonF            = lonR

  res@cnFillOn             = True         ; turn on color fill
  res@cnLinesOn            = False        ; True is default
 ;res@cnLineLabelsOn       = False        ; True is default
  res@cnFillPalette        = "BlWhRe"     ; set color map
  res@lbLabelBarOn         = False        ; turn off individual lb's

                                          ; set symmetric plot min/max
  symMinMaxPlt(eof, 16, False, res)       ; contributed.ncl

; panel plot only resources
  resP                     = True         ; modify the panel plot
  resP@gsnMaximize         = True         ; large format
  resP@gsnPanelLabelBar    = True         ; add common colorbar


  resP@txString            = "Inversion Dec-Jan 1979-2013"

;*******************************************
; first plot
;*******************************************
  do n=0,neof-1
     res@gsnLeftString  = "EOF "+(n+1)
     res@gsnRightString = sprintf("%5.1f", eof@pcvar(n)) +"%"
     plot(n)=gsn_csm_contour_map_ce(wks,eof(n,:,:),res)
  end do
  gsn_panel(wks,plot,(/neof,1/),resP)     ; now draw as one plot


;*******************************************
; second plot
;*******************************************
; EOF time series  [bar form]

  rts           = True
  rts@gsnDraw   = False       ; don't draw yet
  rts@gsnFrame  = False       ; don't advance frame yet
  rts@gsnScale  = True        ; force text scaling               

; these four rtsources allow the user to stretch the plot size, and
; decide exactly where on the page to draw it.

  rts@vpHeightF = 0.40        ; Changes the aspect ratio
  rts@vpWidthF  = 0.85
  rts@vpXF      = 0.10        ; change start locations
  rts@vpYF      = 0.75        ; the plot


  rts@tiYAxisString = "Pa"                    ; y-axis label      

  rts@gsnYRefLine           = 0.              ; reference line   
  rts@gsnXYBarChart         = True            ; create bar chart 
  rts@gsnAboveYRefLineColor = "red"           ; above ref line fill red
  rts@gsnBelowYRefLineColor = "blue"          ; below ref line fill blue

; panel plot only resources
  rtsP                      = True            ; modify the panel plot
  rtsP@gsnMaximize          = True            ; large format
  rtsP@txString             = "Inversion Dec-Jan 1979-2013"

  year = ispan(1,2170,1)

; create individual plots
  do n=0,neof-1
     rts@gsnLeftString  = "EOF "+(n+1)
     rts@gsnRightString = sprintf("%5.1f", eof@pcvar(n)) +"%"
     plot(n) = gsn_csm_xy (wks,year,eof_ts(n,:),rts)
  end do
  gsn_panel(wks,plot,(/neof,1/),rtsP)     ; now draw as one plot

do i=0,2
asciiwrite(i+"ts.txt",eof_ts(i,:))
end do

end


