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

# Add library project
set(LIB_PROJECT ${CMAKE_PROJECT_NAME}_LIB)
add_library(${LIB_PROJECT} INTERFACE include/example.h src/example.cpp)
#target_include_directories(${LIB_PROJECT} PRIVATE include)
target_include_directories(${LIB_PROJECT} INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)
# Optionally, link any dependencies here
# target_link_libraries(${LIB_PROJECT} INTERFACE SomeDependency)

install(DIRECTORY include/ DESTINATION include)
install(TARGETS ${LIB_PROJECT}
    EXPORT ${CMAKE_PROJECT_NAME}Targets
)

include(CMakePackageConfigHelpers)

# Generate the package configuration file
configure_package_config_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/cmake/MyCppProjectConfig.cmake.in
    ${CMAKE_CURRENT_BINARY_DIR}/MyCppProjectConfig.cmake
    INSTALL_DESTINATION lib/cmake/MyCppProject
)

# Install the package configuration file
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/MyCppProjectConfig.cmake
    DESTINATION lib/cmake/MyCppProject
)

export(EXPORT ${CMAKE_PROJECT_NAME}Targets
    FILE ${CMAKE_CURRENT_BINARY_DIR}/MyCppProjectTargets.cmake
    NAMESPACE MyCppProject::
)

# Install the exported targets file
install(EXPORT ${CMAKE_PROJECT_NAME}Targets
    FILE MyCppProjectTargets.cmake
    NAMESPACE MyCppProject::
    DESTINATION lib/cmake/MyCppProject
)

# Add executable project
#add_executable(${CMAKE_PROJECT_NAME} src/main.cpp)
#target_include_directories(${CMAKE_PROJECT_NAME} PRIVATE include)
#target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE ${LIB_PROJECT})

find_package(MyCppProject_LIB REQUIRED)
add_executable(${CMAKE_PROJECT_NAME} src/main.cpp)
target_link_libraries(${CMAKE_PROJECT_NAME} PRIVATE MyCppProject::MyCppProject_LIB)

# Setup Catch2
#enable_testing()
#find_package(Catch2 CONFIG REQUIRED)
#include(CTest)
#include(Catch)

# Add test project
#set(TEST_PROJECT ${CMAKE_PROJECT_NAME}_TEST)
#add_executable(${TEST_PROJECT} tests/test_main.cpp tests/test_example.cpp)
#target_include_directories(${TEST_PROJECT} PRIVATE include)
#target_link_libraries(${TEST_PROJECT} PRIVATE Catch2::Catch2 Catch2::Catch2WithMain ${LIB_PROJECT})

# Automatically discover and add tests
#catch_discover_tests(${TEST_PROJECT})