begin
fold="/home/iitm/Documents/Data/ncdc_July_18/"
fin=(/"42071_Amritsar.txt","42101_Patiala.txt","42103_Ambala.txt" ,"42131_Hissar.txt" , "42182_Safdarjung.txt" , "42273_BAHRAICH.txt" , "42369_Lucknow.txt" , "42379_Gorakhpur.txt" , "42475_Allahabad.txt", "42479_Varanasi.txt" , "42492_Patna.txt", "42591_Gaya.txt" /)

nostations=dimsizes(fin)
noyears=38       ;; 1979-2016
nomonths=2     ;; jan and dec
nodays=31

fogdata=new((/nostations,noyears,nomonths,nodays/),"integer",9)
;printVarSummary(fogdata)

fogdata!0 ="stations"
fogdata!1 ="years"
fogdata!2 ="months"
fogdata!3 ="days"

fogdata&stations=(/42071 ,42101, 42103 , 42131 , 42182, 42273 , 42369, 42379 ,42475 , 42479 , 42492, 42591 /)
fogdata&years=ispan(1979,2016,1)
fogdata&months=(/1,12/)
fogdata&days=ispan(1,31,1)


printVarSummary(fogdata)

do f=0,dimsizes(fin)-1

stationName=fogdata&stations(f)

;print(stationName)



data=asciiread(fold+fin(f),-1,"string")

delim=","              ; deliminator can be"," ,"-" or"" etc

wxIndex=(str_get_field(data, 22, delim)) ; str_get_field is used to get each field seperated by deliminator
Date=(str_get_field(data, 3, delim))

;printVarSummary(data)
;print(wxIndex)
;printVarSummary(wxIndex)

fogInd=stringtoint(str_get_cols(wxIndex,0,1))
year=stringtoint(str_get_cols(Date,0,4))
month=stringtoint(str_get_cols(Date,5,6))
day=stringtoint(str_get_cols(Date,7,8))


;;;;;;;;;;loop for each data row
do r=1,dimsizes(year)-1       ;;;;;;;;;;;;;r starting from 1 as first row is string
  
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
delete(wxIndex)
delete(Date)
delete(fogInd)
delete(year)
delete(month)
delete(day)
delete(stationName)

end do

  ncdf = addfile("NCDCStation_fog_data_24.nc" ,"c")  ; open output netCDF file

  ncdf->fogdata  = fogdata                        ; 4D   


 ;;;;;;;;;;;; calculate missing percentage
 perMissing=new(nostations,float) 
 do r=0,nostations-1  

   station=fogdata&stations(r)
   cntMissing = num(ismissing(fogdata({station},:,:,:)))
   perMissing(r)=((cntMissing*100.0)/(noyears*nomonths*nodays))
   print(station+"  "+perMissing(r))
   delete(cntMissing)
 end do   

end
