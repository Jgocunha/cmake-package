cmake_minimum_required(VERSION 3.15)
project(MyCppProject LANGUAGES CXX)

# define library version (update: apparently you can also do it in project()!)
set(MY_LIBRARY_VERSION_MAJOR 1 CACHE STRING "major version" FORCE)
set(MY_LIBRARY_VERSION_MINOR 0 CACHE STRING "minor version" FORCE)
set(MY_LIBRARY_VERSION ${MY_LIBRARY_VERSION_MAJOR}.${MY_LIBRARY_VERSION_MINOR} CACHE STRING "version" FORCE)

set(MY_CPP_PROJECT_INC_INSTALL_DIR "include")
set(MY_CPP_PROJECT_RUNTIME_INSTALL_DIR   "bin")
set(MY_CPP_PROJECT_LIBRARY_INSTALL_DIR   "bin")
set(MY_CPP_PROJECT_ARCHIVE_INSTALL_DIR   "lib")
set(MY_CPP_PROJECT_FRAMEWORK_INSTALL_DIR "bin")
set(MY_CPP_PROJECT_CMAKE_CONFIG_INSTALL_DIR "share/MyCppProject/cmake")
set(MY_CPP_PROJECT_ADDITIONAL_FILES_INSTALL_DIR "share/MyCppProject")
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")

# set headers
set(header include/example.h)

# set source files
set(src src/example.cpp)

# define library target
add_library(MyCppProject ${header} ${src})

target_include_directories(MyCppProject PUBLIC 
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include> 
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}> 
    $<INSTALL_INTERFACE:${MY_CPP_PROJECT_INC_INSTALL_DIR}> 
    PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/include
)
target_compile_definitions(MyCppProject PUBLIC
                            MY_CPP_PROJECT=1
                            MY_CPP_PROJECT_VERSION_MAJOR=${MY_LIBRARY_VERSION_MAJOR}
                            MY_CPP_PROJECT_VERSION_MINOR=${MY_LIBRARY_VERSION_MINOR}
)

set_target_properties(MyCppProject PROPERTIES
                                       OUTPUT_NAME "MyCppProject-${MY_LIBRARY_VERSION}"
                                       POSITION_INDEPENDENT_CODE ON
)

install(TARGETS MyCppProject EXPORT MyCppProjectTargets
        RUNTIME       DESTINATION ${MY_CPP_PROJECT_RUNTIME_INSTALL_DIR}
        LIBRARY       DESTINATION ${MY_CPP_PROJECT_LIBRARY_INSTALL_DIR}
        ARCHIVE       DESTINATION ${MY_CPP_PROJECT_ARCHIVE_INSTALL_DIR}
        FRAMEWORK     DESTINATION ${MY_CPP_PROJECT_FRAMEWORK_INSTALL_DIR}
)

include(CMakePackageConfigHelpers)
set(version_file "${CMAKE_CURRENT_BINARY_DIR}/cmake/MyCppProject-config-version.cmake")
write_basic_package_version_file(${version_file}
                                 VERSION ${MY_LIBRARY_VERSION}
                                 COMPATIBILITY AnyNewerVersion)

install(FILES ${header} DESTINATION ${MY_CPP_PROJECT_INC_INSTALL_DIR})

install(EXPORT MyCppProjectTargets DESTINATION ${MY_CPP_PROJECT_CMAKE_CONFIG_INSTALL_DIR}
                                       FILE MyCppProject-config.cmake
)

# Add executable project
add_executable(${CMAKE_PROJECT_NAME}_exe src/main.cpp)
target_include_directories(${CMAKE_PROJECT_NAME}_exe PRIVATE include)
target_link_libraries(${CMAKE_PROJECT_NAME}_exe PRIVATE MyCppProject)

# on your build folder run the following command to be able to find this package with find_package
# cmake --build . --target install