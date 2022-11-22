#! /bin/bash
#SBATCH --job-name=cloudsc-bm
#SBATCH --qos=np
#SBATCH --nodes=1
#SBATCH --time=0:20:00
#SBATCH --output=ft-cloudsc.%j.out
#SBATCH --error=ft-cloudsc.%j.out

#setup enviorment by loading modules and setting constants
#need to make some sort of way to automatically select the correct arch
source /ec/res4/hpcperm/naco/moria/dwarf-p-cloudsc/build/env.sh
#source  /ec/res4/hpcperm/naco/moria/dwarf-p-cloudsc/arch/ecmwf/hpc2020/gnu/9.3.0/env.sh
CPUS_PER_NUMA_REGION=16
CPUS_PER_SOCKET=64
CPUS_PER_NODE=128
NUM_THREADS=($CPUS_PER_NUMA_REGION $CPUS_PER_SOCKET $CPUS_PER_NODE)
cd /ec/res4/hpcperm/naco/moria/dwarf-p-cloudsc/build

#set some runtime parameters
export OMP_SCHEDULE=dynamic
#NCOLS=163840 #how large will the jobs computational workload be
NCOLS=1310720
#NPROMA_SIZES=(4 12 32 64 128 256) #how many chunks to break the total workload into
NPROMA_SIZES=(32)
iterations=3


#openmp x mpi geometry (how many tasks vs threads will be used)
THREAD_TASK_RATIO=(4) #how many threads each task will be allocated, 16 is the max bc you don't want a task spanning multiple NUMA regions

#launch the runs
echo "*	NUMOMP    NGPTOT  #GP-cols     #BLKS    NPROMA tid# : Time(msec)  MFlops/s"
for thread_count in "${NUM_THREADS[@]}"; do
	for threads_per_task in "${THREAD_TASK_RATIO[@]}"; do
		ntasks=$(expr $thread_count / $threads_per_task)
		echo "thread_count threads_per_task ntasks"
		echo $thread_count $threads_per_task $ntasks 
		#export OMP_NUM_THREADS=$thread_count
		#export OMP_PLACES=cores
		for NP in "${NPROMA_SIZES[@]}"; do
			#for ((i = 0 ; i < $iterations ; i++)); do
			#	srun --hint=nomultithread --cpus-per-task=$threads_per_task \
		       	#		--ntasks=$ntasks /ec/res4/hpcperm/naco/moria/dwarf-p-cloudsc/build/bin/dwarf-cloudsc-fortran $threads_per_task $NCOLS $NP
			#done
			for ((i = 0 ; i < $iterations ; i++)); do
				echo "thread_count $thread_count ntasks $ntasks threads_per_task $threads_per_task nproma $NP"
				srun --hint=nomultithread --cpus-per-task=$threads_per_task \
					--ntasks=$ntasks env OMP_NUM_THREADS=$threads_per_task env OMP_PLACES=cores \
					/ec/res4/hpcperm/naco/moria/dwarf-p-cloudsc/build/bin/dwarf-cloudsc-fortran $threads_per_task $NCOLS $NP
			done
		done
	done
done
