begin 

 fname  = "date"        ;input Data
                                       ; open "data " as 2-dim array
  data   = asciiread (fname,(/2139,3/), "integer")

  print(data)

   NAOdata   = readAsciiTable ("NAO",4, "float",0)
  
;print(NAOdata)
  combined_data=new((/2139/),"float") 

do i=0,24775
  do j=0,2138
    ;print(i)
   ;print(j)
   if ((NAOdata(i,0).eq.data(j,0)).and.(NAOdata(i,1).eq.data(j,1)).and.(NAOdata(i,2).eq.data(j,2))) then
          combined_data(j)=NAOdata(i,3)
     
 end if
  end do
  
  end do
asciiwrite ("fNAO11.txt" , combined_data)

end 
