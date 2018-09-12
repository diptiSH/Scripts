program Input_decision_tree
IMPLICIT NONE
INTEGER, PARAMETER :: maxrecs = 30000000
Integer :: J, NR, ios,IndexNo,OldIndex, nfiles
CHARACTER(LEN=1) :: junk 
CHARACTER(LEN=133) :: str 
Integer, Allocatable :: ObsNo(:),indices(:)
CHARACTER(LEN=133), Allocatable :: Obsstr(:,:)
CHARACTER(LEN=9) :: fname
CHARACTER(LEN=5) :: indname

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
allocate(indices(nfiles))
nfiles=1
ObsNo=1
OldIndex=05211
write(*,*)ObsNo
indices(1)=05211
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
                   indices(nfiles)=OldIndex
                else
                    if(J .ne. 1) then
                    ObsNo(nfiles)=ObsNo(nfiles)+1
                    end if
                end if
end do
REWIND(1)


do j=1,nfiles
!write(*,*)ObsNo(j)
write(*,*)indices(j)
end do

 write (indname,'(I5.5)') indices(1)
fname=trim(indname)//".txt"
write(*,*)fname
open(900,file=fname)
OldIndex=05211
DO J=1,NR
		read(1,'(A133)')str
		!write(*,*)str
                read(str(1:5),*)IndexNo
		if(OldIndex .ne. IndexNo) then
                  close(900)
                   write(*,*)IndexNo
                  ! write(*,*)ObsNo
                  ! ObsNo(nfiles)=1
                   OldIndex=IndexNo
                   nfiles=nfiles+1
                   write (indname,'(I5.5)') IndexNo
                   fname=trim(indname)//".txt"
                  write(*,*)fname
                   open(900,file=fname)
                 end if
                write(900,'(A133)')str
 
end do



end program Input_decision_tree
