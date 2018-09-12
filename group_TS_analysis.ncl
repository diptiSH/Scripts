begin

fin=addfile("/home/iitm/Documents/ncdc_data_anal/4station_analysis/Station_fog_data.nc","r")


fogdata=fin->fogdata
nostations=dimsizes(fogdata(:,0,0,0))
year_list=ispan(1980,2016,1)

printVarSummary(fogdata)

grFogdata=dim_sum_n_Wrap(fogdata,0)
foggyStations=ndtooned(grFogdata)
asciiwrite("foggyStations.txt",foggyStations)

printVarSummary(grFogdata)


seasonalVal=new((/nostations+1,dimsizes(year_list)/),integer)
seasonalVal=0
decVal=new((/nostations+1,dimsizes(year_list)/),integer)
janVal=new((/nostations+1,dimsizes(year_list)/),integer)
decVal=0
janVal=0



;;;;;;;; loop for years
   do year=1980,2016
      dec_grfog=grFogdata({year-1},{12},:)
      jan_grfog=grFogdata({year},{1},:)
      ;printVarSummary( dec_grfog)
      ;printVarSummary(jan_grfog)
        
        do i=0,30
          
          do st=0,4
              if(.not.ismissing(dec_grfog(i)) .and. dec_grfog(i).eq.st)then
                 decVal(st,year-1980)=decVal(st,year-1980)+1
              end if

              if(.not.ismissing(jan_grfog(i)) .and. jan_grfog(i).eq.st)then
                 janVal(st,year-1980)=janVal(st,year-1980)+1
              end if
              
               seasonalVal(st,year-1980)= decVal(st,year-1980)+janVal(st,year-1980)

          end do
      
     end do
     
     
         delete(dec_grfog)
      delete(jan_grfog)
   end do


;************************************************
; plotting parameters
;************************************************
 wks   = gsn_open_wks ("png","Group_Time_Series_3-4")               ; send graphics to PNG file

 res                  = True                     ; plot mods desired
 res@tiMainString     = "Time Series of fog ocuurences"          ; add title
 res@xyLineThicknesses = (/  0.5,1.0, 1.5,  2.0, 2.5/)          ; make second line thicker
 res@xyLineColors      = (/"blue","red","black","darkgreen","brown"/)          ; change line color
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
 ;res@xyExplicitLegendLabels = (/"0","1","2","3","4"/)
res@xyExplicitLegendLabels = (/"3","4"/)

 plot  = gsn_csm_xy (wks,year_list, seasonalVal(3:4,:),res) ; create plot

 frame(wks)



end
