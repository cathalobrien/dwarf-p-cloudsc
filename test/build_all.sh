#! /bin/bash
#script which takes a list of profiles (different flag + module configurations) and builds each one
#binaries are stored in a directory tree at . whith each subdirectory containing the name of its profile

#this script should be called from cloudsc/test
cd /ec/res4/hpcperm/naco/moria/dwarf-p-cloudsc #move into cloudsc/ for ./cloudsc-bundle

ARCH_FILES=("ecmwf/hpc2020/gnu/8.5.0" "ecmwf/hpc2020/intel/2021.4.0")
BUILD_FLAGS=("" "--single-precision") #a binary will be built with each of these flags (single and double precision in this case)
for arch in "${ARCH_FILES[@]}"; do
        for flags in "${BUILD_FLAGS[@]}"; do
		echo "building cloudsc with arch $arch and the following build flags: $flags"

		#load required modules
                source /ec/res4/hpcperm/naco/moria/dwarf-p-cloudsc/arch/$arch/env.sh

		#generate a unique subdir based on arch and flag combo
		subdir=$arch$flags #sticking flags on the end only works when there's just 1 flag...
		#an alternative way would be to give each flag setting a number so you end up with $arch_0, $arch_1 ....

		#build the requested arch
                ./cloudsc-bundle build --clean --with-mpi $flags --arch ./arch/$arch \
			--build-dir test/build/$subdir

	done
done
