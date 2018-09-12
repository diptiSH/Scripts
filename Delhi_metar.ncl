begin


fileName="DELHI.txt"
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
;print(dmisNo)
;print(dewmisNo)
;print(vmisNo)
;************************************** Get observations per day
obsPerDay=new((/35,2,31/),"integer")
foggyobsPerDay=new((/35,2,31/),"integer")
InfoggyobsPerDay=new((/35,2,31/),"integer")
obsPerDay=0
foggyobsPerDay=0
InfoggyobsPerDay=0

printVarSummary(visibilities)

;print(visibilities(13766))
;exit

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
                   ;print(i)
              obsPerDay(yr-1979,mn-1,date-1)=obsPerDay(yr-1979,mn-1,date-1)+1
                 if(.not.(ismissing(visibilities(i)))) then
                   if(visibilities(i).lt.94)then
                    foggyobsPerDay(yr-1979,mn-1,date-1)=foggyobsPerDay(yr-1979,mn-1,date-1)+1
                     ;print(i)
                     if(visibilities(i).le.92) then
                      InfoggyobsPerDay(yr-1979,mn-1,date-1)=InfoggyobsPerDay(yr-1979,mn-1,date-1)+1
                     end if
                     ;print(i)
                    else
                     ; print("test")
                   end if
                 end if  
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
fogStart=new((/35,2,31/),"integer")
fogEnd=new((/35,2,31/),"integer")
maxVis=999
minVis=999
fogStart=999
fogEnd=999
;****************************** max and min visibility obs
 do yr=1979,2013
    do mn=1,2
       if (mn.eq.2) then
          mon=12
       else
          mon=1
       end if
           do date=1,31
                    ;firstTag="N"
                   if (obsPerDay(yr-1979,mn-1,date-1).gt.0) then
                   vis=new(obsPerDay(yr-1979,mn-1,date-1),"integer")
                   hr=new(obsPerDay(yr-1979,mn-1,date-1),"integer")
                   k=0
                   do i=0,dimsizes(lines)-1
                            if(years(i).eq.yr .and. months(i).eq.mon .and. dates(i).eq.date) then
                                  ;if (firstTag.eq."N"0 then
                                   ;  firstvis=visibilities(i)
                                   ;  firstTag="Y"
                                  ;end if
                                  vis(k)=visibilities(i)
                                  hr(k)=hrs(i)
                                      k=k+1
                              end if
                  end do
                  maxVis(yr-1979,mn-1,date-1)=max(vis)
                  minVis(yr-1979,mn-1,date-1)=min(vis)
                  if (foggyobsPerDay(yr-1979,mn-1,date-1) .gt. 0) then
                  foggyIndices=ind(vis.lt.94)
                   start1=hr(foggyIndices(0))
                         firstTag="N"
                         startFog=999
                         endFog=999
                         do h=0,k-1
              if(.not.(ismissing(vis(h).lt.94))) then
                            if(vis(h).lt.94 .and. firstTag.eq."N") then
                              startFog=hr(h)
                              fogStart(yr-1979,mn-1,date-1)=hr(h)
                              ;print(startFog)
                         if(.not.(h.eq.k-1))then
                           if((all(vis(h+1:k-1).lt.94))) then
                                endFog=hr(k-1)
                               fogEnd(yr-1979,mn-1,date-1)=hr(k-1)
                               ;  print(endFog)
                              else
                              nFoggyindices=ind(vis(h+1:k-1).ge.94)
                               ;print(h)
                               ;print(h+1)
                               ;print(k-1)
                               ;print(vis(h+1:k-1))
                               ;print(nFoggyindices)
                               endFog=hr(nFoggyindices(0)+1+h)
                               fogEnd(yr-1979,mn-1,date-1)=hr(nFoggyindices(0)+1+h)
                               ;print(endFog)
                                 delete(nFoggyindices)
                             end if
                              firstTag="Y"
                          end if
                            end if
               end if
                         end do
                        
                        
                  ;print(hr(foggyIndices))
                 ; print(foggyIndices)
                  delete(foggyIndices)
                
                   end if
                  delete(vis)
                  delete(hr)
                  end if
           end do
    end do
 end do
fogDuration=fogEnd-fogStart

 alist   = [/maxVis,minVis,fogStart,fogEnd,fogDuration,foggyobsPerDay,InfoggyobsPerDay/]

 header = (/"maxVis,minVis,fogStart,fogEnd,fogDuration,foggyobsPerDay,InfoggyobsPerDay"/)
 hlist = [/header/]
write_table("fogDetailsDelhi.txt","w",hlist,"%s")
write_table("fogDetailsDelhi.txt","a",alist,"%d,%d,%d,%d,%d,%d,%d")
;print(maxVis(0,0,0))
end
