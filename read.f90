program IMD_daily
IMPLICIT NONE
INTEGER, PARAMETER :: maxrecs = 3000000
INTEGER :: J, NR, ios,IndexNo,year,mn,dt,t,g_ind,old_ind,st,i,k
CHARACTER(LEN=1) :: junk 
CHARACTER(LEN=133) :: str 
CHARACTER(LEN=53) ::folder
CHARACTER(LEN=9) ::files(130)
CHARACTER(LEN=62) ::fnames
real,Dimension(130,1979:2016,1:12,1:31)::maxT,minT,rf
integer,Dimension(130,1979:2016,1:12,1:31)::fog_ind,wind
CHARACTER(LEN=1),Dimension(130,1979:2016,1:12,1:31) :: wx1,wx2,wx3,wx4
CHARACTER(LEN=1),Dimension(130,1979:2016,1:12,1:31) :: wx1D,wx2D,wx3D,wx4D

fog_ind=9
wind=999
maxT=999.9
minT=999.9
rf=999.9
wx1="z"
wx1D="z"
wx2="z"
wx2D="z"
wx3="z"
wx3D="z"
wx4="z"
wx4D="z"




open(100,file="flist.txt")

do k=1,130
	folder="/home/iitm/Documents/Data/IMD_Data/daily_imd_station/"
	read(100,*)files(k)
	fnames=folder // files(k)
	write(*,*)fnames
	open(1,file=fnames)
	NR=0
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
	write(*,*)NR

	DO J=1,NR
		read(1,'(A133)')str
		!write(*,*)str
                read(str(1:5),*)IndexNo
		!write(*,*)IndexNo
		read(str(7:10),*)year
		!write(*,*)year
		read(str(12:13),*)mn
		!write(*,*)mn
		read(str(15:16),*)dt
		!write(*,*)dt
		if(str(18:22).ne."")then
		read(str(18:22),*)maxT(k,year,mn,dt)
		!write(*,*)maxT
                else
		maxT(k,year,mn,dt)=999.9
		end if
		if(str(24:28).ne."")then
		read(str(24:28),*)minT(k,year,mn,dt)
		!write(*,*)minT
                else
		minT(k,year,mn,dt)=999.9
		end if
		if(str(30:31).ne."")then
		read(str(30:31),*)wind(k,year,mn,dt)
		!write(*,*)wind
                 else
		wind(k,year,mn,dt)=999
		end if
                if(str(33:37).ne."")then
		read(str(33:37),*)rf(k,year,mn,dt)
		!write(*,*)wind
                 else
		rf(k,year,mn,dt)=99.9
		end if
		if(str(96:97).ne."")then
		read(str(96:97),*)fog_ind(k,year,mn,dt)
		!write(*,*)fog_ind
		else
		fog_ind(k,year,mn,dt)=9
		end if
                if(str(102:102).ne."")then
		wx1(k,year,mn,dt)=str(102:102)
		!write(*,*)wind
                 else
		wx1(k,year,mn,dt)="z"
		end if
                      if(str(104:104).ne."")then
		wx1D(k,year,mn,dt)=str(104:104)
		!write(*,*)wind
                 else
		wx1D(k,year,mn,dt)="z"
		end if
                    if(str(110:110).ne."")then
		wx2(k,year,mn,dt)=str(110:110)
		!write(*,*)wind
                 else
		wx2(k,year,mn,dt)="z"
		end if
                      if(str(112:112).ne."")then
		wx2D(k,year,mn,dt)=str(112:112)
		!write(*,*)wind
                 else
		wx2D(k,year,mn,dt)="z"
		end if
                if(str(118:118).ne."")then
		wx3(k,year,mn,dt)=str(118:118)
		!write(*,*)wind
                 else
		wx3(k,year,mn,dt)="z"
		end if
                      if(str(120:120).ne."")then
		wx3D(k,year,mn,dt)=str(120:120)
		!write(*,*)wind
                 else
		wx3D(k,year,mn,dt)="z"
		end if
                                if(str(126:126).ne."")then
		wx4(k,year,mn,dt)=str(126:126)
		!write(*,*)wind
                 else
		wx4(k,year,mn,dt)="z"
		end if
                      if(str(128:128).ne."")then
		wx4D(k,year,mn,dt)=str(128:128)
		!write(*,*)wind
                 else
		wx4D(k,year,mn,dt)="z"
		end if
             
	end do
        close(1)
end do
       close(100)
open(3,file="fog_matrix.txt")
open(4,file="maxT_matrix.txt")
open(5,file="minT_matrix.txt")
open(6,file="wind_matrix.txt")
open(7,file="rf_matrix.txt")
open(8,file="wx1_matrix.txt")
open(9,file="wx1D_matrix.txt")
open(10,file="wx2_matrix.txt")
open(11,file="wx2D_matrix.txt")
open(12,file="wx3_matrix.txt")
open(13,file="wx3D_matrix.txt")
open(14,file="wx4_matrix.txt")
open(15,file="wx4D_matrix.txt")
do i=1979,2016
  do j=1,2
  if(j.eq.2) then
     mn=12
     else
     mn=j
   end if
      do k=1,31
         
write(3,'(i4,A1,i2.2,A1,i2.2,X,130(i2,X))')i,"-",mn,"-",k ,fog_ind(:,i,mn,k)
write(4,'(i4,A1,i2.2,A1,i2.2,X,130(f6.2,X))')i,"-",mn,"-",k ,maxT(:,i,mn,k)        
write(5,'(i4,A1,i2.2,A1,i2.2,X,130(f6.2,X))')i,"-",mn,"-",k ,minT(:,i,mn,k)
write(6,'(i4,A1,i2.2,A1,i2.2,X,130(i3,X))')i,"-",mn,"-",k ,wind(:,i,mn,k)
write(7,'(i4,A1,i2.2,A1,i2.2,X,130(f6.2,X))')i,"-",mn,"-",k ,rf(:,i,mn,k)
write(8,'(i4,A1,i2.2,A1,i2.2,X,130(A1,X))')i,"-",mn,"-",k ,wx1(:,i,mn,k)
write(9,'(i4,A1,i2.2,A1,i2.2,X,130(A1,X))')i,"-",mn,"-",k ,wx1D(:,i,mn,k)
write(10,'(i4,A1,i2.2,A1,i2.2,X,130(A1,X))')i,"-",mn,"-",k ,wx2(:,i,mn,k)
write(11,'(i4,A1,i2.2,A1,i2.2,X,130(A1,X))')i,"-",mn,"-",k ,wx2D(:,i,mn,k)
write(12,'(i4,A1,i2.2,A1,i2.2,X,130(A1,X))')i,"-",mn,"-",k ,wx3(:,i,mn,k)
write(13,'(i4,A1,i2.2,A1,i2.2,X,130(A1,X))')i,"-",mn,"-",k ,wx3D(:,i,mn,k)
write(14,'(i4,A1,i2.2,A1,i2.2,X,130(A1,X))')i,"-",mn,"-",k ,wx4(:,i,mn,k)
write(15,'(i4,A1,i2.2,A1,i2.2,X,130(A1,X))')i,"-",mn,"-",k ,wx4D(:,i,mn,k)
     end do
 end do 
end do
close(3)
close(4)
close(5)
close(6)
close(7)
close(8)
close(9)
close(10)
close(11)
close(12)
close(13)
close(14)
close(15)
end program IMD_daily
