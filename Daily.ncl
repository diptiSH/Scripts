begin


fileName="AMRITSAR.txt"
;---Read in file as array of strings so we can parse each line
  lines = asciiread(fileName,-1,"string")

;print(lines)

  delim = ","

printVarSummary(lines)

 StationNames  =           str_get_field(lines,1,delim)
 years         =  tointeger(str_get_field(lines,3,delim))
 months        =  tointeger(str_get_field(lines,4,delim))
 dates         =  tointeger(str_get_field(lines,5,delim))
 hrs           =  tointeger(str_get_field(lines,6,delim))
 visibilities  =  tointeger(str_get_field(lines,10,delim))
  dTemp         =  tofloat(str_get_field(lines,25,delim))
  ;wTemp         =  tofloat(str_get_field(lines,26,delim))
 dewTemp       =  tofloat(str_get_field(lines,27,delim))


;wmisNo=num(ismissing(wTemp))
 dmisNo=num(ismissing(dTemp))
 dewmisNo=num(ismissing(dewTemp))
 vmisNo=num(ismissing(visibilities))

;print(wmisNo)
print(dmisNo)
print(dewmisNo)
print(vmisNo)
;************************************** Get observations per day
obsPerDay=new((/35,2,31/),"integer")
obsPerDay=0

do i=0,dimsizes(lines)-1

 do yr=1979,2013
    do mn=1,2
       if (mn.eq.2) then
          mon=12
       else
          mon=1
       end if
           do date=1,31
              if(years(i).eq.yr .and. months(i).eq.mon .and. dates(i).eq.date) then
              obsPerDay(yr-1979,mn-1,date-1)=obsPerDay(yr-1979,mn-1,date-1)+1
              end if

           end do
    end do
 end do

end do

;print(obsPerDay)


;***************************** details of daily obs

maxVis=new((/35,2,31/),"integer")
minVis=new((/35,2,31/),"integer")
maxTemp=new((/35,2,31/),"float")
minTemp=new((/35,2,31/),"float")
maxDewTemp=new((/35,2,31/),"float")
minDewTemp=new((/35,2,31/),"float")
fogDuration=new((/35,2,31/),"integer")
maxVis=999999999


 do yr=2013,2013
    do mn=1,2
       if (mn.eq.2) then
          mon=12
       else
          mon=1
       end if
           do date=1,31
                    if (obsPerDay(yr-1979,mn-1,date-1).gt.0) then
                   vis=new(obsPerDay(yr-1979,mn-1,date-1),"integer")
                   k=0
                   do i=0,dimsizes(lines)-1
                            if(years(i).eq.yr .and. months(i).eq.mon .and. dates(i).eq.date) then
                                  vis(k)=visibilities(i)
                                      k=k+1
                              end if
                  end do
                  maxVis(yr-1979,mn-1,date-1)=max(vis)
                  minVis(yr-1979,mn-1,date-1)=min(vis)
                  delete(vis)
                  end if
           end do
    end do
 end do

print(maxVis(34,1,30))


end
