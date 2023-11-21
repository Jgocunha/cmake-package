cmake_minimum_required(VERSION 3.15)
project(MyCppProject LANGUAGES CXX)

# define library version (update: apparently you can also do it in project()!)
set(MY_LIBRARY_VERSION_MAJOR 1 CACHE STRING "major version" FORCE)
set(MY_LIBRARY_VERSION_MINOR 0 CACHE STRING "minor version" FORCE)
set(MY_LIBRARY_VERSION ${MY_LIBRARY_VERSION_MAJOR}.${MY_LIBRARY_VERSION_MINOR} CACHE STRING "version" FORCE)

# some options
option(MY_LIBRARY_USE_FANCY_NEW_CLASS "whether or not to use fancy new class" ON)
option(MY_LIBRARY_DEBUG_MODE "whether or not debug mode is activated" OFF)

# set headers
set(header include/example.h)

# set source files
set(src src/example.cpp)
		
# configure config.hpp.in
#configure_file("config.hpp.in" "${CMAKE_CURRENT_BINARY_DIR}/config_impl.hpp")

# define library target
add_library(my_library ${header} ${src})
#target_include_directories(my_library PUBLIC ${MY_LIBRARY_SOURCE_DIR}/include ${CMAKE_CURRENT_BINARY_DIR})
target_include_directories(my_library PUBLIC
                       $<BUILD_INTERFACE:${MY_LIBRARY_SOURCE_DIR}/include> # for headers when building
					   $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}> # for config_impl.hpp when building
                       $<INSTALL_INTERFACE:${include_dest}> # for client in install mode
                       $<INSTALL_INTERFACE:${lib_dest}> # for config_impl.hpp in install mode
)


set(tool_dest "bin")
set(include_dest "include/my_library-${MY_LIBRARY_VERSION}")
set(main_lib_dest "lib/my_library-${MY_LIBRARY_VERSION}")
set(lib_dest "${main_lib_dest}/${CMAKE_BUILD_TYPE}")

install(TARGETS my_library DESTINATION "${main_lib_dest}")
install(FILES ${header} DESTINATION "${include_dest}")
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/config_impl.hpp DESTINATION "${include_dest}")


install(TARGETS my_library EXPORT my_library DESTINATION "${lib_dest}")
install(EXPORT my_library DESTINATION "${lib_dest}")

install(FILES my_library-config.cmake DESTINATION ${main_lib_dest})
install(EXPORT ...)