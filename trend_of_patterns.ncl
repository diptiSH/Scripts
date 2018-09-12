begin

nodeRow=5
nodeColumn=4
nopatterns=nodeRow*nodeColumn
yyStrt=1980
yyLast=2016
year_list=ispan(yyStrt,yyLast,1)
noyears=dimsizes(year_list)       ;; 1980-2016
nomonths=2     ;; dec(previous year)-jan(same year) i.e. for year 1980, months will be dec 1979 and jan 1980 and so on
nodays=31
runs=1

pattern_numbs=(/2,7,9,13,14,16,17/);;;;;;;;;;;;;pattern numbers having more than 20 % of widespread days


do fin=1,runs

Patterndata=new((/noyears,nomonths,nodays/),"integer",99999)

Patterndata!0= "years"
Patterndata!1 = "months"
Patterndata!2 = "days"


Patterndata&years=year_list
Patterndata&months=(/12,1/)
Patterndata&days=ispan(1,31,1)

printVarSummary(Patterndata)



fname=fin+"map_result.txt"
data=asciiread(fname,-1,"string")


;print(data)

delim=" "              ; deliminator can be "," , "-" or " " etc

map1=stringtointeger(str_get_field(data,2, delim))

printVarSummary(map1) 

;print(map1)

map=map1(1:2294)

;print(map)
;;;;;;;;;;;;;;;;;;;;;;;; convert one D data to 3 data to consider yer, month and days
Patterndata = onedtond(map,(/noyears,nomonths,nodays/))
printVarSummary(Patterndata)

;print(Patterndata)


;;;;;;;;;;;;;;;;;;;;;;;; Calculate yearly count (time series) for each pattern to get trends
patternCount=new((/nopatterns+1,noyears/),"integer",-99999)
patternCount!0= "patterns"
patternCount!1= "years"

patternCount&patterns=ispan(1,nopatterns+1,1)
patternCount&years=year_list

printVarSummary(patternCount)
patternCount=0


;;;;;;;;;; loop for patterns
do i=0,nopatterns-1
       pat=i+1
;;;;;;;; loop for years
   do year=yyStrt,yyLast

          patternCount({pat},{year})= num(Patterndata({year},:,:).eq.pat)
          ;print(patternCount({pat},{year}))  
 
   end do

end do


do year=yyStrt,yyLast
        do i=0,dimsizes(pattern_numbs)-1
          patternCount({nopatterns+1},{year})= patternCount({nopatterns+1},{year})+ patternCount({pattern_numbs(i)},{year})
        end do
 
   end do


;-----------------------------------------------------
; plot resources
;-----------------------------------------------------
  plot = new (nopatterns+1, "graphic")
  txt_p=  new (nopatterns+1, "graphic")

  wks  = gsn_open_wks("png","manken")              ; send graphics to PNG file
 
  res                     = True                   ; plot mods desired
  res@gsnDraw             = False                  ; don't draw yet      
  res@gsnFrame            = False                  ; don't advance frame yet      

  res@xyDashPatterns      = 0                      ; solid line 
  res@xyLineColors        = (/"black", "red", "blue"/) 
  res@xyLineThicknesses   = (/1,3,1/)                

  res@vpHeightF           = 0.4                    ; change aspect ratio of plot
  res@vpWidthF            = 0.8                  
  res@vpXF                = 0.1                    ; start plot at x ndc coord 

  res@trXMinF             = yyStrt   
  res@trXMaxF             = yyLast
 res@trYMinF             = -3      
 res@trYMaxF             =  55
 ;res@gsnYRefLine         =  0.0

  txres                   =  True
  txres@txFontHeightF     =  0.02
  txres@txJust            = "CenterLeft"
  txres@txFontThicknessF  =  2.0      ; default=1.00
  txres@txFontHeightF     =  0.025    ; default=0.05

;;;;;;;;;;;; loop for patterns
do i=0,nopatterns
;-----------------------------------------------------
; Calculate regression and Mann-Kendall trend 
;-----------------------------------------------------
    trend_val = regline(year_list,patternCount(i,:))
    p_val= trend_manken(patternCount(i,:), False, 0) 

    print(trend_val)
    print(p_val)

;-----------------------------------------------------
; Store for plotting
;-----------------------------------------------------
              dplt     = new ( (/3,noyears/), typeof(trend_val), trend_val@_FillValue)
              dplt(0,:) =tofloat(patternCount(i,:))
              dplt(1,:) = trend_val*(year_list - trend_val@xave) + trend_val@yave
              dplt(2,:) = p_val(1)*(year_list - trend_val@xave) + trend_val@yave

  res@gsnCenterString     = "Pattern "+i
  plot(i) = gsn_csm_xy (wks,year_list,dplt(:,:),res)           ; create plot
  text    = "p="+sprintf("%5.3f",p_val(0))+"  trend="+sprintf("%5.2f",p_val(1) )+" days/year"
  txt_p(i) = gsn_add_text(wks,plot(i),text, 1992, 50,txres)
 
;printVarSummary(txt_0)

;exit

delete(trend_val)
delete(p_val)

end do


;************************************************
; create panel
;************************************************
  resP = True
  resP@gsnMaximize           = True
  resP@gsnPanelMainString    = "Days per year (Dec-Jan)"
  gsn_panel(wks,plot,(/nodeRow+1,nodeColumn/),resP)               ; now draw as one plot



end do


end
