BEGIN 	{ 
	OFS=",";
	}
$1 ~ /\*/ {
	$1 = "NUMTASKS"
	print $1, $2, $4, $5, $6, $9, $10}
$2 ~ /^x$/{ $2 = "";
	#$4 = "";
	#print $0 
	split(FILENAME, array, "-")
	print $1, $3, $5, $6, $7, $10, $11
	}
END 	{ }
