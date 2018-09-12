begin

nodeRow=2
nodeColumn=2
runs=10


interclust_corre_val=new((/runs,3/),double)
stat_vals_summary=new((/runs,3/),double)


mapsize=nodeRow*nodeColumn

;;;;;;;;;;;;;; read input files

station=readAsciiTable("/home/iitm/Documents/ncdc_data_anal/4station_analysis/Group_ts/foggyStations.txt",1,"integer",(/31,31/))

printVarSummary(station)

stations=station(:,0)

;print(stations(2290:))


inFile=addfile("/home/iitm/Documents/Data/SOM_ERA_500_input/ERAANOM-1.5deg-500hPa-Dec-Jan-1979-2016_20W-160E20-75N.nc","r")

z_old=inFile->z(:,:,:)

units=z_old&time@units

time1=cd_inv_calendar(1979,12,1,00,00,00,units,0)
time2=cd_inv_calendar(2016,1,31,00,00,00,units,0)

z=z_old({time1:time2},:,:)


printVarSummary(z)


ntime=dimsizes(z&time)
nlat=dimsizes(z&latitude)
nlon=dimsizes(z&longitude)
;inputSize=dimsizes(z)



do fin=1,runs

fname=fin+"map_result.txt"
data=asciiread(fname,-1,"string")


;print(data)

delim=" "              ; deliminator can be "," , "-" or " " etc

map1=stringtointeger(str_get_field(data,2, delim))

printVarSummary(map1) 

;print(map1)

map=map1(1:2294)

;asciiwrite("testmap.txt",map)

;map=map+1


z_new=reshape(z,(/ntime,nlat*nlon/))

inputVectors=z_new
inputVectors!0="time"
inputVectors&time=z&time	
printVarSummary(inputVectors)
inputSize=dimsizes(inputVectors)

;print(map)

;;;;;;;;;;;;;;;;;;;;;;;;; get count associated to each pattern

count_patterns=new(mapsize,integer)

count_patterns=0

do i=0,dimsizes(map)-1

 do p=1,mapsize

  if(map(i).eq.p) then

    count_patterns(p-1)=count_patterns(p-1)+1  

  end if
  

 end do


end do

print(count_patterns)

;;;;;;;;;;;;;;;;;;;;;;;;;;; now average for each pattern

z_pat=new((/mapsize,nlat,nlon/),typeof(z))

do p=1,mapsize
        z_obs=new((/count_patterns(p-1),nlat,nlon/),typeof(z))
          pat_no=0
	do i=0,dimsizes(map)-1
		if(map(i).eq.p) then
                    z_obs(pat_no,:,:)=z(i,:,:)
                    pat_no= pat_no+1  
                end if
	end do
        z_pat(p-1,:,:)=dim_avg_n_Wrap(z_obs,0)
	delete(z_obs)
end do

printVarSummary(z_pat)

;;;;;;;;;;;;; calculate intercluster correlations

interClust_mat=new(mapsize*mapsize,typeof(z))

in=0
do i=0,mapsize-1
  do j=1,mapsize
  if(i.ne.j-1) then
   
  interClust_mat(in)=pattern_cor( z_pat(i,:,:), z_pat(j-1,:,:),1.0,0)
  
  end if
  in=in+1
  end do
end do

print(interClust_mat)

interclust_corre_val(fin-1,0)=min(interClust_mat)
interclust_corre_val(fin-1,1)=max(interClust_mat)
interclust_corre_val(fin-1,2)=avg(get_unique_values(interClust_mat))


;print(min_corre_val(irun)+"   "+max_corre_val(irun)+"  "+avg_corre_val(irun))


nodVects_end=reshape(z_pat,(/nodeRow,nodeColumn,nlat,nlon/))


;;;;;;;;;;;;;; plot nodes/patterns

wks=gsn_open_wks ("png",fin+"Rcluster patterns")
plots=new(mapsize,graphic)

do iter=0,mapsize-1

 w=mod(iter,nodeColumn)
 l=toint(iter/nodeColumn)
 ;print(iter)
 ;print(w)
 ;print(l)
 copy_VarMeta(z(0,:,:),nodVects_end(l,w,:,:))
 ;printVarSummary(nodVects_end(l,w,:,:))

 res                  = True                     ; plot mods desired
 res@tiMainString     = "Pattern "+iter          ; add title
 res@gsnDraw             = False            ; don't draw
  res@gsnFrame            = False            ; don't advance frame
 
  res@cnFillOn        = True                    ; turn on color 
 res@cnFillPalette   = "BlueRed"           ; set color map
 res@lbLabelBarOn    = False                 ; will draw a panel label bar instead
 res@gsnAddCyclic = False
  res@mpMinLatF              = 20.0              ; map area
  res@mpMaxLatF              = 75.0                ; latitudes
  res@mpMinLonF              = -20.0              ; and
  res@mpMaxLonF              = 160.0               ; longitudes
  res@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
  res@cnMinLevelValF       = -2000.0                ; set min contour level
  res@cnMaxLevelValF       =  2000.0                ; set max contour level
  res@cnLevelSpacingF      =  200               ; set contour spacing
   res@gsnCenterString =  " "
  plots(iter) = gsn_csm_contour_map(wks,nodVects_end(l,w,:,:), res)
end do

;************************************************
; create panel
;************************************************
  resP                  = True                   ; modify the panel plot
  resP@gsnFrame         = False                  ; don't advance panel plot
  resP@gsnPanelLabelBar = True                   ; add common colorbar
  resP@gsnPanelMainString = "Cluster Patterns"     ; set main title
 ; resP@gsnPanelBottom   = 0.05                   ; add space at bottom
 ; resP@gsnPanelFigureStrings= (/"a)","b)","c)"/) ; add strings to panel
  resP@amJust   = "TopLeft"
  gsn_panel(wks,plots,(/nodeRow,nodeColumn/),resP)               ; now draw as one plot

frame(wks)


;;;;;;;;;;;;;;;;; plot lowest correlation and highest correlation days 

nodVects_singleInd=reshape(z_pat,(/nodeRow*nodeColumn,inputSize(1)/))
maxCorr=new(mapsize,"double")
minCorr=new(mapsize,"double")
maxDist=new(mapsize,"double")
minDist=new(mapsize,"double")
avgCorr=new(mapsize,"double")
avgDist=new(mapsize,"double")
stat_vals=new((/mapsize,6/),"double")
numb_days=new(mapsize,"integer")

maxCorrVect=new((/mapsize,nlat,nlon/),"double")
minCorrVect=new((/mapsize,nlat,nlon/),"double")
maxDistVect=new((/mapsize,nlat,nlon/),"double")
minDistVect=new((/mapsize,nlat,nlon/),"double")

 do n=1,mapsize 
 ;;;;;;;;;;;;count number of vectors associated with each node
     numb=0 
    do input=0,inputSize(0)-1
      if(map(input).eq.n) then
      numb=numb+1    
      end if 
    end do
    numb_days(n-1)=numb
;;;;;;;;;;;;Find out max and min corr and dist vals
     cor_val=new(numb,"double")
     dist_val=new(numb,"double")
     cor_val_ind=new(numb,"integer")
     dist_val_ind=new(numb,"integer")
     index=0
    do input=0,inputSize(0)-1
      if(map(input).eq.n) then
      cor_val(index)=esccr(nodVects_singleInd(map(input)-1,:),inputVectors(input,:),0)
      dist_val(index)=dim_rmsd(nodVects_singleInd(map(input)-1,:),inputVectors(input,:))
      cor_val_ind(index)=input
      dist_val_ind(index)=input
       index=index+1
      end if 
       
     end do

maxCorr(n-1)=max(cor_val)
minCorr(n-1)=min(cor_val)
maxDist(n-1)=max(dist_val)
minDist(n-1)=min(dist_val)
avgDist(n-1)=avg(dist_val)
avgCorr(n-1)=avg(cor_val)
  
maxCorrVect(n-1,:,:)=z(cor_val_ind(maxind(cor_val)),:,:)
minCorrVect(n-1,:,:)=z(cor_val_ind(minind(cor_val)),:,:)
maxDistVect(n-1,:,:)=z(cor_val_ind(maxind(dist_val)),:,:)
minDistVect(n-1,:,:)=z(cor_val_ind(minind(dist_val)),:,:)

    delete(cor_val)
     delete(dist_val)
     delete(cor_val_ind)
     delete(dist_val_ind)

 end do

stat_vals(:,0)=maxCorr
stat_vals(:,1)=minCorr
stat_vals(:,2)=avgCorr
stat_vals(:,3)=maxDist
stat_vals(:,4)=minDist
stat_vals(:,5)=avgDist


   opt = True
   opt@fout = fin+"stat_vals.txt"
   write_matrix (stat_vals, "15f12.4" , opt)

;asciiwrite("maxCorr.txt",maxCorr)
;asciiwrite("minCorr.txt",minCorr)
;asciiwrite("avgCorr.txt",avgCorr)

;asciiwrite("maxDist.txt",maxDist)
;asciiwrite("minDist.txt",minDist)
;asciiwrite("avgDist.txt",avgDist)
;asciiwrite(fin+"numb_days.txt", numb_days)

stat_vals_summary(fin-1,0)=avg(stat_vals(:,1))
stat_vals_summary(fin-1,1)=avg(stat_vals(:,0))
stat_vals_summary(fin-1,2)=avg(stat_vals(:,2))

;;;;;;;;;;;;;; plot maxDist minDist and maxCor and minCor plots

do n=0,mapsize-1 

w=mod(n,nodeColumn)
 l=toint(n/nodeColumn)
 ;print(iter)
 ;print(w)
 ;print(l)
 copy_VarMeta(z(0,:,:),nodVects_end(l,w,:,:))

wks=gsn_open_wks ("png",fin+"Rmax_min_cor_dist_plots"+n)
plots2=new(5,graphic)



 res2                  = True                     ; plot mods desired
 res2@gsnDraw             = False            ; don't draw
  res2@gsnFrame            = False            ; don't advance frame
 
  res2@cnFillOn        = True                    ; turn on color 
 res2@cnFillPalette   = "BlueRed"           ; set color map
 res2@lbLabelBarOn    = False                 ; will draw a panel label bar instead
 res2@gsnAddCyclic = False
  res2@mpMinLatF              = 15.0              ; map area
  res2@mpMaxLatF              = 60.0                ; latitudes
  res2@mpMinLonF              = 30.0              ; and
  res2@mpMaxLonF              = 120.0               ; longitudes
  res2@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
  res2@cnMinLevelValF       = -2000.0                ; set min contour level
  res2@cnMaxLevelValF       =  2000.0                ; set max contour level
  res2@cnLevelSpacingF      =  200               ; set contour spacing
 
 res2@tiMainString     = "maxCorr"          ; add title
  res2@gsnCenterString = maxCorr(n)
  res2@gsnLeftString = " "
  res2@gsnRightString= " "
 plots2(0) = gsn_csm_contour_map(wks,maxCorrVect(n,:,:), res2)

 res2@tiMainString     = "minCorr"          ; add title
  res2@gsnCenterString = minCorr(n)
  res2@gsnLeftString = " "
  res2@gsnRightString= " "
 plots2(1) = gsn_csm_contour_map(wks,minCorrVect(n,:,:), res2)

res2@tiMainString     = "maxDist"          ; add title
  res2@gsnCenterString = maxDist(n)
  res2@gsnLeftString = " "
  res2@gsnRightString= " "
 plots2(2) = gsn_csm_contour_map(wks,maxDistVect(n,:,:), res2)

 res2@tiMainString     = "minDist"          ; add title
  res2@gsnCenterString = minDist(n)
  res2@gsnLeftString = " "
  res2@gsnRightString= " "
 plots2(3) = gsn_csm_contour_map(wks,minDistVect(n,:,:), res2)

  res2@tiMainString     = "node"          ; add title
  res2@gsnCenterString =  numb_days(n)
  res2@gsnLeftString = avgDist(n)
  res2@gsnRightString= avgCorr(n)
; plots2(4) = gsn_csm_contour_map(wks,nodVects_end(l,w,:,:), res2)


;************************************************
; create panel
;************************************************
  resP                  = True                   ; modify the panel plot
  resP@gsnFrame         = False                  ; don't advance panel plot
  resP@gsnPanelLabelBar = True                   ; add common colorbar
  resP@gsnPanelMainString = "max min corr and dist plots"     ; set main title
 ; resP@gsnPanelBottom   = 0.05                   ; add space at bottom
 ; resP@gsnPanelFigureStrings= (/"a)","b)","c)"/) ; add strings to panel
  resP@amJust   = "TopLeft"
 ; gsn_panel(wks,plots2,(/3,2/),resP)               ; now draw as one plot

;frame(wks)

delete(wks)
delete(plots2)

end do

;;;;;;;;;;;;;;;;;;;; plot bar charts

 plot=new(mapsize,"graphic")
 fstations=ispan(0,5,1)
 wks = gsn_open_wks("png",fin+"Hbar")                  ; send graphics to PNG file

  resH                          = True
  resH@gsnDraw             = False            ; don't draw     
  resH@gsnFrame              = False                ; don't advance frame yet 
  resH@gsnMaximize              = True
  resH@gsnHistogramMinMaxBinsOn = True
  resH@gsnHistogramBinIntervals = (/1,3/)
    resH@trYMinF               = 0                    ; bring bars down to zero
    resH@trYMaxF               = 600                   ; bring bars down to zero
  resH@tmXBMode = "Explicit"
  resH@gsnHistogramComputePercentagesNoMissing= True

  ;data = (/1,1.5,2,2.5,5.5,7/)
 ; plot = gsn_histogram(wks,data,res)

 ; data := (/1,1,2,2,5,5,7,7/)
  ;plot = gsn_histogram(wks,data,res)



 ;plot=new(mapsize,"graphic")
 ;fstations=ispan(0,23,1)
 ;wks = gsn_open_wks("png",fin+"bar")                  ; send graphics to PNG file
  ;resB                       = True                 ; plot mods desired    
  ;resB@gsnDraw             = False            ; don't draw     
  ;resB@gsnFrame              = False                ; don't advance frame yet
  ;resB@gsnXYBarChart         = True                 ; turn on bar chart
  ;resB@gsnXYBarChartBarWidth = 0.75                 ; change bar widths

  ; resB@tmXBOn                = False                ; turn off tickmarks at bot
  ; resB@trYMinF               = 0                    ; bring bars down to zero
  ; resB@trYMaxF               = 20                    ; bring bars down to zero
  ;resB@trXMinF               = 0                    ; adds space on either end
  ;resB@trXMaxF               = 9                    ; of the 1st and last bars

do i=0,mapsize-1 
    stations_pat=new( numb_days(i),integer)
    ;stations_pat=0
      pat_no=0
   do n=0,dimsizes(stations)-1
      if(map(n).eq.i+1) then

         stations_pat(pat_no)=stations(n)
         pat_no=pat_no+1

      end if
   end do

;;;;;;;;;;; calculate frequency
;  print( stations_pat)
  staFrequency=new(5,integer)
  staFrequency=0
  do k=0,4
     do j=0,numb_days(i)-1
        if((.not. ismissing(stations_pat(j))) .and. k.eq.stations_pat(j))then

           staFrequency(k)=staFrequency(k)+1

        end if          
     end do    
  end do
  print(i)
  print(sum(staFrequency))
  ;plot(i) = gsn_csm_xy (wks,fstations,staFrequency,resB)                  ; create plot
  plot(i) = gsn_histogram (wks,stations_pat,resH)                  ; create plot

delete(stations_pat)
end do

;************************************************
; create panel
;************************************************
  resPB                  = True                   ; modify the panel plot
  resPB@gsnFrame         = False                  ; don't advance panel plot
 ; resPB@gsnPanelLabelBar = True                   ; add common colorbar
   gsn_panel(wks,plot,(/nodeRow,nodeColumn/),resPB)               ; now draw as one plot

frame(wks)




end do

   opt = True
   opt@fout = "interclust_val_summary.txt"
  write_matrix (interclust_corre_val, "3f12.4" , opt)

  opt = True
   opt@fout = "stat_vals_summary.txt"
   write_matrix (stat_vals_summary, "3f12.4" , opt)

end
