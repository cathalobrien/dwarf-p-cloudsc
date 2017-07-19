
if (${CMAKE_Fortran_COMPILER_ID} MATCHES "Clang")
    ecbuild_error("No Fortran compiler exists with this ID")

elseif ("${CMAKE_Fortran_COMPILER_ID}" STREQUAL "GNU")
    ecbuild_add_fortran_flags("-O2"                              )
    ecbuild_add_fortran_flags("-g"                               )
    ecbuild_add_fortran_flags("-fPIC"                            )
    ecbuild_add_fortran_flags("-fopenmp"                         )
    ecbuild_add_fortran_flags("-ffpe-trap=invalid,zero,overflow" )
    ecbuild_add_fortran_flags("-fstack-arrays"                   )
    ecbuild_add_fortran_flags("-fconvert=big-endian"             )
    ecbuild_add_fortran_flags("-fbacktrace"                      )
    ecbuild_add_fortran_flags("-fno-second-underscore"           )
    ecbuild_add_fortran_flags("-ffree-form"                      )
    ecbuild_add_fortran_flags("-ffast-math"                      )

elseif ("${CMAKE_Fortran_COMPILER_ID}" STREQUAL "Intel")
    ecbuild_add_fortran_flags("-O2"                           )
    ecbuild_add_fortran_flags("-g"                            )
    ecbuild_add_fortran_flags("-fpic"                         )
    ecbuild_add_fortran_flags("-qopenmp"                      )
    ecbuild_add_fortran_flags("-qopenmp-threadprivate compat" )
    ecbuild_add_fortran_flags("-assume byterecl"              )
    ecbuild_add_fortran_flags("-convert big_endian"           )
    ecbuild_add_fortran_flags("-traceback"                    )
    ecbuild_add_fortran_flags("-align array64byte"            )
    ecbuild_add_fortran_flags("-warn nounused,nouncalled"     )
    ecbuild_add_fortran_flags("-xHost"                        )
    ecbuild_add_fortran_flags("-finline-functions"            )
    ecbuild_add_fortran_flags("-finline-limit=500"            )
    ecbuild_add_fortran_flags("-Winline"                      )

elseif ("${CMAKE_Fortran_COMPILER_ID}" STREQUAL "PGI")
    ecbuild_add_fortran_flags("-O2"                    )
    ecbuild_add_fortran_flags("-g"                     )
    ecbuild_add_fortran_flags("-fpic"                  )
    ecbuild_add_fortran_flags("-mp"                    )
    ecbuild_add_fortran_flags("-mp=bind,allcores,numa" )
    ecbuild_add_fortran_flags("-Mbyteswapio"           )     
    ecbuild_add_fortran_flags("-Mstack_arrays"         )
    ecbuild_add_fortran_flags("-Mrecursive"            )
    ecbuild_add_fortran_flags("-Ktrap=fp"              )
    ecbuild_add_fortran_flags("-Kieee"                 )
    ecbuild_add_fortran_flags("-Mdaz"                  )
    ecbuild_add_fortran_flags("-Wl, --as-needed"       )

elseif ("${CMAKE_Fortran_COMPILER_ID}" STREQUAL "Cray")
    ecbuild_add_fortran_flags("-O0"                    )
    ecbuild_add_fortran_flags("-hflex_mp=conservative" )
    ecbuild_add_fortran_flags("--hfp1"                 )
    ecbuild_add_fortran_flags("-hadd_paren"            )
    ecbuild_add_fortran_flags("-hcontiguous"           )
    ecbuild_add_fortran_flags("-hbyteswapio"           )
    ecbuild_add_fortran_flags("-Ktrap=fp"              )
    ecbuild_add_fortran_flags("-Wl, --as-needed"       )

endif()
