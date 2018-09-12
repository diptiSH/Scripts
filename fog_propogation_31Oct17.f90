program fog_propogation
IMPLICIT NONE
integer :: j,k,l,m,flag,fog(2139,26)
CHARACTER(LEN=100) :: str(2139) 
CHARACTER(LEN=10) :: datestr(22) 
integer,Dimension(22,15,26)::fog_ind
integer,Dimension(15,26)::fog_station


open(100,file="fog_matrix.txt")
      	DO k=1,2139
	read(100,'(A88)')str(k)
	!write(*,*)str
	!write(*,*)TRIM(str)
        !write(*,*)str(k)(13:88)
        read(str(k)(13:88),'(26(I2.2,X))')fog(k,:)
       ! write(*,*)fog(k,:)
	end do
close(100)

open(200,file="dates.txt")
DO j=1,22
	read(200,'(A10)')datestr(j)
	DO k=1,2139
		if(str(K)(1:10).eq.datestr(j)) then
		        do l=0,14 
		           fog_ind(j,l+1,:)= fog(k+l,:)
                          ! write(*,*)str(K+l)(1:10)
                           ! write(*,*)fog_ind(j,l+1,:)
		         end do
                      exit
                end if
        end do
end do
close(200)

do m=1,26
	do l=1,15
              fog_station(l,m)= sum(fog_ind(:,l,m), MASK=fog_ind(:,l,m) .eq. 1)
              write(*,*)fog_station(l,m)
        end do	
 end do

open(300,file="fog_prop_info.txt")
do m=1,26
      write(300,'(15(I2,X))')fog_station(:,m)
end do

end program fog_propogation
