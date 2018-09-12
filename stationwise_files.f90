program IMD_daily
IMPLICIT NONE
INTEGER, PARAMETER :: maxrecs = 3000000
INTEGER :: J, NR, ios,IndexNo,old_ind,st,i,k,stRecords(131)
CHARACTER(LEN=1) :: junk 
CHARACTER(LEN=133), Allocatable :: record(:)
CHARACTER(LEN=133)::str 
open(1,file="daily_data.txt")
NR=0
st=0
stRecords=0
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
if (j.eq.1)then
old_ind=IndexNo
end if
if(old_ind.ne.IndexNo)then
st=st+1
!write(*,*)old_ind
else
stRecords(st)=stRecords(st)+1
end if
old_ind=IndexNo
end do
write(*,*)stRecords

end program IMD_daily
