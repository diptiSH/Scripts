begin


nodeRow=2
nodeColumn=2

mapsize=nodeRow*nodeColumn

map=asciiread("map",-1,"integer")

;print(map)


;;;;;;;;;;;;;;;;;;;;;;;;; get first occurence of each pattern each pattern

rep_indices=new(mapsize,integer,-999)

print(rep_indices)

do i=0,dimsizes(map)-1

 do p=1,mapsize

  if(map(i).eq.p .and. ismissing(rep_indices(p-1))) then

    rep_indices(p-1)=i+1  

  end if
  

 end do


end do


print(rep_indices)



mapNcl=asciiread("ncl_map",-1,"integer")

;print(mapNcl)
mapNcl=mapNcl+1

;;;;;;;;;;;;;;;;;;;;;;;;; get first occurence of each pattern each pattern

rep_indicesNcl=new(mapsize,integer,-999)

print(rep_indicesNcl)

do i=0,dimsizes(mapNcl)-1

 do p=1,mapsize

  if(mapNcl(i).eq.p .and. ismissing(rep_indicesNcl(p-1))) then

    rep_indicesNcl(p-1)=i+1  

  end if
  

 end do


end do


print(rep_indicesNcl)


;;;;;;;;; count number of days falling in same classes and not same classes

same_class=0
diff_class=0



do i=0,dimsizes(mapNcl)-1
   do j=0,dimsizes(mapNcl)-1
    
      if(mapNcl(i).eq.mapNcl(j) .and. map(i).eq.map(j))then
      same_class=same_class+1
      else 
      diff_class=diff_class+1
      end if

   end do
end do

same_class=(same_class-2356)/2
diff_class=diff_class/2

print(same_class)
print(diff_class)

print(same_class/todouble(diff_class))

print(same_class/todouble(diff_class+same_class))

end
