begin


; read input data and its dimesions
inFile=addfile("/home/iitm/Documents/Data/SOM_ERA_500_input/ERAANOM-1.5deg-500hPa-Dec-Jan-1979-2016_30-120E15-60N.nc","r")
z_unfilt=inFile->z(:,:,:)
printVarSummary(z_unfilt)
ntime=dimsizes(z_unfilt&time)
nlat=dimsizes(z_unfilt&latitude)
nlon=dimsizes(z_unfilt&longitude)
printVarSummary(z_unfilt)

;;;;;;;;;filter data  to filter out frequency less than 21 days

  ihp   = 0                             ; low_pass
  sigma = 1.0                           ; Lanczos sigma

  nWgt  = 43                            ; loose 21 days each end                            
  fca   = 1./24.                        ; 21 days
  wgtq  = filwgts_lanczos (nWgt, ihp, fca, -999., sigma )

  
  z_old = wgt_runave ( z_unfilt, wgtq, -1 )   ; 21 days

copy_VarMeta(z_unfilt,z_old)

printVarSummary(z_old)
printVarSummary(z_unfilt)



;print(nlat)
;print(nlon)

;********** input Data should be two dimensional and time should be first dimension

z=reshape(z_old,(/ntime,nlat*nlon/))
printVarSummary(z)



;;;;;;;;; initialize nodes , no of iterations , initial learning rate, initial neigbourhood distance, time constant  etc
nodeRow=4
nodeColumn=3
iterations=10000
nodeArray=(/nodeRow,nodeColumn/)
in_nRadius=max(nodeArray)
timConstant=iterations/log(in_nRadius)
in_lRate=0.05
in_lRate2=0.5
nodes=nodeRow*nodeColumn

inputVectors=z
inputVectors!0="time"
inputVectors&time=z_old&time	
printVarSummary(inputVectors)



inputSize=dimsizes(inputVectors)
;print(inputSize(0))


;;;;;;;;;;;;;;;;;initialize node vectors
nodVects=new((/nodeRow,nodeColumn,inputSize(1)/),double)


    rseed1 = toint(systemfunc(" date +%s"))
    rseed2 = toint((12345l*rseed1)%2147483398l)
    random_setallseed(rseed1, rseed2)

initiVects   = todouble(random_normal(0.0, 1.0, (/nodes,inputSize(1)/)))
printVarSummary(initiVects)

nodVects=reshape(initiVects,(/nodeRow,nodeColumn,inputSize(1)/))
printVarSummary(nodVects)

;;;;;;;;;;;;;;;;;;;;;;;; define some variables later to plot

mapping=new((/inputSize(0),2/),integer)
nodeNums=new(inputSize(0),integer)

qerror=new(iterations,double)
qerror=todouble(0.0)

radi=new(iterations,float)
radi=0.0

learR=new(iterations,double)
learR=todouble(0.0)

distFun=new(iterations,double)
distFun=todouble(0.0)


;**************Loop for iterations
do iter=0,iterations-1
  
 ;;;;;;;;;;;;;; randomaly choose input for each iterations 
   rseed1 = toint(systemfunc(" date +%s"))
    rseed2 = toint((12345l*rseed1)%2147483398l)
    random_setallseed(rseed1, rseed2)

  inde= generate_sample_indices(inputSize(0),0)

 ;asciiwrite("ind"+iter,inde)
 

 
   
  ;******************Loop for each input vector
  do input=0,inputSize(0)-1
     ; print(inputVectors(input,:))
      ; ***************************Find bmu
          dist=todouble(0.0)
         ; printVarSummary(dist)
          minDistn=todouble(0.0)
          distInd=(/0,0/)
       do l=0,nodeRow-1
         do w=0,nodeColumn-1
          dist=dim_rmsd(nodVects(l,w,:),inputVectors(inde(input),:))
          
         ; print(dist)
          if(l.eq.0 .and. w.eq.0)then
           minDistn=dist
           distInd=(/0,0/)
           ;print("first if")
          ; print(minDistn)
          else
          if(dist.lt.minDistn) then
                 minDistn=dist
                 distInd=(/l,w/)
                 ;print("second if")
              end if
          end if
        end do  
          ;***************** Output
        if(iter.eq.iterations-1)then
           mapping(inde(input),:)=distInd
           nodeNums(inde(input))=distInd(0)*nodeColumn+distInd(1)
        end if  
       end do

       ;print(minDist)
       ;print(distInd)
    ;;;;;;;;;;; error for vector assignment    
           qerror(iter)=qerror(iter)+( dim_rmsd(nodVects(distInd(0),distInd(1),:),inputVectors(inde(input),:)))     


       ;******************************************* update BMU and neighbourhood
       
       nRadius=in_nRadius*exp(-(iter/timConstant))
   if( iter .lt. 1000) then
       lRate=in_lRate2*exp(-(todouble(iter)/iterations))
      ;printVarSummary(lRate)
 else 
  
       lRate=in_lRate*exp(-(todouble(iter)/iterations))
      
  end if    
       do l=0,nodeRow-1
         do w=0,nodeColumn-1
           dFun=todouble(0.0)
          BMU_dist=todouble(0.0)
          BMU_dist=dim_rmsd(nodVects(l,w,:),nodVects(distInd(0),distInd(1),:))
          if(BMU_dist.lt.nRadius) then
          dFun=exp(-((BMU_dist*BMU_dist)/(2.0*nRadius*nRadius)))
          nodVects(l,w,:)=nodVects(l,w,:)+dFun*lRate*(inputVectors(inde(input),:)- nodVects(l,w,:))
          end if
         end do
       end do
  end do
  ;print(iter)
   ;    print(nRadius)
    ;   print(lRate)

     ;;;;;;;;;;; radius of neighbourhood
           radi(iter)=nRadius
      ;;;;;;;;;;; learning rate
           learR(iter)=lRate
      ;;;;;;;;;;; distance function
           distFun(iter)=dFun


end do


;asciiwrite("map.txt",mapping)
asciiwrite("nodenums.txt",nodeNums)


;;;;;;;;;;;;;;;;;;;;; plot no of iterations vs distance function

  wks   = gsn_open_wks ("png","dfun")               ; send graphics to PNG file

 res                  = True                     ; plot mods desired
 res@tiMainString     = "no of iterations vs distance function  "          ; add title
 
 yiter=ispan(1,iterations,1)

; plot  = gsn_csm_xy (wks,yiter,distFun,res) ; create plot


;;;;;;;;;;;;;;;;;;;;; plot no of iterations vs learning Rate

  wks   = gsn_open_wks ("png","lRate")               ; send graphics to PNG file

 res                  = True                     ; plot mods desired
 res@tiMainString     = "no of iterations vs learning Rate  "          ; add title
 
 yiter=ispan(1,iterations,1)

 plot  = gsn_csm_xy (wks,yiter,learR,res) ; create plot




;;;;;;;;;;;;;;;;;;;;; plot no of iterations vs radius of neighbourhood 

  wks   = gsn_open_wks ("png","radius")               ; send graphics to PNG file

 res                  = True                     ; plot mods desired
 res@tiMainString     = "no of iterations vs radius of neighbourhood  "          ; add title
 
 yiter=ispan(1,iterations,1)

 plot  = gsn_csm_xy (wks,yiter,radi,res) ; create plot


;;;;;;;;;;;;;;;;;;;;; plot no of iterations vs quantization error 

  wks   = gsn_open_wks ("png","qerror")               ; send graphics to PNG file

 res                  = True                     ; plot mods desired
 res@tiMainString     = "no of iterations vs quantization error "          ; add title
 
 yiter=ispan(1,iterations,1)

 plot  = gsn_csm_xy (wks,yiter,qerror,res) ; create plot



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;plotting section


;;;;;;;;;;;;;; plot nodes/patterns

 nodVects_end=reshape(nodVects,(/nodeRow,nodeColumn,nlat,nlon/))
 printVarSummary( nodVects_end)

wks=gsn_open_wks ("png","cluster patterns")
plots=new(nodes,graphic)

iter=0
     do l=0,nodeRow-1
         do w=0,nodeColumn-1
 ;print(iter)
 ;print(w)
 ;print(l)
 copy_VarMeta(z_old(0,:,:),nodVects_end(l,w,:,:))
 ;printVarSummary(nodVects_end(l,w,:,:))

 res                  = True                     ; plot mods desired
 res@tiMainString     = "Pattern "+l+","+w         ; add title
 res@gsnDraw             = False            ; don't draw
  res@gsnFrame            = False            ; don't advance frame
 
  res@cnFillOn        = True                    ; turn on color 
 res@cnFillPalette   = "BlueRed"           ; set color map
 res@lbLabelBarOn    = False                 ; will draw a panel label bar instead
 res@gsnAddCyclic = False
  res@mpMinLatF              = 15.0              ; map area
  res@mpMaxLatF              = 60.0                ; latitudes
  res@mpMinLonF              = 30.0              ; and
  res@mpMaxLonF              = 120.0               ; longitudes
  res@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
  res@cnMinLevelValF       = -2000.0                ; set min contour level
  res@cnMaxLevelValF       =  2000.0                ; set max contour level
  res@cnLevelSpacingF      =  200               ; set contour spacing
 plots(iter) = gsn_csm_contour_map(wks,nodVects_end(l,w,:,:), res)
  iter=iter+1
   end do
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




nodVects_singleInd=reshape(nodVects,(/nodeRow*nodeColumn,inputSize(1)/))
maxCorr=new(nodes,"double")
minCorr=new(nodes,"double")
maxDist=new(nodes,"double")
minDist=new(nodes,"double")
avgCorr=new(nodes,"double")
avgDist=new(nodes,"double")
numb_days=new(nodes,"integer")
stat_vals=new((/nodes,6/),"double")

maxCorrVect=new((/nodes,nlat,nlon/),"double")
minCorrVect=new((/nodes,nlat,nlon/),"double")
maxDistVect=new((/nodes,nlat,nlon/),"double")
minDistVect=new((/nodes,nlat,nlon/),"double")

 do n=0,nodes-1 
 ;;;;;;;;;;;;count number of vectors associated with each node
     numb=0 
    do input=0,inputSize(0)-1
      if(nodeNums(input).eq.n) then
      numb=numb+1    
      end if 
    end do
    numb_days(n)=numb
;;;;;;;;;;;;Find out max and min corr and dist vals
     cor_val=new(numb,"double",0.00000000000)
     dist_val=new(numb,"double",0.00000000000)
     cor_val_ind=new(numb,"integer")
     dist_val_ind=new(numb,"integer")
     index=0
    do input=0,inputSize(0)-1
      if(nodeNums(input).eq.n) then
      cor_val(index)=esccr(nodVects_singleInd(nodeNums(input),:),inputVectors(input,:),0)
      dist_val(index)=dim_rmsd(nodVects_singleInd(nodeNums(input),:),inputVectors(input,:))
      cor_val_ind(index)=input
      dist_val_ind(index)=input
       index=index+1
      end if 
       
     end do

maxCorr(n)=max(cor_val)
minCorr(n)=min(cor_val)
maxDist(n)=max(dist_val)
minDist(n)=min(dist_val)
avgDist(n)=avg(dist_val)
avgCorr(n)=avg(cor_val)

stat_vals(n,0)=maxCorr(n)
stat_vals(n,1)=minCorr(n)
stat_vals(n,2)=avgCorr(n)
stat_vals(n,3)=maxDist(n)
stat_vals(n,4)=minDist(n)
stat_vals(n,5)=avgDist(n)

  
maxCorrVect(n,:,:)=z_old(cor_val_ind(maxind(cor_val)),:,:)
minCorrVect(n,:,:)=z_old(cor_val_ind(minind(cor_val)),:,:)
maxDistVect(n,:,:)=z_old(cor_val_ind(maxind(dist_val)),:,:)
minDistVect(n,:,:)=z_old(cor_val_ind(minind(dist_val)),:,:)

    delete(cor_val)
     delete(dist_val)
     delete(cor_val_ind)
     delete(dist_val_ind)

 end do


;asciiwrite("maxCorr.txt",maxCorr)
;asciiwrite("minCorr.txt",minCorr)
;asciiwrite("avgCorr.txt",avgCorr)

;asciiwrite("maxDist.txt",maxDist)
;asciiwrite("minDist.txt",minDist)
;asciiwrite("avgDist.txt",avgDist)
asciiwrite("numb_days.txt",numb_days)


   opt = True
   opt@fout = "stat_vals.txt"
   write_matrix (stat_vals, "15f12.4" , opt)

;asciiwrite("stat_vals.txt",stat_vals)

;;;;;;;;;;;;;; plot maxDist minDist and maxCor and minCor plots

do n=0,nodes-1 

w=mod(n,nodeColumn)
 l=toint(n/nodeColumn)
 ;print(iter)
 ;print(w)
 ;print(l)
 copy_VarMeta(z_old(0,:,:),nodVects_end(l,w,:,:))

wks=gsn_open_wks ("png","max_min_cor_dist_plots"+n)
plots2=new(5,graphic)



 res                  = True                     ; plot mods desired
 res@gsnDraw             = False            ; don't draw
  res@gsnFrame            = False            ; don't advance frame
 
  res@cnFillOn        = True                    ; turn on color 
 res@cnFillPalette   = "BlueRed"           ; set color map
 res@lbLabelBarOn    = False                 ; will draw a panel label bar instead
 res@gsnAddCyclic = False
  res@mpMinLatF              = 15.0              ; map area
  res@mpMaxLatF              = 60.0                ; latitudes
  res@mpMinLonF              = 30.0              ; and
  res@mpMaxLonF              = 120.0               ; longitudes
  res@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
  res@cnMinLevelValF       = -2000.0                ; set min contour level
  res@cnMaxLevelValF       =  2000.0                ; set max contour level
  res@cnLevelSpacingF      =  200               ; set contour spacing
 
 res@tiMainString     = "maxCorr"          ; add title
  res@gsnCenterString = maxCorr(n)
 plots2(0) = gsn_csm_contour_map(wks,maxCorrVect(n,:,:), res)

 res@tiMainString     = "minCorr"          ; add title
  res@gsnCenterString = minCorr(n)
 plots2(1) = gsn_csm_contour_map(wks,minCorrVect(n,:,:), res)

res@tiMainString     = "maxDist"          ; add title
  res@gsnCenterString = maxDist(n)
 plots2(2) = gsn_csm_contour_map(wks,maxDistVect(n,:,:), res)

 res@tiMainString     = "minDist"          ; add title
  res@gsnCenterString = minDist(n)
 plots2(3) = gsn_csm_contour_map(wks,minDistVect(n,:,:), res)

  res@tiMainString     = "node"          ; add title
  res@gsnCenterString =  numb_days(n)
  res@gsnLeftString = avgDist(n)
  res@gsnRightString= avgCorr(n)
 plots2(4) = gsn_csm_contour_map(wks,nodVects_end(l,w,:,:), res)


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
  gsn_panel(wks,plots2,(/3,2/),resP)               ; now draw as one plot

frame(wks)

delete(wks)
delete(plots2)

end do




end
