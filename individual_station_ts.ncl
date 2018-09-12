begin

fin=addfile("Station_fog_data.nc","r")


fogdata=fin->fogdata
nostations=dimsizes(fogdata(:,0,0,0))
year_list=ispan(1980,2016,1)

printVarSummary(fogdata)

seasonalVal=new((/nostations,dimsizes(year_list)/),integer)
seasonalVal=0
decVal=new((/nostations,dimsizes(year_list)/),integer)
janVal=new((/nostations,dimsizes(year_list)/),integer)
decVal=0
janVal=0




;;;;;;;;;; loop for stations
do i=0,nostations-1

;;;;;;;; loop for years
   do year=1980,2016

     decVal(i,year-1980)=sum(fogdata(i,{year-1},{12},:))
     janVal(i,year-1980)=sum(fogdata(i,{year},{1},:))
     seasonalVal(i,year-1980)= decVal(i,year-1980)+janVal(i,year-1980)

   end do

  

end do

;************************************************
; plotting parameters
;************************************************
 wks   = gsn_open_wks ("png","Time Series")               ; send graphics to PNG file

 res                  = True                     ; plot mods desired
 res@tiMainString     = "Time Series of fog ocuurences"          ; add title
 res@xyLineThicknesses = (/  1.0, 1.5,  2.0, 2.5/)          ; make second line thicker
 res@xyLineColors      = (/"blue","red","black","darkgreen"/)          ; change line color
 res@xyDashPattern  = 0                         ; Make curves all solid
  res@gsnFrame          = False                      ; don't advance frame yet

; add a legend
 res@pmLegendDisplayMode    = "Always"              ; turn on legend
 
 res@pmLegendSide           = "Top"                 ; Change location of 
 ;res@pmLegendParallelPosF   = .90                   ; move units right
 res@pmLegendOrthogonalPosF = -0.37                  ; more neg = down
 
 res@pmLegendWidthF         = 0.12                  ; Change width and
 res@pmLegendHeightF        = 0.15                  ; height of legend.
 res@lgLabelFontHeightF     = .02                   ; change font height
 res@lgPerimOn              = False                 ; no box around
; labels for the legend
 res@xyExplicitLegendLabels = (/"Amritsar","Delhi","Lucknow","Patna"/)

 plot  = gsn_csm_xy (wks,year_list, seasonalVal,res) ; create plot

 frame(wks)



end
