program IMD_daily
IMPLICIT NONE
INTEGER, PARAMETER :: maxrecs = 3000000
INTEGER ::i,k,mon, J, NR, ios,old_ind,st, IndexNo, year,mn,dt, wind,fog_ind,numC,Gind,flag
real::maxT,minT,rf
CHARACTER(LEN=1) :: junk ,wtype1,wtype2,wtype3
CHARACTER(LEN=58) :: testT 
CHARACTER(LEN=25):: wth_desc 
CHARACTER(LEN=25),Dimension(36145):: wth_desc_mat 
CHARACTER(LEN=7) :: txt1,txt2,txt3 
Integer,Dimension(30,1979:2013,1:12)::obs_mat_days
integer,Dimension(30,1979:2013,1:12,1:31)::fog_mat_int,obs_tmax,obs_tmin,obs_wind,obs_rh,fog_tmax,fog_tmin,fog_wind,fog_rh
integer,Dimension(30)::station_ID

station_ID(1:30)=(/ 42361 , 42492 , 42498 , 42567 , 42571 , 42574 , 42591 , 42708 , 42803 , 42809 , 42901 , 42071 , 42103 , 42131  & 
 , 42176 , 42182 , 5219 , 42266 , 42273 , 42369 , 42379 , 42473 , 42475 , 42483 , 42467 , 42500 , 42587 , 42603 , 5211 , 42148 /)
flag=0

open(1,file="/home/iitm/Documents/Data/IMD_Data/daily/daily_data.txt")
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

!open(3,file="wthr_test.txt")
!write(*,*)NR
numC=0
DO J=1,NR
!fog_ind =0
READ(1,'(I5,X,I4,2(X,I2),X,2(f5.1,X),I2,X,f5.1,A58,I2,X,I2,A25)') IndexNo,year,mn,dt,maxT,minT,wind,rf,testT,fog_ind, &
Gind,wth_desc

if ( ANY( station_ID==IndexNo ) ) then
flag=1
else
flag=0
end if
if (flag.eq.1) then
if (j.eq.1)then
old_ind=IndexNo
end if
if(old_ind.ne.IndexNo)then
st=st+1
write(*,*)old_ind
end if
old_ind=IndexNo
!write(*,*)J

 
if((year>=1979).and.(year<=2013)) then
   if((mn.eq.12).or.(mn.eq.1))then
     
 				! get number of observations
                       obs_mat_days(st,year,mn)=obs_mat_days(st,year,mn)+1	
                                !get fog days
                       obs_tmax(st,year,mn,dt)=maxT
      if(fog_ind .gt. 0)then
                        fog_mat_int(st,year,mn,dt)=1
                        fog_tmax(st,year,mn,dt)=maxT
                 else
                           fog_mat_int(st,year,mn,dt)=2
     
     end if
   end if
end if        

if ( fog_ind .gt. 0 ) then
!write(*,*)"index etc"
!write(*,*)IndexNo,year,mn,dt,maxT,minT,wind,rf
!write(*,*)"testT"
!write(*,*)testT
!write(*,*)"fog_ind"
!write(*,*)fog_ind
wth_desc_mat(numC)=wth_desc
!write(*,*)wth_desc
!write(*,*)numC
numC=numC+1
!write(3,*)fog_ind,wth_desc
end if
end if
END DO
!write(*,*)numC
close(1)
write(*,*)"no_stations"
write(*,*)st


!close(3)

open(3,file="AllDay_matrix.txt")
!write(*,*)st
do i=1979,2013
  do j=1,2
  if(j.eq.2) then
     mon=12
     else
     mon=j
   end if
      do k=1,31
         
write(3,'(i4,A1,i2.2,A1,i2.2,30(i2))')i,"-",mon,"-",k ,fog_mat_int(:,i,mon,k)
        
     end do
 end do 
end do

end program IMD_daily
