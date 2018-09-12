begin

nodeRows=4
nodeColumns=3
pats=nodeRows*nodeColumns

stations=asciiread("/home/iitm/Documents/get_fog_details/foggyStations.txt",2139,"integer")

printVarSummary(stations)


mapping=asciiread("nodenums.txt",2139,"integer")

printVarSummary(mapping)



days=dimsizes(mapping)

dist_nodes_count=new(pats,integer,-99)
dist_nodes_per_widespread=new(pats,float,0.0)
dist_nodes_per_nodeDays=new(pats,float,0.0)

dist_nodes_count=0

do i=0,days-1

  do j=0,pats-1
     ; print(i+"  "+j)
     if(stations(i).gt.20 .and. mapping(i).eq.j) then
         print(i+"  "+j)
        ; print(dist_nodes_count(j))
         dist_nodes_count(j) = dist_nodes_count(j)+1
         ;print(dist_nodes_count(j))
     end if

  end do


end do


print(dist_nodes_count)


end
