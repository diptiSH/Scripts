oad "$NCARG_ROOT/lib/ncarg/nclscripts/contrib/cd_string.ncl"

begin

fname=(/"NoFog","fog_days105","AO_pos_EU_neg","AO_neg_EU_pos","both_pos","both_neg","AO_pos","AO_neg","EU_pos","EU_neg"/)

data=asciiread("AO_EU.csv",-1,"string")

allDates=numAsciiRow("AO_EU.csv")
print(allDates)

;print(data)

delim=","

year=stringtointeger(str_get_field(data, 1, delim))
mon=stringtointeger(str_get_field(data, 2, delim))
day=stringtointeger(str_get_field(data, 3, delim))
AO=stringtofloat(str_get_field(data, 4, delim))
EU=stringtofloat(str_get_field(data, 5, delim))

;print(EU)

;printVarSummary(year)
;printVarSummary(mon)
;printVarSummary(day)
;printVarSummary(AO)
;printVarSummary(EU)

do f=0,dimsizes(fname)-1

dateData=asciiread(fname(f),-1,"string")
;print(dateData)
delim="-"
yr=stringtointeger(str_get_field(dateData, 1, delim))
mn=stringtointeger(str_get_field(dateData, 2, delim))
d=stringtointeger(str_get_field(dateData, 3, delim))

;print(d)

noDates=numAsciiRow(fname(f))
print(noDates)

eyr=new((/noDates,15/),"integer")
emn=new((/noDates,15/),"integer")
ed=new((/noDates,15/),"integer")
end_string=new((/noDates,15/),"string")
eu_mean=new(15,"float")
ao_mean=new(15,"float")
eu_mean=0.0
ao_mean=0.0

 do lag=-7,7
	eu=0.0
	ao=0.0
	cnt=0
	do i=0,noDates-1
           start_time=cd_inv_calendar(yr(i),mn(i),d(i),0,0,0,"seconds since 1900-1-1 00:00:00",0)
           delta=lag*86400      ; convert lag to seconds since our calendar units are seconds
           end_time=start_time+delta
           copy_VarAtts(start_time,end_time)
           end_string(i,lag+7)=cd_string(end_time,"%Y-%N-%D")
           eyr(i,lag+7)=stringtointeger(str_get_field(end_string(i,lag+7), 1, delim))
           emn(i,lag+7)=stringtointeger(str_get_field(end_string(i,lag+7), 2, delim))
           ed(i,lag+7)=stringtointeger(str_get_field(end_string(i,lag+7), 3, delim))
	 do j=0,allDates-1
	    if ((year(j).eq.eyr(i,lag+7)).and.(mon(j).eq.emn(i,lag+7)) .and.(day(j).eq.ed(i,lag+7))) then
		eu=eu+EU(j)
		ao=ao+AO(j)
		cnt=cnt+1
	    end if 
	 end do
	end do
    eu_mean(lag+7)=eu/cnt
    ao_mean(lag+7)=ao/cnt

 end do


print(eu_mean)
print(ao_mean)


;---To plot multiple lines, you must put them into a mulidimensional array.
 plot_data      = new((/2,dimsizes(eu_mean)/),float)

 plot_data(0,:) = eu_mean
 plot_data(1,:) = ao_mean
;
;
;Plotting part
;
;
 wks   = gsn_open_wks ("eps",fname(f))                ; send graphics to PNG file
 
 ;---Set plotting parameters

 res                   = True                      ; plot mods desired
 res@tiMainString      = fname(f)       ; add title
;
; Similiar resources are xyLineThicknessF and xyLineColor,
; which will affect all lines in the array.
;
 ; add a legend
 res@pmLegendDisplayMode    = "Always"              ; turn on legend
 
 res@pmLegendSide           = "Top"                 ; Change location of 
 res@pmLegendParallelPosF   = .90                   ; move units right
 res@pmLegendOrthogonalPosF = -0.5                 ; more neg = down
 
 res@pmLegendWidthF         = 0.12                  ; Change width and
 res@pmLegendHeightF        = 0.25                  ; height of legend.
 res@lgLabelFontHeightF     = .02                   ; change font height
 res@lgPerimOn              = False                 ; no box around
; labels for the legend
 res@xyExplicitLegendLabels = (/"EU","AO"/)

 res@gsnYRefLine           = 0.0             ; create a reference line  
 res@gsnXRefLine = 0.0 
 
 res@trYMinF  = -2.0                   ; min value on y-axis
  res@trYMaxF  =  2.0                   ; max value on y-axis
  
 res@xyLineThicknesses = (/  1.0,   2.0/)          ; make second line thicker
 res@xyLineColors      = (/"blue","red"/)          ; change line color

 plot  = gsn_csm_xy (wks,ispan(-7,7,1),plot_data,res) ; create plot

delete(dateData)
delete(yr)
delete(mn)
delete(d)
delete(eyr)
delete(emn)
delete(ed)
delete(end_string)
delete(plot)
delete(wks) 

end do

end
