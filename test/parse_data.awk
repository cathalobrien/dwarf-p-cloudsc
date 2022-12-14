BEGIN 	{ 
	OFS=",";
	ORS=""; #remove automatic newline between rows bc we want to merge multiple matches into 1 row
	}
$1 ~ /\*/ {
	$1 = "NUMTASKS"
	print "thread_count", "num_tasks", "threads_per_task", $4, $6, "arch", "flags", $9, $10 "\n";
	}
#thread_count 128 ntasks 32 threads_per_task 4 nproma 32 arch ecmwf/hpc2020/intel/2021.4.0 flag --single-precision
$1 ~ /^thread_count$/ {
	print $2, $4, $6, $8, $10, $12, $14;
	}
$2 ~ /^x$/{ 
	print "", $10, $11 "\n";
	}


END 	{ }
