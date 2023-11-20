find_path(MyCppProject_LIB_INCLUDE_DIR NAMES example.h PATHS "${CMAKE_PREFIX_PATH}/include")
find_library(MyCppProject_LIB_LIBRARY NAMES MyCppProject_LIB PATHS "${CMAKE_PREFIX_PATH}/lib")

if (MyCppProject_LIB_INCLUDE_DIR AND MyCppProject_LIB_LIBRARY)
    set(MyCppProject_LIB_FOUND TRUE)
else ()
    set(MyCppProject_LIB_FOUND FALSE)
endif ()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MyCppProject_LIB DEFAULT_MSG MyCppProject_LIB_INCLUDE_DIR MyCppProject_LIB_LIBRARY)
