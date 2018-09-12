begin

nodeArray=(/4,9,12,20,25,30,36,40/)

avg_summary=new((/dimsizes(nodeArray),6/),float)
interClust_avg_summary=new((/dimsizes(nodeArray),3/),float)
summary_summary=new((/dimsizes(nodeArray),6/),float)
min_summary=new((/dimsizes(nodeArray),5/),float)

do i=0,dimsizes(nodeArray)-1

folderName="/home/iitm/Documents/ncl_som/ncl_som_16July/without_filter/"+nodeArray(i)+"SOM/"
filename="stat_vals_summary.txt"
interClustFname="interclust_val_summary.txt"


fin=folderName+filename
interClustfin=folderName+interClustFname

;print(fin)

print(i)
data = readAsciiTable(fin, 6, "float",0)
interClustdata=readAsciiTable(interClustfin, 3, "float",0)

print(data)
print(interClustdata)

min_summary(i,:)=data(:,1)


avg_summary(i,:)=dim_avg_n(data,0)
interClust_avg_summary(i,:)=dim_avg_n(interClustdata,0)

summary_summary(i,0)=max(data(:,0))
summary_summary(i,1)=min(data(:,1))
summary_summary(i,2)=avg(data(:,2))

summary_summary(i,3)=max(data(:,3))
summary_summary(i,4)=min(data(:,4))
summary_summary(i,5)=avg(data(:,5))


delete(data)


end do


 opt = True
   opt@fout = "avg_summary.txt"
   write_matrix (avg_summary, "15f12.4" , opt)

opt = True
   opt@fout = "interClust_avg_summary.txt"
   write_matrix (interClust_avg_summary, "15f12.4" , opt)

 opt = True
   opt@fout = "summary_summary.txt"
   write_matrix (summary_summary, "15f12.4" , opt)

  pt = True
   opt@fout = "min_summary.txt"
   write_matrix (min_summary, "15f12.4" , opt)




end
