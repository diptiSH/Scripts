begin
fold="/home/iitm/Documents/Data/daily_imd_statio2/"
fin=(/"5219.txt" , "42071.txt" ,"42101.txt", "42103.txt" , "42131.txt" , "42137.txt" , "42148.txt" , "42176.txt" , "42181.txt" , "42182.txt" , "42266.txt" , "42270.txt" , "42271.txt" , "42273.txt" , "42369.txt" , "42375.txt" , "42379.txt" , "42471.txt" , "42475.txt" , "42479.txt" , "42482.txt" , "42483.txt" , "42492.txt" , "42591.txt"   /)

nostations=dimsizes(fin)
noyears=38       ;; 1979-2016
nomonths=2     ;; jan and dec
nodays=31

fogdata=new((/nostations,noyears,nomonths,nodays/),"integer",9)
;printVarSummary(fogdata)

fogdata!0 = "stations"
fogdata!1 = "years"
fogdata!2 = "months"
fogdata!3 = "days"

fogdata&stations=(/5219 , 42071 ,42101, 42103 , 42131 , 42137 , 42148 , 42176 , 42181 , 42182 , 42266 , 42270 , 42271 , 42273 , 42369 , 42375 , 42379 , 42471 , 42475 , 42479 , 42482 , 42483 , 42492 , 42591 /)
fogdata&years=ispan(1979,2016,1)
fogdata&months=(/1,12/)
fogdata&days=ispan(1,31,1)


printVarSummary(fogdata)

do f=0,dimsizes(fin)-1

stationName=fogdata&stations(f)

;print(stationName)



data=asciiread(fold+fin(f),-1,"string")

;print(data)


delim=" "              ; deliminator can be "," , "-" or " " etc

year=stringtoint(str_get_field(data,2,delim))
month=stringtoint(str_get_field(data,3,delim))
day=stringtoint(str_get_field(data,4,delim))

fogInd=stringtoint(str_get_cols(data,95,95))

print(fogInd)






;;;;;;;;;;loop for each data row
do r=0,dimsizes(year)-1      
  
 ;;;;;;;; loop for year
    do y=1979,2016
         
       if(year(r).eq.y)then
            
         ;;;;;;;;;;;;;; loop for month
             do m=1,2
               

               if(m.eq.1 .and. month(r).eq.m) then
                   mn=1
                    ;;;;;;;;;;;; loop for day
                      do d=1,31
                         if(d.eq.day(r)) then
                           ; printVarSummary(fogdata)
                              ;  print(r)
                           ; fogdata(y-1979,m-1,d-1)=(/fogInd(r)/)
                            ;     print( fogdata(y-1979,m-1,d-1))
                             fogdata(f,{y},{mn},{d})=(/fogInd(r)/)
                               ;  print( fogdata(y-1979,m-1,d-1))
                          
                        end if
                       end do
               else
                  if(m.eq.2 .and. month(r).eq.12) then
                    mn=12

             ;;;;;;;;;;;; loop for day
                      do d=1,31
                          
                        if(d.eq.day(r)) then
                           ; printVarSummary(fogdata)
                              ;  print(r)
                           ; fogdata(y-1979,m-1,d-1)=(/fogInd(r)/)
                            ;     print( fogdata(y-1979,m-1,d-1))
                             fogdata(f,{y},{mn},{d})=(/fogInd(r)/)
                               ;  print( fogdata(y-1979,m-1,d-1))
                          
                        end if

                      end do

                  end if
  
               end if     

             end do

       end if
   
    end do

end do

 
delete(data)
delete(fogInd)
delete(year)
delete(month)
delete(day)
delete(stationName)

end do

  ncdf = addfile("IMDStation_fog_data_24.nc" ,"c")  ; open output netCDF file

  ncdf->fogdata  = fogdata      


 ;;;;;;;;;;;; calculate missing percentage
 perMissing=new(nostations,float) 
 do r=0,nostations-1  

   station=fogdata&stations(r)
   cntMissing = num(ismissing(fogdata({station},:,:,:)))
   perMissing(r)=((cntMissing*100.0)/(noyears*nomonths*nodays))
   print(station+"  "+perMissing(r))
   delete(cntMissing)
 end do 
                  ; 4D     

end
