begin

nodeRow=4
nodeColumn=4

mapsize=nodeRow*nodeColumn

;;;;;;;;;;;;;; read input files

inFile=addfile("/home/iitm/Documents/Data/SOM_ERA_500_input/ERAANOM-1.5deg-500hPa-Dec-Jan-1979-2016_30-120E15-60N.nc","r")

z=inFile->z(:,:,:)

printVarSummary(z)
nlat=dimsizes(z&latitude)
nlon=dimsizes(z&longitude)

map=asciiread("map",-1,"integer")

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

;print(count_patterns)

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

nodVects_end=reshape(z_pat,(/nodeRow,nodeColumn,nlat,nlon/))


;;;;;;;;;;;;;; plot nodes/patterns

wks=gsn_open_wks ("png","cluster patterns")
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
  res@mpMinLatF              = 15.0              ; map area
  res@mpMaxLatF              = 60.0                ; latitudes
  res@mpMinLonF              = 30.0              ; and
  res@mpMaxLonF              = 120.0               ; longitudes
  res@cnLevelSelectionMode = "ManualLevels"     ; set manual contour levels
  res@cnMinLevelValF       = -2000.0                ; set min contour level
  res@cnMaxLevelValF       =  2000.0                ; set max contour level
  res@cnLevelSpacingF      =  200               ; set contour spacing
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


end
