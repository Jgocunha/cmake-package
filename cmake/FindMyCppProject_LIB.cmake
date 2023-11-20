# FindMyCppProject_LIB.cmake

# Search for the header file
find_path(MyCppProject_LIB_INCLUDE_DIR NAMES example.h PATHS "${CMAKE_PREFIX_PATH}/include")

# Check if the header file is found
if (MyCppProject_LIB_INCLUDE_DIR)
    set(MyCppProject_LIB_FOUND TRUE)
else ()
    set(MyCppProject_LIB_FOUND FALSE)
endif ()

# Handle the results
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(MyCppProject_LIB
    DEFAULT_MSG
    MyCppProject_LIB_INCLUDE_DIR
)


message(STATUS "MyCppProject_LIB_INCLUDE_DIR: ${MyCppProject_LIB_INCLUDE_DIR}")
message(STATUS "MyCppProject_LIB_LIBRARY: ${MyCppProject_LIB_LIBRARY}")
message(STATUS "MyCppProject_LIB_FOUND: ${MyCppProject_LIB_FOUND}")
