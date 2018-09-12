program UP_IMD
IMPLICIT NONE
INTEGER, PARAMETER :: maxrecs = 1000000
INTEGER :: J, NR, ios, IndexNo, year,mn,hr,dt,rh,vp,dd,fff,aw,vv
CHARACTER(LEN=1) :: junk 
real :: slp,mslp,dbt,wbt,dpt

open(1,file="hr_data.txt")
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
!close(1)

write(*,*)NR

DO J=1,NR
READ(1,'(I5,X,I4,3(X,I2),X,2(f6.1,X))')IndexNo,year,mn,hr,dt,slp,mslp
write(*,*)J
write(*,*)IndexNo,year,mn,hr,dt,slp,mslp
END DO

end program UP_IMD
