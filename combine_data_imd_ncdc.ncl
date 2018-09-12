begin

;;;;;;;;; input files
fIMD=addfile("IMDStation_fog_data_24.nc","r")
fNCDC=addfile("NCDCStation_fog_data_24.nc","r")


imdFog=fIMD->fogdata
ncdcFog=fNCDC->fogdata

printVarSummary(imdFog)
printVarSummary(ncdcFog)


imdStations=imdFog&stations
ncdcStations=ncdcFog&stations



combine_st = array_append_record (imdStations, ncdcStations, 0)
print(combine_st)


stations_uq=get_unique_values(combine_st)
;print(stations_uq)
;print(imdStations)
;print(ncdcStations)

;exit

nostations=dimsizes(stations_uq)
noyears=38       ;; 1979-2016
nomonths=2     ;; jan and dec
nodays=31

fogdata=new((/nostations,noyears,nomonths,nodays/),"integer",9)
;printVarSummary(fogdata)

fogdata!0 = "stations"
fogdata!1 = "years"
fogdata!2 = "months"
fogdata!3 = "days"

fogdata&stations=stations_uq
fogdata&years=ispan(1979,2016,1)
fogdata&months=(/1,12/)
fogdata&days=ispan(1,31,1)


printVarSummary(fogdata)

;;;;;;;;;;;;;;;;;;;;;;  decide data present in imd or ncdc or both datasets for station
 ncdcflag=new(nostations,integer)
 ncdcflag=0
 imdflag=new(nostations,integer)
 imdflag=0
 bothflag=new(nostations,integer)
 bothflag=0
;;;;;;;;;;loop for each station
do r=0,nostations-1  

 station=stations_uq(r)
 
 ;;;;;;;;;;;;;; chk if ncdc have this station
   do s=0,dimsizes(imdFog(:,0,0,0))-1
      if(station.eq.imdStations(s))then
         imdflag(r)=1
      end if
   end do
 ;;;;;;;;;;;;;; chk if imd have this station
    do s=0,dimsizes(ncdcFog(:,0,0,0))-1
      if(station.eq.ncdcStations(s))then
         ncdcflag(r)=1
      end if
   end do 

 ;;;;;;;;;;;;;; chk if imd and ncdc both have this station
 if(imdflag(r).eq.1 .and. ncdcflag(r).eq.1)then
         bothflag(r)=1
 end if
 
; print(station+"  imdflag= "+imdflag(r)+"  ncdcflag= "+ncdcflag(r)+"  bothflag= "+bothflag(r))
 
end do  
 

;;;;;;;;;;;;;; Combine data

;;;;;;;;;;loop for each station
do r=0,nostations-1 
 st=stations_uq(r) 
 
 conflict_cnt=0
 ;;;;;;;; loop for year
  do y=1979,2016
      ;;;;;;;;;;;; loop for day
      do d=1,31

          ;;;;;;;;;;;;;; loop for month
          do m=1,2
              if(m.eq.1) then
                   mn=1
              else
                   mn=12
              end if

              ;;;;;;;;; if both data sets have data
               ; print(st)
              if(bothflag(r).eq.1 )then
                 if(.not.ismissing(imdFog({st},{y},{mn},{d}))  .and. (.not.ismissing(ncdcFog({st},{y},{mn},{d}))))then
					  ;;;;;;;;;;;;;; if datasets have conflict
					  if(imdFog({st},{y},{mn},{d}) .ne. ncdcFog({st},{y},{mn},{d}))then
						;print(y+"-"+mn+"-"+d+"  "+st+"  imd  "+imdFog({st},{y},{mn},{d})+"  ncdc  "+ncdcFog({st},{y},{mn},{d}))
						conflict_cnt=conflict_cnt+1
						fogdata({st},{y},{mn},{d})=imdFog({st},{y},{mn},{d})      ; if data have conflict use imd data
					  else
						 fogdata({st},{y},{mn},{d}) = imdFog({st},{y},{mn},{d})
					  end if 
					  else
					   ;;;;;;;;;;;;;;; if only imd dataset have data
					   if((imdflag(r).eq.1) .and.(.not.ismissing(imdFog({st},{y},{mn},{d})))  .and. bothflag(r).eq.1)then
                       fogdata({st},{y},{mn},{d}) = imdFog({st},{y},{mn},{d})
                       end if
                       ;;;;;;;;;;;;;;;;; if only ncdc dataset have data  
                       if(  (ncdcflag(r).eq.1) .and.(.not.ismissing(ncdcFog({st},{y},{mn},{d})))  .and. bothflag(r).eq.1)then
                         fogdata({st},{y},{mn},{d}) = ncdcFog({st},{y},{mn},{d})
                       end if    
                      
                  end if
                 
               else
               ;;;;;;;;;;;;;;; if only imd dataset have data
                   ; print(r+" "+st+" "+y+"-"+mn+"-"+d)
                    if((imdflag(r).eq.1) .and.(.not.ismissing(imdFog({st},{y},{mn},{d})))  .and. bothflag(r).eq.0 )then
                       fogdata({st},{y},{mn},{d}) = imdFog({st},{y},{mn},{d})
                    end if
               
               ;;;;;;;;;;;;;;;;; if only ncdc dataset have data  
                    if(  (ncdcflag(r).eq.1) .and.(.not.ismissing(ncdcFog({st},{y},{mn},{d})))  .and. bothflag(r).eq.0)then
                         fogdata({st},{y},{mn},{d}) = ncdcFog({st},{y},{mn},{d})
                    end if             

               end if
                
          end do
 
      end do
  end do

print(stations_uq(r)+"  conflict count = "+conflict_cnt)

end do


  ncdf = addfile("CombineStation_fog_data_24.nc" ,"c")  ; open output netCDF file

  ncdf->fogdata  = fogdata                        ; 4D     
  
  
 ;;;;;;;;;;;; calculate missing percentage
 perMissing=new(nostations,float) 
 do r=0,nostations-1  

   station=stations_uq(r)
   cntMissing = num(ismissing(fogdata({station},:,:,:)))
   perMissing(r)=((cntMissing*100.0)/(noyears*nomonths*nodays))
   print(station+"  "+perMissing(r))
   delete(cntMissing)
 end do 


end
