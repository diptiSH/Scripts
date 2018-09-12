begin

fin=addfile("Station_fog_data.nc","r")


fogdata=fin->fogdata
nostations=dimsizes(fogdata(:,0,0,0))

printVarSummary(fogdata)

grFogdata=dim_sum_n_Wrap(fogdata,0)

printVarSummary(grFogdata)
;exit

;;;;;;;;;;;;; get count of days with different no of stations reporting fog
spread_cnt=new((/nostations+1/),integer)
spread_cnt=0

do year=1979,2016
  do mon=1,2
     if(mon.eq.2)then
       mn=12
     else
        mn=1
     end if
    do day=1,31

       do st=0,4
     
            if(.not.ismissing(grFogdata({year},{mn},{day})) .and. grFogdata({year},{mn},{day}).eq.st)then
              ;print(year+" "+mn+" "+day)
              spread_cnt(st)=spread_cnt(st)+1
            end if
       
       end do  

    end do
  end do
end do

print(spread_cnt)


;;;;;;;;;;;;; get dates with different no of stations reporting fog
do st=0,4

dates=new(spread_cnt(st),"string")

in=0

do year=1979,2016
  do mon=1,2
     if(mon.eq.2)then
       mn=12
     else
        mn=1
     end if
    do day=1,31
     
            if(.not.ismissing(grFogdata({year},{mn},{day})) .and. grFogdata({year},{mn},{day}).eq.st)then
              ;print(year+" "+mn+" "+day)
              dates(in)=tostring(year+"-"+mn+"-"+day)
              in=in+1
            end if
       
    end do
  end do
end do

asciiwrite("days_"+st+"foggyst.txt",dates)
delete(dates)
end do 

end
