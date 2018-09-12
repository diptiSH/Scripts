program addCriteria
IMPLICIT NONE
INTEGER, PARAMETER :: maxrecs = 3000000
INTEGER :: k,j,NR,ios,year,mn,dt,hr,l,m,f
CHARACTER(LEN=44) ::folder
CHARACTER(LEN=9) ::files(26)
CHARACTER(LEN=62) ::fnames
CHARACTER(LEN=1) :: junk 
CHARACTER(LEN=10) :: date
CHARACTER(LEN=133) :: str 
real,Dimension(26,1979:2013,1:2,1:31)::slp,dbt,dpt
integer,Dimension(26,1979:2013,1:2,1:31)::rh,vv,fff,aw
real,Dimension(26)::avgslp,avgdbt,avgdpt
integer,Dimension(26)::avgrh,avgfff,avgaw
integer,Allocatable,Dimension(:,:,:)::attr
slp=9.9
dbt=999.9
dpt=999.9
fff=99
rh=999
aw=99
vv=0




open(100,file="flist.txt")
NR=0
do k=1,26
	folder="/home/iitm/Documents/Data/daily_twi_station/"
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
write(*,*)"test123123"
	DO J=1,NR
        read(1,'(A133)')str
       ! write(*,*)str
        read(str(7:10),*)year
		!write(*,*)year
		read(str(12:13),*)mn
		!write(*,*)mn
		read(str(15:16),*)hr
		!write(*,*)hr
                read(str(18:19),*)dt
		!write(*,*)dt
                if((mn.eq.1 .or. mn.eq.12).and.(hr.eq.3)) then
                if(year.eq.2013 .and. mn.eq.12) cycle
               if(mn.eq.12) then 
                mn=2
               end if
! write(*,*)year,mn,dt,hr
!!!!!!!!!!!!!!!!!!!slp reAD
               if(str(21:26).ne."")then
                read(str(21:26),*)slp(k,year,mn,dt)
		!write(*,*)wind
                 else
		slp(k,year,mn,dt)=9.9
		end if
!!!!!!!!!!!!!!!!!!!dbt reAD
               if(str(35:39).ne."")then
                read(str(35:39),*)dbt(k,year,mn,dt)
		!write(*,*)wind
                 else
		dbt(k,year,mn,dt)=999.9
		end if
!!!!!!!!!!!!!!!!!!!dpt reAD
               if(str(47:51).ne."")then
                read(str(47:51),*)dpt(k,year,mn,dt)
		!write(*,*)wind
                 else
		dpt(k,year,mn,dt)=999.9
		end if
!!!!!!!!!!!!!!!!!!!fff wind speed reAD
               if(str(65:67).ne."")then
                read(str(65:67),*)fff(k,year,mn,dt)
		!write(*,*)wind
                 else
		fff(k,year,mn,dt)=99
		end if
!!!!!!!!!!!!!!!!!!!aw avg wind speed reAD
               if(str(69:70).ne."")then
                read(str(69:70),*)aw(k,year,mn,dt)
		!write(*,*)wind
                 else
		aw(k,year,mn,dt)=99
		end if              
!!!!!!!!!!!!!!!!!!!rh reAD
               if(str(53:55).ne."")then
                read(str(53:55),*)rh(k,year,mn,dt)
		!write(*,*)wind
                 else
		rh(k,year,mn,dt)=999
		end if 
!!!!!!!!!!!!!!!!!!!vv reAD
               if(str(72:73).ne."")then
                read(str(72:73),*)vv(k,year,mn,dt)
		!write(*,*)wind
                 else
		vv(k,year,mn,dt)=0
		end if 

              end if
	end do
        close(1)
end do
       close(100)

!integer,Dimension(26)::avgrh,avgfff,avgaw

Do k=1,26
write(*,*)k
if(count(slp(k,:,:,:).ne.9.9).ne.0)then
avgslp(K)=(sum(slp(k,:,:,:),MASK=slp(k,:,:,:).ne.9.9))/count(slp(k,:,:,:).ne.9.9)
else
avgslp(K)=9.9
end if
if(count(dbt(k,:,:,:).ne.999.9).ne.0)then
avgdbt(K)=(sum(dbt(k,:,:,:),MASK=dbt(k,:,:,:).ne.999.9))/count(dbt(k,:,:,:).ne.999.9)
else
avgdbt(K)=999.9
end if
if(count(dpt(k,:,:,:).ne.999.9).ne.0)then
avgdpt(K)=(sum(dpt(k,:,:,:),MASK=dpt(k,:,:,:).ne.999.9))/count(dpt(k,:,:,:).ne.999.9)
else
avgdpt(K)=999.9
end if
if(count(rh(k,:,:,:).ne.999).ne.0)then
avgrh(K)=(sum(rh(k,:,:,:),MASK=rh(k,:,:,:).ne.999))/count(rh(k,:,:,:).ne.999)
else
avgrh(K)=999
end if
if(count(fff(k,:,:,:).ne.99).ne.0)then
avgfff(K)=(sum(fff(k,:,:,:),MASK=fff(k,:,:,:).ne.99))/count(fff(k,:,:,:).ne.99)
else
avgfff(K)=99
end if
if(count(aw(k,:,:,:).ne.99).ne.0)then
avgaw(K)=(sum(aw(k,:,:,:),MASK=aw(k,:,:,:).ne.99))/count(aw(k,:,:,:).ne.99)
else
avgaw(K)=99
end if
end do

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

allocate(attr(26,NR,13))

do J=1,NR
    READ(1,'(A10)') date
    read(date(1:4),*)year
    read(date(6:7),*)mn
    read(date(9:10),*)dt
    
 do k=1979,2013
   do l=1,2
     do m=1,31
        if(dt.eq.m .and. mn.eq.l .and. year.eq.k) then
        do f=1,26
        attr(f,j,1)=slp(f,k,l,m)
        attr(f,j,2)=dbt(f,k,l,m)
        attr(f,j,3)=dpt(f,k,l,m)
        attr(f,j,4)=rh(f,k,l,m)
        attr(f,j,5)=fff(f,k,l,m)
        attr(f,j,6)=aw(f,k,l,m)
        attr(f,j,7)=vv(f,k,l,m)
        attr(f,j,8)=slp(f,k,l,m)-avgslp(f)
        attr(f,j,9)=dbt(f,k,l,m)-avgdbt(f)
        attr(f,j,10)=dpt(f,k,l,m)-avgdpt(f)
        attr(f,j,11)=rh(f,k,l,m)-avgrh(f)
        attr(f,j,12)=fff(f,k,l,m)-avgfff(f)
        attr(f,j,13)=aw(f,k,l,m)-avgaw(f)
        end do
        end if
     end do
   end do
 end do
end do
close(1)
open(1000,file="attr.txt")
!do f=1,26
   do k=1,NR
write(1000,*)attr(:,k,:)
   end do
!end do
close(1000)
end program addCriteria
