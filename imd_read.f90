program UP_IMD
IMPLICIT NONE
INTEGER, PARAMETER :: maxrecs = 3000000
INTEGER :: J, NR, ios, IndexNo, year,mn,hr,dt,rh,vp,dd,fff,aw,vv,st,old_ind,i,k,mon,l
CHARACTER(LEN=1) :: junk 
real :: slp,mslp,dbt,wbt,dpt
Integer,Dimension(39,1979:2016,1:12)::obs_mat_days
integer,Dimension(39,1979:2016,1:12,1:31,1:2)::fog_mat_int
integer::st_ind(39)

open(1,file="hr_data.txt")
NR=0
obs_mat_days=0
st=1
old_ind=0
fog_mat_int=0
DO J=1,maxrecs
 READ(1,*,IOSTAT=ios) junk
 IF (ios /= 0) EXIT
 IF (J == maxrecs) THEN
 write(*,*) 'Error: Maximum number of records exceeded...'
 write(*,*) 'Exiting program now...'
 STOP
 ENDIF
 NR = NR + 1
 ENDDO
REWIND(1) 


!write(*,*)NR

DO J=1,NR
READ(1,'(I5,X,I4,3(X,I2),X,2(f6.1,X),3(f5.1,X),I3,X,I4,X,I2,X,I3,X,I2,X,I2)') IndexNo,year,mn,hr,dt,slp,mslp,dbt,wbt,dpt,rh,vp,dd,&
fff,aw,vv
!write(*,*)J
!write(*,*)IndexNo,year,mn,hr,dt,slp,mslp,dbt,wbt,dpt,rh,vp,dd,fff,aw,vv

if(hr .eq. 3) then
hr=1
else
hr=2
end if

if (j.eq.1)then
old_ind=IndexNo
end if
if(old_ind.ne.IndexNo)then
st=st+1
write(*,*)old_ind
end if

if((year>=1979).and.(year<=2016)) then
   if((mn.eq.12).or.(mn.eq.1))then
     if (hr.eq.1) then
 				! get number of observations
                       obs_mat_days(st,year,mn)=obs_mat_days(st,year,mn)+1	
                                !get fog days
      if(vv.lt.94)then
                        fog_mat_int(st,year,mn,dt,hr)=1
                 else
                           fog_mat_int(st,year,mn,dt,hr)=2
      end if  
     end if
   end if
end if               
old_ind=IndexNo
END DO
close(1)

open(3,file="AllDay_matrix_UP.txt")
write(*,*)st
do i=1979,2016
  do j=1,2
  if(j.eq.2) then
     mon=12
     else
     mon=j
   end if
      do k=1,31
         do l=1,1
write(3,'(i4,A1,i2.2,A1,i2.2,A1,i2.2,a1,50(i2))')i,"-",mon,"-",k,":",l," ",fog_mat_int(:,i,mon,k,l)
         end do
     end do
 end do 
end do


end program UP_IMD
