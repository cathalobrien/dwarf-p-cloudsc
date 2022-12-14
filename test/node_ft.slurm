#! /bin/bash
#SBATCH --job-name=cloudsc-bm
#SBATCH --qos=np
#SBATCH --nodes=1
#SBATCH --time=0:20:00
#SBATCH --output=ft-cloudsc.%j.out
#SBATCH --error=ft-cloudsc.%j.out

root="/ec/res4/hpcperm/naco/moria/dwarf-p-cloudsc/test"

CPUS_PER_NUMA_REGION=16
CPUS_PER_SOCKET=64
CPUS_PER_NODE=128
NUM_THREADS=($CPUS_PER_NUMA_REGION $CPUS_PER_SOCKET $CPUS_PER_NODE)

#set some runtime parameters
export OMP_SCHEDULE=dynamic
NCOLS=1310720
NPROMA_SIZES=(32)
iterations=3

#openmp x mpi geometry (how many tasks vs threads will be used)
THREAD_TASK_RATIO=(4) #how many threads each task will be allocated, 16 is the max bc you don't want a task spanning multiple NUMA regions

#benchmark different builds
ARCH_FILES=("ecmwf/hpc2020/gnu/8.5.0" "ecmwf/hpc2020/intel/2021.4.0")
BUILD_FLAGS=("" "--single-precision")

#launch the runs
echo "*	NUMOMP    NGPTOT  #GP-cols     #BLKS    NPROMA tid# : Time(msec)  MFlops/s"
for arch in "${ARCH_FILES[@]}"; do
	for flags in "${BUILD_FLAGS[@]}"; do
		echo "benchmarking cloudsc built for $arch with the following flags: $flags"
		subdirectory="build/$arch$flags/" 
		cd $root/$subdirectory
		#get flags and load the correct modules
		source env.sh
		awk -f $root/get_flags.awk toolchain.cmake
		for thread_count in "${NUM_THREADS[@]}"; do
			for threads_per_task in "${THREAD_TASK_RATIO[@]}"; do
				ntasks=$(expr $thread_count / $threads_per_task)
				for NP in "${NPROMA_SIZES[@]}"; do
					for ((i = 0 ; i < $iterations ; i++)); do
						echo "thread_count $thread_count ntasks $ntasks threads_per_task $threads_per_task ncols $NCOLS nproma $NP arch $arch flag $flags"
						srun --hint=nomultithread --cpus-per-task=$threads_per_task \
							--ntasks=$ntasks env OMP_NUM_THREADS=$threads_per_task env OMP_PLACES=cores \
							bin/dwarf-cloudsc-fortran $threads_per_task $NCOLS $NP
					done
				done
			done
		done
	done
done
