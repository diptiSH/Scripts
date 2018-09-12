begin


 f      = addfile("3DIMG_20DEC2014_0000_L2C_FOG.h5","r")

 printVarSummary(f)

vars=getfilevarnames(f)

;print(vars(401:500))

asciiwrite("var.txt",vars)

FOG=f->FOG

print(FOG)

printVarSummary(FOG)

exit

end
