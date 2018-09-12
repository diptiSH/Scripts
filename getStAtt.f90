program IMD_daily
IMPLICIT NONE
INTEGER, PARAMETER :: maxrecs = 3000000
INTEGER :: J, NR, ios,IndexNo,year,mn,dt,t,g_ind,old_ind,st,i,k
CHARACTER(LEN=1) :: junk 
CHARACTER(LEN=133) :: str 
CHARACTER(LEN=50) ::folder
CHARACTER(LEN=9) ::files(26)
CHARACTER(LEN=62) ::fnames
real,Dimension(26,1979:2013,1:2,1:31)::maxT,minT,rf
integer,Dimension(26,1979:2013,1:2,1:31)::fog_ind,wind
CHARACTER(LEN=1),Dimension(26,1979:2013,1:2,1:31) :: wx1,wx2,wx3,wx4
CHARACTER(LEN=1),Dimension(26,1979:2013,1:2,1:31) :: wx1D,wx2D,wx3D,wx4D
real,Dimension(26,19):: attr

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
attr=0.0




open(100,file="flist.txt")

do k=1,26
	folder="/media/New Volume/DATA/IMD_Data/daily_imd_statio2/"
	read(100,*)files(k)
	fnames=folder//files(k)
        !write(*,*)files(k)
	!write(*,*)fnames
	open(1,file=fnames)
	NR=0
	 DO J=1,maxrecs
		 READ(1,*,IOSTAT=ios) junk
                ! write(*,*)junk
                ! write(*,*)ios
                 
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
   if(year.le.2013) then
         if(mn.eq.1 .or. mn.eq.12) then
                if(year.eq.2013 .and. mn.eq.12) cycle
               if(mn.eq.12) then 
                mn=2
               end if

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
		rf(k,year,mn,dt)=999.9
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
           end if  
end if
	end do
        close(1)
end do
       close(100)


open(3,file="fog_matrix.txt")
open(5,file="fog_dates.txt")
do i=1979,2013
 do j=1,2
       do k=1,31
         
write(3,'(i4,A1,i2.2,A1,i2.2,X,26(i2,X))')i,"-",j,"-",k ,fog_ind(:,i,j,k)
   if(sum(fog_ind(:,i,j,k),MASK=fog_ind(:,i,j,k).ne.9).gt.11) then
    if (j.eq.2) then 
     mn=12
    else 
      mn=1
     end if
write(5,'(i4,A1,i2.2,A1,i2.2)')i,"-",mn,"-",k 
 end if

    end do
end do 
end do
close(3)
close(5)




Do j=1,26
    attr(j,1)=count(fog_ind(j,:,:,:).ne.9)
    attr(j,2)=count(fog_ind(j,:,:,:).eq.1)
    attr(j,3)=count(fog_ind(j,:,:,:).eq.0)
    attr(j,4)=count(maxT(j,:,:,:).ne.999.9)
    attr(j,5)=(sum(maxT(j,:,:,:),MASK=maxT(j,:,:,:).ne.999.9))/count(maxT(j,:,:,:).ne.999.9)
    attr(j,6)=(sum(maxT(j,:,:,:),MASK=fog_ind(j,:,:,:).eq.1 .and.   &
              maxT(j,:,:,:).ne.999.9))/(count(fog_ind(j,:,:,:).eq.1  &
              .and. maxT(j,:,:,:).ne.999.9 ))
    attr(j,7)=(sum(maxT(j,:,:,:),MASK=fog_ind(j,:,:,:).eq.0 .and.  &
              maxT(j,:,:,:).ne.999.9))/(count(fog_ind(j,:,:,:).eq.0  &
              .and. maxT(j,:,:,:).ne.999.9 ))
    attr(j,8)=count(minT(j,:,:,:).ne.999.9)
    attr(j,9)=(sum(minT(j,:,:,:),MASK=minT(j,:,:,:).ne.999.9))/count(minT(j,:,:,:).ne.999.9)
    attr(j,10)=(sum(minT(j,:,:,:),MASK=fog_ind(j,:,:,:).eq.1 .and.   &
              minT(j,:,:,:).ne.999.9))/(count(fog_ind(j,:,:,:).eq.1  &
              .and. minT(j,:,:,:).ne.999.9 ))
    attr(j,11)=(sum(minT(j,:,:,:),MASK=fog_ind(j,:,:,:).eq.0 .and.  &
              minT(j,:,:,:).ne.999.9))/(count(fog_ind(j,:,:,:).eq.0  &
              .and. minT(j,:,:,:).ne.999.9 ))
    attr(j,12)=count(rf(j,:,:,:).ne.999.9)
    attr(j,13)=(sum(rf(j,:,:,:),MASK=rf(j,:,:,:).ne.999.9))/count(rf(j,:,:,:).ne.999.9)
    attr(j,14)=(sum(rf(j,:,:,:),MASK=fog_ind(j,:,:,:).eq.1 .and.   &
              rf(j,:,:,:).ne.999.9))/(count(fog_ind(j,:,:,:).eq.1  &
              .and. rf(j,:,:,:).ne.999.9 ))
    attr(j,15)=(sum(rf(j,:,:,:),MASK=fog_ind(j,:,:,:).eq.0 .and.  &
              rf(j,:,:,:).ne.999.9))/(count(fog_ind(j,:,:,:).eq.0  &
              .and. rf(j,:,:,:).ne.999.9 ))
     !write(*,*)"OK"
    if(count(wind(j,:,:,:).ne.999).ne.0) then
    if(count(fog_ind(j,:,:,:).eq.0 .and. wind(j,:,:,:).ne.999 ) .ne. 0) then
     if(count(fog_ind(j,:,:,:).eq.1 .and. wind(j,:,:,:).ne.999 ) .ne. 0) then
     attr(j,16)=count(wind(j,:,:,:).ne.999)
    attr(j,17)=(sum(wind(j,:,:,:),MASK=wind(j,:,:,:).ne.999))/count(wind(j,:,:,:).ne.999)
    attr(j,18)=(sum(wind(j,:,:,:),MASK=fog_ind(j,:,:,:).eq.1 .and.   &
              wind(j,:,:,:).ne.999))/(count(fog_ind(j,:,:,:).eq.1  &
              .and. wind(j,:,:,:).ne.999 ))
    attr(j,19)=(sum(wind(j,:,:,:),MASK=fog_ind(j,:,:,:).eq.0 .and.  &
              wind(j,:,:,:).ne.999))/(count(fog_ind(j,:,:,:).eq.0  &
              .and. wind(j,:,:,:).ne.999 ))
  end if
  end if
  end if
end do

open(4,file="fog_attributes.txt")
Do j=1,26
    write(4,*)attr(j,:)
end do
close(4)

   ! write(*,*)size(fog_ind(1,:,:,:))


end program IMD_daily
