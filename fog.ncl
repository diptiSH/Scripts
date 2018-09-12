begin


;;;;;;;;;input file list array;;;;;;;;;;;;;

flist=(/"5219" , "42071" , "42101" , "42103" , "42131" , "42137" , "42148" , "42176" , "42181" , "42182" , "42266" , "42270" , "42271" , "42273" , "42369" , "42375" , "42379" , "42387" , "42471" , "42475" , "42479" , "42482" , "42483" , "42484" , "42492" , "42591"/)

;print(flist)

;print(dimsizes(flist))

nofiles=dimsizes(flist)

noyears=35       ;; 1979-2013
nomonths=2     ;; jan and dec
nodays=31

;;;;;;;;;;;;;;;;; define fog data ;;;;;;;;;;;;;

fogdata=new((/nofiles,noyears,nomonths,nodays/),"integer",9)

fogdata!0 = "station"
fogdata!1 = "year"
fogdata!2 = "month"
fogdata!3 = "day"

fogdata&station=stringtointeger(flist)
fogdata&year=ispan(1979,2013,1)
fogdata&month=(/1,12/)
fogdata&day=ispan(1,31,1)

printVarSummary(fogdata)

print(fogdata&station)
;;;;;;;;;;;;;;;;;;;; read each file sequentially ;;;;;;;;;;;;;


do i=0,nofiles-1

fname="/media/New Volume/DATA/IMD_Data/daily_imd_statio2/"+flist(i)+".txt"

print(fname)

data=asciiread(fname,-1,"string")

;print(data)

st=stringtointeger(str_get_cols(data,0,4))
yr=stringtointeger(str_get_cols(data,6,9))                          
mon=stringtointeger(str_get_cols(data,11,12))
dy=stringtointeger(str_get_cols(data,14,15))  
fog=stringtointeger(str_get_cols(data,94,95))

recno=dimsizes(st)

;;;;;;;;;;;;;;;;;;;;; get fog data ;;;;;;;;;

do j=0,recno-1
;print(recno+1)
;print(st(j))
;print(yr(j))
;print(mon(j))
;print(dy(j))

if(yr(j).lt.2014 .and. (mon(j).eq.1 .or. mon(j).eq.12))then


;print(fogdata({5219}, {1980}, {12} ,{1} ))

fogdata({st(j)}, {yr(j)}, {mon(j)} ,{dy(j)} ) = (/fog(j)/)
;print(fogdata({st(j)}, {yr(j)}, {mon(j)} ,{dy(j)} ))

end if

end do

;print(fog)
delete(data)
delete(st)
delete(yr)
delete(mon)
delete(dy)
delete(fog)

end do

;asciiwrite("fogmat.txt",fogdata)


;;;;;;;;;;;;;;;;; count days when more than 9 stations reported fog

mthan9days=0

do i=0,noyears-1
  do j=0,nomonths-1
     do k=0,nodays-1
         
         if(sum(fogdata(:,i,j,k)) .gt. 9 ) then
            mthan9days=mthan9days+1
            print(fogdata&year(i)+"  "+fogdata&month(j)+"  "+fogdata&day(k))
         end if

     end do
  end do
end do


print(mthan9days)


;fogWrite=new((/noyears*nomonths*nodays,nofiles/),typeof(fogdata))

fogWrite=reshape(fogdata(year|:,month|:,day|:,station|:),(/noyears*nomonths*nodays,nofiles/))

printVarSummary(fogWrite)


fogdays=new(mthan9days,"string")
foggyStations=new(noyears*nomonths*nodays,integer,0)

in=0
fin=0

do i=0,noyears-1
  do j=0,nomonths-1
     do k=0,nodays-1
         foggyStations(fin)=sum(fogdata(:,i,j,k))
         fin=fin+1
         if(sum(fogdata(:,i,j,k)) .gt. 9 ) then
            fogdays(in)=fogdata&year(i)+"-"+fogdata&month(j)+"-"+fogdata&day(k)
           ; print(fogdata&year(i)+"  "+fogdata&month(j)+"  "+fogdata&day(k))
            in=in+1
         end if

     end do
  end do
end do

asciiwrite("foggyStations.txt",foggyStations)
asciiwrite("fogdays.txt",fogdays)

print(fogdata(:,{1980},{12},{1}))


   opt        = True
  opt@fout = "fog_matrix.txt"
  write_matrix (fogWrite, "26I2", opt)
 

 



end
