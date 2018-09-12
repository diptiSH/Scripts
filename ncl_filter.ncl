begin
;f=addfile("/home/iitm/Documents/Data/ERA-1.5/Daily_anomalies/ERAANOM_Daymean_500hPa_Z_1.5_Jan-Dec_1979-2018.nc","r")

f=addfile("/home/iitm/Documents/Data/ERA-1.5/Daily_anomalies/ERAANOM_Daymean_500hPa_Z_1.5_Jan-Dec_1979-2018_20W-160E_20-75N.nc","r")


data=f->z
printVarSummary(data)


   nwt = 63                 ;;;;;;;;;;;; loose 31 days at each end
   nwt2 = 31                ;;;;;;;;;;;; loose 15 days at each end
   nwt3 = 123               ;;;;;;;;;;;; loose 61 days at each end
    fca = 1/21.0000         ;;;;;;;;;;;;filter less than 21 days frequency
    ihp = 0          
    nsigma = 1.
    wgt = filwgts_lanczos (nwt, ihp, fca, -999., nsigma)  
    wgt2 = filwgts_lanczos (nwt2, ihp, fca, -999., nsigma)
    wgt3 = filwgts_lanczos (nwt3, ihp, fca, -999., nsigma)    

printVarSummary(wgt)
;print(wgt)

ncl_data = wgt_runave_n_Wrap ( data, wgt, 0 ,0)   ;
ncl_data2 = wgt_runave_n_Wrap ( data, wgt2, 0 ,0)   ;
ncl_data3 = wgt_runave_n_Wrap ( data, wgt3, 0 ,0)   ;

printVarSummary(ncl_data)
printVarSummary(data)

 

 ncdf = addfile("ERA_Low_pass_ncl_Daily_500hPaZ_1.5_20W-160E20-75N.nc" ,"c")  ; open output netCDF file

 ncdf->z = ncl_data                          ; 3D         

year_list=ispan(1,dimsizes(data(:,{25},{85})),1)

data_plot=new((/4,dimsizes(data(:,{25},{85}))/),typeof(data))
data_plot(0,:)=data(:,{25},{85})
data_plot(1,:)=ncl_data(:,{25},{85})
data_plot(2,:)=ncl_data2(:,{25},{85})
data_plot(3,:)=ncl_data3(:,{25},{85})


;************************************************
; plotting parameters
;************************************************
 wks   = gsn_open_wks ("png","filter")               ; send graphics to PNG file

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
res@xyExplicitLegendLabels = (/"orig","31","15","61"/)

 plot  = gsn_csm_xy (wks,year_list, data_plot,res) ; create plot

 frame(wks)




end
