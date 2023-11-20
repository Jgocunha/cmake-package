cmake_minimum_required(VERSION 3.15)
project(MyCppProject LANGUAGES CXX)

# Set CXX Standard to C++20
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Check whether VCPKG is set up in your system
if(NOT DEFINED ENV{VCPKG_ROOT})
  message(FATAL_ERROR "ERROR: This project requires VCPKG.\n")
endif()

# Set VCPKG root directory
set(VCPKG_ROOT $ENV{VCPKG_ROOT})

# Include VCPKG toolchain
include(${VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_INCLUDE_CURRENT_DIR_IN_INTERFACE ON)

set(Upstream_VERSION 3.4.1)

include(GenerateExportHeader)

# Add library project
set(LIB_PROJECT ${CMAKE_PROJECT_NAME}_LIB)
#add_library(${LIB_PROJECT} SHARED src/example.cpp)
add_library(${LIB_PROJECT} SHARED include/example.h src/example.cpp)
target_include_directories(${LIB_PROJECT} PRIVATE include)

generate_export_header(${LIB_PROJECT})
set_property(TARGET ${LIB_PROJECT} PROPERTY VERSION ${Upstream_VERSION})
set_property(TARGET ${LIB_PROJECT} PROPERTY SOVERSION 3)
set_property(TARGET ${LIB_PROJECT} PROPERTY
  INTERFACE_${LIB_PROJECT}_MAJOR_VERSION 3)
set_property(TARGET ${LIB_PROJECT} APPEND PROPERTY
  COMPATIBLE_INTERFACE_STRING ${LIB_PROJECT}_MAJOR_VERSION
)

install(TARGETS ${LIB_PROJECT} EXPORT ${LIB_PROJECT}Targets
  LIBRARY DESTINATION lib
  ARCHIVE DESTINATION lib
  RUNTIME DESTINATION bin
  INCLUDES DESTINATION include
)
install(
  FILES
    include/example.h
    #"${CMAKE_CURRENT_BINARY_DIR}/example_export.h"
  DESTINATION
    include
  COMPONENT
    Devel
)

include(CMakePackageConfigHelpers)
write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/${LIB_PROJECT}/${LIB_PROJECT}ConfigVersion.cmake"
  VERSION ${Upstream_VERSION}
  COMPATIBILITY AnyNewerVersion
)

export(EXPORT ${LIB_PROJECT}Targets
  FILE "${CMAKE_CURRENT_BINARY_DIR}/${LIB_PROJECT}/${LIB_PROJECT}Targets.cmake"
  NAMESPACE Upstream::
)
configure_file(cmake/${LIB_PROJECT}Config.cmake
  "${CMAKE_CURRENT_BINARY_DIR}/${LIB_PROJECT}/${LIB_PROJECT}Config.cmake"
  COPYONLY
)

set(ConfigPackageLocation lib/cmake/${LIB_PROJECT})
install(EXPORT ${LIB_PROJECT}Targets
  FILE
    ${LIB_PROJECT}Targets.cmake
  NAMESPACE
    Upstream::
  DESTINATION
    ${ConfigPackageLocation}
)
install(
  FILES
    cmake/${LIB_PROJECT}Config.cmake
    "${CMAKE_CURRENT_BINARY_DIR}/${LIB_PROJECT}/${LIB_PROJECT}ConfigVersion.cmake"
  DESTINATION
    ${ConfigPackageLocation}
  COMPONENT
    Devel
)


find_package(MyCppProject_LIB REQUIRED)
#export(PACKAGE MyCppProject_LIB)
#list(APPEND CMAKE_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}/${ConfigPackageLocation}")

# Add executable project
add_executable(${CMAKE_PROJECT_NAME} src/main.cpp)
target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE include)
target_link_libraries(${CMAKE_PROJECT_NAME} PUBLIC MyCppProject_LIB)

# Setup Catch2
enable_testing()
find_package(Catch2 CONFIG REQUIRED)
include(CTest)
include(Catch)

# Add test project
set(TEST_PROJECT ${CMAKE_PROJECT_NAME}_TEST)
add_executable(${TEST_PROJECT} tests/test_main.cpp tests/test_example.cpp)
target_include_directories(${TEST_PROJECT} PRIVATE include)
target_link_libraries(${TEST_PROJECT} PRIVATE Catch2::Catch2 Catch2::Catch2WithMain ${LIB_PROJECT})

# Automatically discover and add tests
catch_discover_tests(${TEST_PROJECT})
