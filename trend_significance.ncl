begin

fin=addfile("/home/iitm/Documents/ncdc_data_anal/4station_analysis/Station_fog_data.nc","r")
yyStrt=1980
yyLast=2016

fogdata=fin->fogdata
nostations=dimsizes(fogdata(:,0,0,0))
year_list=ispan(yyStrt,yyLast,1)
nyrs=dimsizes(year_list)

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
   do year=yyStrt,yyLast
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


;-----------------------------------------------------
; Calculate regression and Mann-Kendall trend 
;-----------------------------------------------------

              trend_val_0 = regline(year_list,seasonalVal(0,:))
               p_val_0  = trend_manken(seasonalVal(0,:), False, 0)              

            trend_val_1 = regline(year_list,seasonalVal(1,:))
               p_val_1  = trend_manken(seasonalVal(1,:), False, 0)     
            
            trend_val_2 = regline(year_list,seasonalVal(2,:))
               p_val_2  = trend_manken(seasonalVal(2,:), False, 0) 


            trend_val_3 = regline(year_list,seasonalVal(3,:))
               p_val_3  = trend_manken(seasonalVal(3,:), False, 0)     
            
            trend_val_4 = regline(year_list,seasonalVal(4,:))
               p_val_4  = trend_manken(seasonalVal(4,:), False, 0)     



;-----------------------------------------------------
; Store for plotting
;-----------------------------------------------------

printVarSummary(trend_val_4)
printVarSummary(seasonalVal)

 dplt     = new ( (/nostations+1,3,nyrs/), typeof(trend_val_4), trend_val_4@_FillValue)
  
       
               dplt(0,0,:) =tofloat(seasonalVal(0,:))
               dplt(0,1,:) = trend_val_0*(year_list - trend_val_0@xave) + trend_val_0@yave
               dplt(0,2,:) = p_val_0(1)*(year_list - trend_val_0@xave) + trend_val_0@yave
            
               dplt(1,0,:) =tofloat(seasonalVal(1,:))
               dplt(1,1,:) = trend_val_1*(year_list - trend_val_1@xave) + trend_val_1@yave
               dplt(1,2,:) = p_val_1(1)*(year_list - trend_val_1@xave) + trend_val_1@yave

                dplt(2,0,:) =tofloat(seasonalVal(2,:))
               dplt(2,1,:) = trend_val_2*(year_list - trend_val_2@xave) + trend_val_2@yave
               dplt(2,2,:) = p_val_2(1)*(year_list - trend_val_2@xave) + trend_val_2@yave

               dplt(3,0,:) =tofloat(seasonalVal(3,:))
               dplt(3,1,:) = trend_val_3*(year_list - trend_val_3@xave) + trend_val_3@yave
               dplt(3,2,:) = p_val_3(1)*(year_list - trend_val_3@xave) + trend_val_3@yave

               dplt(4,0,:) =tofloat(seasonalVal(4,:))
               dplt(4,1,:) = trend_val_4*(year_list - trend_val_4@xave) + trend_val_4@yave
               dplt(4,2,:) = p_val_4(1)*(year_list - trend_val_4@xave) + trend_val_4@yave



;-----------------------------------------------------
; plot resources
;-----------------------------------------------------
  plot = new (nostations+1, "graphic")

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
 ;res@trYMinF             = -0.6      
 ;res@trYMaxF             =  0.6
 ;res@gsnYRefLine         =  0.0

  txres                   =  True
  txres@txFontHeightF     =  0.02
  txres@txJust            = "CenterLeft"
  txres@txFontThicknessF  =  2.0      ; default=1.00
  txres@txFontHeightF     =  0.025    ; default=0.05

  res@gsnCenterString     = " No fog (0 stations)"
  plot(0) = gsn_csm_xy (wks,year_list,dplt(0,:,:),res)           ; create plot
  text    = "p="+sprintf("%5.3f",p_val_0(0))+"  trend="+sprintf("%5.3f",p_val_0(1))+" days/year"
  txt_0 = gsn_add_text(wks,plot(0),text, 1981, 2.0,txres)

  res@gsnCenterString     = "1 station"
  plot(1) = gsn_csm_xy (wks,year_list,dplt(1,:,:),res)           ; create plot
  text    = "p="+sprintf("%5.3f",p_val_1(0))+"  trend="+sprintf("%5.3f",p_val_1(1))+" days/year"
  txt_1 = gsn_add_text(wks,plot(1),text, 1981,5.0,txres)


  res@gsnCenterString     = "2 stations"
  plot(2) = gsn_csm_xy (wks,year_list,dplt(2,:,:),res)           ; create plot
  text    = "p="+sprintf("%5.3f",p_val_2(0))+"  trend="+sprintf("%5.3f",p_val_2(1))+" days/year"
  txt_2 = gsn_add_text(wks,plot(2),text, 1981, 7.0,txres)

   res@gsnCenterString     = "3 stations"
  plot(3) = gsn_csm_xy (wks,year_list,dplt(3,:,:),res)           ; create plot
  text    = "p="+sprintf("%5.3f",p_val_3(0))+"  trend="+sprintf("%5.3f",p_val_3(1))+" days/year"
  txt_3 = gsn_add_text(wks,plot(3),text, 1990, 1.5,txres)



    res@gsnCenterString     = "4 stations"
  plot(4) = gsn_csm_xy (wks,year_list,dplt(4,:,:),res)           ; create plot
  text    = "p="+sprintf("%5.3f",p_val_4(0))+"  trend="+sprintf("%5.3f",p_val_4(1))+" days/year"
  txt_4 = gsn_add_text(wks,plot(4),text, 1985,-5.0 ,txres)


;************************************************
; create panel
;************************************************
  resP = True
  resP@gsnMaximize           = True
  resP@gsnPanelMainString    = "Days per year (Dec-Jan)"
  gsn_panel(wks,plot,(/3,2/),resP)               ; now draw as one plot






end
