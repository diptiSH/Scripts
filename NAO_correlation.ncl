begin

avg_inv = asciiread("Area_avg_inv_IGP_lt_500m.txt",-1,"float")

;print(avg_inv)


fog_dates = asciiread("fog_date.txt",-1,"string")
;print(fog_dates)


nao =readAsciiTable("/home/iitm/Documents/Data/Various_indices/NAO.txt", 4, "float", 0)
printVarSummary(nao)
;print(nao);(20752,:))


;*********************** get inv ts
;*********************** Dec treated as month 2

;printVarSummary(avg_inv)
inv_ts=new(22,"float")
  ep=0
do en=0,21
        yr=stringtointeger(str_get_cols(fog_dates(en),0,3))
        mn=stringtointeger(str_get_cols(fog_dates(en),5,6))
        da=stringtointeger(str_get_cols(fog_dates(en),8,9))
        ;print(yr)
        ;print(mn)
        ;print(da)
         i=0
	do year=1979,2013
        
		 if(year .eq. 2013) then
		    mon=1
		  else
		    mon=2
		 end if

		 do month=1,mon
			do day=1,31
				 ;print(i)
				; if(i .lt. 2139) then
				; print(avg_inv(i))
			       ; end if

			       if (year .eq. yr) then
				  if (month .eq. mn) then
				      if (day .eq. da) then
				         print(day)
				         inv_ts(ep)=avg_inv(i)
				      end if
				  end if
			       end if

		        	i=i+1
		          
			end do
		 end do

	end do
     ep=ep+1  
 end do
;print(inv_ts)


;*************************** provide nao as per lag/lag -4 to +4 required to get correlation 
;*********************** get nao ts

rc=new(9,"float")

do lag=-4,4

nao_ts=new(22,"float")
  ep=0
do en=0,21
        yr=stringtointeger(str_get_cols(fog_dates(en),0,3))
        mn=stringtointeger(str_get_cols(fog_dates(en),5,6))
        da=stringtointeger(str_get_cols(fog_dates(en),8,9))
        ;print(yr)
        ;print(mn)
        if(mn .eq. 2) then
        mn = 12
        end if
        ;print(da)
        do i=0,24744
         if((yr .eq. nao(i,0)) .and. (mn .eq. nao(i,1)) .and. (da .eq. nao(i,2))) then
         ;print(da)     
          nao_ts(ep)=nao(i+lag,3)
         end if

        end do       
	
     ep=ep+1  
 end do
;print(nao_ts)

;******correlation

rc(lag+4)=escorc(inv_ts,nao_ts)
;rc=regCoef(inv_ts,nao_ts)

;print(lag)
;print(rc)

end do

print(rc)

end
