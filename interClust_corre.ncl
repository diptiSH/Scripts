begin
nodeRow=2
nodeColumn=2
nodes=nodeRow*nodeColumn

inFile=addfile("/home/iitm/Documents/Data/SOM_ERA_500_input/ERAANOM-1.5deg-500hPa-Dec-Jan-1979-2016_30-120E15-60N.nc","r")
z=inFile->z
printVarSummary(z)

runs=5

interclust_corre_val=new((/runs,3/),double)


do irun=0,runs-1

;;;;;;;;;;;;;Read input file that contains pattern numbers

map=asciiread(irun+"nodenums.txt",-1,"integer")

;print(map)

;;;;;;;;;;;;;;;;;;;;; get count of days in each pattern
nodePatCnt=new(nodes,"integer")
nodePatCnt=0

do i=0,dimsizes(map)-1

  do j=0,nodes-1
          if(map(i).eq.j) then
                   nodePatCnt(j)=nodePatCnt(j)+1
          end if
  end do 

end do

print(nodePatCnt)


;;;;;;;;;;;;;;; get node vectors
nodeVects=new((/nodes,dimsizes(z(0,:,0)),dimsizes(z(0,0,:))/),typeof(z))
printVarSummary(nodeVects)

do j=0,nodes-1

  nodeDays=new((/ nodePatCnt(j),dimsizes(z(0,:,0)),dimsizes(z(0,0,:))/),typeof(z))

       in=0
  do i=0,dimsizes(map)-1
       if(map(i).eq.j) then
          nodeDays(in,:,:)=z(i,:,:)
           in=in+1
       end if
  end do
  nodeVects(j,:,:)=dim_avg_n_Wrap(nodeDays,0)
  delete(nodeDays)

end do

printVarSummary(nodeVects)

;;;;;;;;;;;;; calculate intercluster correlations

interClust_mat=new(nodes*nodes,typeof(z))

in=0
do i=0,nodes-1
  do j=0,nodes-1
  if(i.ne.j) then
   
  interClust_mat(in)=pattern_cor(nodeVects(i,:,:),nodeVects(j,:,:),1.0,0)
  
  end if
  in=in+1
  end do
end do

print(interClust_mat)

interclust_corre_val(irun,0)=min(interClust_mat)
interclust_corre_val(irun,1)=max(interClust_mat)
interclust_corre_val(irun,2)=avg(get_unique_values(interClust_mat))


;print(min_corre_val(irun)+"   "+max_corre_val(irun)+"  "+avg_corre_val(irun))

end do

   opt = True
   opt@fout = "interclust_val_summary.txt"
   write_matrix (interclust_corre_val, "3f12.4" , opt)

exit

;;;;;;;;;;;;;;;;;;;;;;;;;; plot clusters
wks=gsn_open_wks ("png","cluster patterns_2method")
plots=new(nodes,graphic)

do j=0,nodes-1
res                  = True                     ; plot mods desired
 res@tiMainString     = "Pattern "+j        ; add title
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
 plots(j) = gsn_csm_contour_map(wks,nodeVects(j,:,:), res)
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

end
