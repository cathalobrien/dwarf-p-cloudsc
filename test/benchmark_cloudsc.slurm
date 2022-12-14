#! /bin/bash
#SBATCH --job-name=cloudsc-bm
#SBATCH --qos=np
#SBATCH --nodes=1
#SBATCH --time=1:00:00
#SBATCH --output=cloudsc.%j.out
#SBATCH --error=cloudsc.%j.out

export OMP_SCHEDULE=dynamic 

#read a command line arg which defines the benchmarking session

if [ -z "$1" ]; then #check if config file has been given, if not do a toy run
	echo "usage: sbatch benchmark_cloudsc.slurm [bm_config.env]"
	echo "no config provided so doing a simple demo run (see .demo.env)"
	source .demo.env
else #load the provided config file
	source $1
fi

cd /ec/res4/hpcperm/naco/moria/dwarf-p-cloudsc/test #ensure any relative addressing works wherever the script is called from

#print a summary of this benchmarking session
echo "Benchmarking the following arches: ${ARCH_FILES[*]}"
echo "Benchmarking the following build flags: ${BUILD_FLAGS[*]}"
echo "Benchmarking the following number of CPUs: ${NUM_THREADS[*]}"
echo "Benchmarking the following number of NPROMA values: ${NPROMA_SIZES[*]}"
echo "Benchmarking the following number of columns: ${NCOLS[*]}"
echo "Benchmarking the following number of OpenMP threads per MPI task: ${THREAD_TASK_RATIO[*]}" #useful when looking for a shared L3 cache
total_runs=$((${#ARCH_FILES[@]} * ${#BUILD_FLAGS[@]} * ${#NUM_THREADS[@]} * ${#NPROMA_SIZES[@]} * ${#NCOLS[@]} * ${#THREAD_TASK_RATIO[@]} * $iterations))
echo "Performing each configuration $iterations times, for a total of $total_runs runs"

root="/ec/res4/hpcperm/naco/moria/dwarf-p-cloudsc/test" #location containing the different build subdirs

#launch the runs
for arch in "${ARCH_FILES[@]}"; do
	for flags in "${BUILD_FLAGS[@]}"; do
		echo "benchmarking cloudsc built for $arch with the following flags: $flags"
		subdirectory="build/$arch$flags/"
		cd $root/$subdirectory
		#get flags and load the correct modules
		source env.sh
		awk -f $root/get_flags.awk toolchain.cmake

		for thread_count in "${NUM_THREADS[@]}"; do
			for ncols in "${NCOLS[@]}"; do
				for NP in "${NPROMA_SIZES[@]}"; do
					for threads_per_task in "${THREAD_TASK_RATIO[@]}"; do
						ntasks=$(expr $thread_count / $threads_per_task)
						for ((i = 0 ; i < $iterations ; i++)); do
							echo "thread_count $thread_count ntasks $ntasks threads_per_task $threads_per_task ncols $ncols nproma $NP arch $arch flag $flags"
							srun --hint=nomultithread --cpus-per-task=$threads_per_task \
								--ntasks=$ntasks env OMP_NUM_THREADS=$threads_per_task env OMP_PLACES=cores \
								bin/dwarf-cloudsc-fortran $threads_per_task $ncols $NP
						done
					done
				done
			done
		done
	done
done
