begin

stat_vals_summary=new((/5,6/),float)

do infile=0,4

fname=infile+"stat_vals.txt"

data = readAsciiTable(fname, 6, "float",0)

;print(data)

stat_vals_summary(infile,0)=max(data(:,0))
stat_vals_summary(infile,1)=min(data(:,1))
stat_vals_summary(infile,2)=avg(data(:,2))
stat_vals_summary(infile,3)=max(data(:,3))
stat_vals_summary(infile,4)=min(data(:,4))
stat_vals_summary(infile,5)=avg(data(:,5))
delete(data)
end do

   opt = True
   opt@fout = "stat_vals_summary.txt"
   write_matrix (stat_vals_summary, "15f12.4" , opt)


end
