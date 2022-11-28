BEGIN 	{
	OFS=",";
	ORS=""; #remove ORS bc we don't want automatic \n

	#This only works when you read toolchain.cmake under arch/ not build/
	#split(ARGV[1], filename, "/");
	#arch=filename[3]
	#compiler=filename[4]
	#comp_version=filename[5]
	#print arch "-" compiler " flags: "
	print "Flags: "
	}

$1 ~ /Fortran/ {
	if (length($3) == 0) { #the first flag will not be appended
		flag=substr($2, 1, length($2)-2)
		print substr(flag, 2, length(flag)) " "
		}
	else {
		#the third field contains the flag, subtract the final 2 chars from the end bc they're ")
		print substr($3, 1, length($3)-2) " " 
		}
}

END 	{
        print "\n"
	#print FILENAME "\n";
	#split(FILENAME, array, "/");
	#print array[2] "\n"
	}

#set(ECBUILD_Fortran_FLAGS "${ECBUILD_Fortran_FLAGS} -ffpe-trap=invalid,zero,overflow")