program fog_day
implicit none
character ( len =50) :: str1 , str2 , str3,  str4, str5, str6, str7, str8, str13, str18, str19,strSLP
INTEGER, PARAMETER :: maxrecs = 100000
INTEGER :: J, NR, ios, year, month, fog_ind,  f, no_files, num, day,i,k,mon, fogday_count
real :: temp,tempD,wind,maxtemp,mintemp,vis,slp,rh,tdc,tc, vis_ind
CHARACTER(LEN=100) :: filename
CHARACTER(LEN=1) :: junk 
Character(len=50),DIMENSION(:),Allocatable::fog_days
Logical,Dimension(30,1979:2016,1:12,1:31)::fog_mat
real,Dimension(30,1979:2016,1:12,1:31)::fog_mat_lat,fog_mat_lon,fog_mat_vis,fog_mat_temp,fog_mat_slp,fog_mat_rh
integer,Dimension(30,1979:2016,1:12,1:31)::fog_mat_int
Character(len=7),DIMENSION(30,1979:2016,1:12,1:31)::fog_mat_min_temp
Integer,Dimension(30,1979:2016,1:12)::obs_mat_days

fog_mat=.False.
no_files=30
fog_mat_int=0
fog_mat_temp=0.0
fog_mat_slp=0.0
obs_mat_days=0
fog_mat_rh=0
vis_ind=0.0
!write(*,*)fog_mat

open(3,file="AllDay_matrix_all_22May_2017.txt")
open(4,file="fog_matrix_ind.txt")


do f=1,no_files




if(f<10) then

write (filename, "(A66,I1,A4)") "/home/iitm/Documents/backup/Documents/data/North_india_30Stations/",f,".txt"

else 

write (filename, "(A66,I2,A4)") "/home/iitm/Documents/backup/Documents/data/North_india_30Stations/",f,".txt"

end if


!write(2,*)filename

open(1,file=filename)

!write(*,*)'tested ok'

read(1 ,*) str1
!write (* ,*) str1

!Determine total number of lines in file
NR = 0

DO J=1,maxrecs
 if(J.eq.2)then
read(1 ,*) str1
write (* ,*) str1
end if
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

!Now read data 
DO J=1,NR
  fog_ind=0
  year=0
  month=0
  day=0
 
 ! write(*,*)j
  READ(1,*) str1,str1,str2,str4,str1,str5,str6,strSLP,str1,str1,str1,str7,str13,str1,str1,str1,str1,str18,str19,str1,str1,str3
         
	if(J>1)then
                !write(*,*)str4
		read(str2,'(i4,i2,i2)')year,month,day
		read(str7,*)vis
                read(str4,*)temp
                 read(str5,*)tempD
                !write(*,*)vis
                !write(*,*)temp
                !write(*,*)str19
		!read(str19,'(f5.1)')mintemp
                read(strSLP,*)slp
                !write(*,*)slp
                tdc=((tempD-32)*5/9)
                tc=((temp-32)*5/9)
                rh=100*(exp((17.625*tdc)/(243.04+tdc))/exp((17.625*tc)/(243.04+tc)))
                vis_ind=(1.0-vis/8.2)


		if((year>=1979).and.(year<=2016)) then
		            if((month.eq.12).or.(month.eq.1))then
 				! get number of observations
                                obs_mat_days(f,year,month)=obs_mat_days(f,year,month)+1	
				!get fog days
                              !fog_mat_maxtemp(f,year,month,day)=maxtemp
					read(str3,'(i1)')fog_ind
					if(fog_ind.ne.0)then
                                        
		       fog_mat(f,year,month,day)=.true.
                       fog_mat_int(f,year,month,day)=fog_ind
                      	fog_mat_vis(f,year,month,day)=vis_ind
                        fog_mat_temp(f,year,month,day)=temp	
                        fog_mat_min_temp(f,year,month,day)=str19
                        fog_mat_slp(f,year,month,day)=slp	
                        fog_mat_rh(f,year,month,day)=rh	
                                          !write(*,*)f,year,month,day, fog_mat(f,year,month,day)  

					else 
                                         fog_mat(f,year,month,day)=.false.
                                         fog_mat_int(f,year,month,day)=2
                                         fog_mat_vis(f,year,month,day)=vis_ind
                                         !fog_mat_min_temp(f,year,month,day)=str19
                                         ! fog_mat_slp(f,year,month,day)=slp
                                         !fog_mat_temp(f,year,month,day)=temp
                                         !fog_mat_rh(f,year,month,day)=rh	
                                         !fog_mat_lat(f,year,month,day)=0.0
                                         !fog_mat_lon(f,year,month,day)=0.0
              
					end if
                            
		             end if

		end if

	end if
 
!write(*,*)num
END DO 
!write(*,*)fog_days

close(1)
!write(*,*)NR
end do
NR=0
open(5,file="fog_dates_gt_11.txt")
open(6,file="Fog_distribution.txt")
open(7,file="fog_vis_gt_11.txt")
open(8,file="fog_temp_gt_11.txt")
open(9,file="fog_min_temp_gt_11.txt")
open(99,file="fog_slp_gt_11.txt")
open(11,file="fog_rh_gt_11.txt")
open(101,file="obs_matrix_all_4April_2017.txt")
do i=1979,2016
 do j=1,2
  if(j.eq.2) then
     mon=12
     else
     mon=j
   end if
   fogday_count =0	
   write(101,*)obs_mat_days(:,i,mon)
   !write(6,*)obs_mat_days(:,i,mon)
   do k=1,31
!if(sum(fog_mat_int(:,i,mon,k)).ne.0)then
!,sum(fog_mat_int(:,i,mon,k))
!lat_range=(maxval(fog_mat_lat(:,i,mon,k))-minval(fog_mat_lat(:,i,mon,k),MASK = fog_mat_lat(:,i,mon,k) .GT.0))
!lon_range=(maxval(fog_mat_lon(:,i,mon,k))-minval(fog_mat_lon(:,i,mon,k),MASK = fog_mat_lon(:,i,mon,k) .GT.0))
!write(3,'(i4,A1,i2.2,A1,i2.2,a1,31(i2))')i,"-",mon,"-",k," ",fog_mat_int(:,i,mon,k)
if(sum(fog_mat_int(:,i,mon,k)).gt.0)then
 fogday_count = fogday_count +1

  
end if

if(sum(fog_mat_int(:,i,mon,k)).ge.0)then
NR=NR+1

!write(*,*)NR
!write(7,*)fog_mat_vis(:,i,mon,k)
write(3,'(i4,A1,i2.2,A1,i2.2,a1,31(i2))')i,"-",mon,"-",k," ",fog_mat_int(:,i,mon,k)
write(6,'(I4,A1,I2.2,A1,I2.2,A3,I2.2)')i,"-",mon,"-",k,"   ",sum(fog_mat_int(:,i,mon,k))
 write(7,*)fog_mat_vis(:,i,mon,k)
write(8,*)fog_mat_temp(:,i,mon,k)
write(9,*)fog_mat_min_temp(:,i,mon,k)
write(99,*)fog_mat_slp(:,i,mon,k)
write(11,*)fog_mat_rh(:,i,mon,k)

if(sum(fog_mat_int(1:21,i,mon,k)).gt.11) then
write(5,'(I4,A1,I2.2,A1,I2.2,A4)')i,"-",mon,"-",k,"*.nc"!,sum(fog_mat_int(:,i,mon,k))

else

write(5,'(I4,A1,I2.2,A1,I2.2,A3)')i,"-",mon,"-",k,".nc"!,sum(fog_mat_int(:,i,mon,k))

end if

!write(6, "(I4,1X,I2.2,1X,I2.2,A2,1X,I2.2,A2)")i,mon,k-1,"00",k+1,"12"
!write(4,'(i4,i2.2,i2.2,1x,f8.3)')i,mon,k,lat_range*lon_range
end if
!end if
   end do


 end do 
end do
close(1)
close(3)
close(4)
close(6)
close(5)
close(7)
close(8)
close(9)
close(99)
close(11)
close(101)

end program fog_day
