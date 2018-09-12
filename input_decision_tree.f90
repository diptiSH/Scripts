program Input_decision_tree
IMPLICIT NONE
INTEGER, PARAMETER :: maxrecs = 30000000
Integer :: J, NR, ios,IndexNo,OldIndex, nfiles
CHARACTER(LEN=1) :: junk 
CHARACTER(LEN=133) :: str 
Integer, Allocatable :: ObsNo(:)
CHARACTER(LEN=133), Allocatable :: Obsstr(:,:)

open(1,file="hr_data.txt")
NR=0
!!!!!!!!!!! Get total number of records
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

OldIndex=05211
nfiles=1

!!!!!!!!!!! Get total number of files
DO J=1,NR
		read(1,'(A133)')str
		!write(*,*)str
                read(str(1:5),*)IndexNo
		if(OldIndex .ne. IndexNo) then
                  ! write(*,*)IndexNo
                   OldIndex=IndexNo
                   nfiles=nfiles+1
                end if
end do
write(*,*)nfiles
REWIND(1)

!!!!!!!!!!! Get total number of obs for each file
allocate(ObsNo(nfiles))
nfiles=1
ObsNo=1
OldIndex=05211
write(*,*)ObsNo

DO J=1,NR
		read(1,'(A133)')str
		!write(*,*)str
                read(str(1:5),*)IndexNo
		if(OldIndex .ne. IndexNo) then
                  ! write(*,*)IndexNo
                  ! write(*,*)ObsNo
                  ! ObsNo(nfiles)=1
                   OldIndex=IndexNo
                   nfiles=nfiles+1
                else
                    if(J .ne. 1) then
                    ObsNo(nfiles)=ObsNo(nfiles)+1
                    end if
                end if
end do
REWIND(1)


do j=1,nfiles
write(*,*)ObsNo(j)
end do


end program Input_decision_tree
