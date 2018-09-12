begin

fmask=addfile("/home/iitm/Documents/Data/mask/ERA-1.5deg-elevation.nc","r")
data=fmask->z
elev=data(:,{24:32},{74:86})
printVarSummary(elev)
delete(fmask)

fInv=addfile("ERACLIM-1.5deg-Inversion-Jan.nc","r")
t_old=fInv->t
printVarSummary(t_old)
t=t_old(:,{24:32},{74:86})
printVarSummary(t)
inv=linint2_Wrap(t&longitude,t&latitude,t,True,elev&longitude,elev&latitude,0);t(:,{24:32},{-180:180})
printVarSummary(inv)
delete(fInv)

;************************* mask region more than 500 m height
maskVar=where(elev.lt.500,1,0)
copy_VarMeta(elev,maskVar)
printVarSummary(maskVar)

;********************** avg inversion for region less than 500 m

maskVar_conf=conform(inv,maskVar(0,:,:),(/1,2/))
printVarSummary(maskVar_conf)

masked_inv= mask(inv,(maskVar_conf.lt.1),False)
AAvg_inv=dim_avg_n_Wrap(masked_inv,(/1,2/))

print(max(AAvg_inv))
print(min(AAvg_inv))

end
