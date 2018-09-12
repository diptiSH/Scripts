program IMD_daily
IMPLICIT NONE
INTEGER, PARAMETER :: maxrecs = 3000000
INTEGER :: J, NR, ios,IndexNo,year,mn,dt,t,g_ind,old_ind,st,i,k,l,m,f,fstations
CHARACTER(LEN=1) :: junk 
CHARACTER(LEN=133) :: str 
CHARACTER(LEN=44) ::folder
CHARACTER(LEN=9) ::files(26)
CHARACTER(LEN=62) ::fnames
real,Dimension(26,1979:2013,1:2,1:31)::maxT,minT,rf,anommaxT,anomminT
integer,Dimension(26,1979:2013,1:2,1:31)::fog_ind,wind
CHARACTER(LEN=1),Dimension(26,1979:2013,1:2,1:31) :: wx1,wx2,wx3,wx4
CHARACTER(LEN=1),Dimension(26,1979:2013,1:2,1:31) :: wx1D,wx2D,wx3D,wx4D
real::avgMaxTemp(26),avgMinTemp(26),sdMaxTemp(26),sdMinTemp(26)
real,Allocatable::avgfmin(:),avgfmax(:),avgmin(:),avgmax(:),avganomfmin(:),anomavgmin(:),avganomfmax(:),anomavgmax(:)
CHARACTER(LEN=10) :: date

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

do k=1,26
	folder="/home/iitm/Documents/Data/daily_imd_station/"
	read(100,*)files(k)
	fnames=folder//files(k)
        write(*,*)files(k)
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
	!write(*,*)NR

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
	end do
        close(1)
end do
       close(100)


Do j=1,26
 avgMaxTemp(j)=(sum(maxT(j,:,:,:),MASK=maxT(j,:,:,:).ne.999.9))/count(maxT(j,:,:,:).ne.999.9)
 avgMinTemp(j)=(sum(minT(j,:,:,:),MASK=minT(j,:,:,:).ne.999.9))/count(minT(j,:,:,:).ne.999.9)
 anommaxT(j,:,:,:)=maxT(j,:,:,:)-avgMaxTemp(j)
 anomminT(j,:,:,:)=minT(j,:,:,:)-avgMinTemp(j)
 sdMaxTemp(j)=sqrt(SUM(anommaxT(j,:,:,:)**2,MASK=maxT(j,:,:,:).ne.999.9)/count(maxT(j,:,:,:).ne.999.9))
 sdMinTemp(j)=sqrt(SUM(anomminT(j,:,:,:)**2,MASK=minT(j,:,:,:).ne.999.9)/count(minT(j,:,:,:).ne.999.9))
end do

!mean = SUM(X(1:N)) / N
 ! sd = SQRT (SUM((x(1:N)-mean)**2) / N)


!!!!!!!!get number of dates

open(1,file="date.txt")
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

allocate(avgfmin(NR))
allocate(avgfmax(NR))
allocate(avgmin(NR))
allocate(avgmax(NR))
allocate(avganomfmin(NR))
allocate(avganomfmax(NR))
allocate(anomavgmin(NR))
allocate(anomavgmax(NR))

open(1000,file="daily_attr_ALL-days.txt")
!write(1000,*)"date","avgfmin","avganomfmin","avgmin","anomavgmin","avgfmax","avganomfmax","avgmax","anomavgmax"

do J=1,NR
    READ(1,'(A10)') date
    read(date(1:4),*)year
    read(date(6:7),*)mn
    read(date(9:10),*)dt
  do k=1979,2013
   do l=1,2
     do m=1,31
        if(dt.eq.m .and. mn.eq.l .and. year.eq.k) then
          avgfmin(J)=(sum(minT(:,k,l,m),MASK=fog_ind(:,k,l,m).eq.1 .and.   &
              minT(:,k,l,m).ne.999.9))/(count(fog_ind(:,k,l,m).eq.1  &
              .and. minT(:,k,l,m).ne.999.9 ))
        avgmin(J)=(sum(minT(:,k,l,m),MASK=minT(:,k,l,m).ne.999.9))/(count(minT(:,k,l,m).ne.999.9 ))
         avgfmax(J)=(sum(maxT(:,k,l,m),MASK=fog_ind(:,k,l,m).eq.1 .and.   &
              maxT(:,k,l,m).ne.999.9))/(count(fog_ind(:,k,l,m).eq.1  &
              .and. maxT(:,k,l,m).ne.999.9 ))
        avgmax(J)=(sum(maxT(:,k,l,m),MASK=maxT(:,k,l,m).ne.999.9))/(count(maxT(:,k,l,m).ne.999.9 ))
            write(*,*)J
        avganomfmin(J)=(sum(anomminT(:,k,l,m)/sdMinTemp(:),MASK=fog_ind(:,k,l,m).eq.1 .and.   &
              minT(:,k,l,m).ne.999.9))/(count(fog_ind(:,k,l,m).eq.1  &
              .and. minT(:,k,l,m).ne.999.9 ))
             write(*,*)J
            avganomfmax(J)=(sum(anommaxT(:,k,l,m)/sdMaxTemp(:),MASK=fog_ind(:,k,l,m).eq.1 .and.   &
              maxT(:,k,l,m).ne.999.9))/(count(fog_ind(:,k,l,m).eq.1  &
              .and. maxT(:,k,l,m).ne.999.9 ))
                write(*,*)J
           anomavgmin(J)=(sum(anomminT(:,k,l,m)/sdMinTemp(:),MASK=minT(:,k,l,m).ne.999.9))/(count(minT(:,k,l,m).ne.999.9 ))
                 write(*,*)J
           anomavgmax(J)=(sum(anommaxT(:,k,l,m)/ sdMaxTemp(:),MASK=maxT(:,k,l,m).ne.999.9))/(count(maxT(:,k,l,m).ne.999.9 ))
           fstations=count(fog_ind(:,k,l,m).eq.1)
   write(1000,*)date,avgfmin(J),avganomfmin(J),avgmin(J),anomavgmin(J),avgfmax(J),avganomfmax(J),avgmax(J),anomavgmax(J),fstations
        end if
     end do
   end do
  end do
  
end do

close(1000)

write(*,*)sum(avgMaxTemp)/26.0,sum(avgMinTemp)/26.0,sum(sdMaxTemp)/26.0,sum(sdMinTemp)/26.0

end program IMD_daily
