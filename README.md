# MyCppProject CMake Package

MyCppProject is a C++ library packaged with CMake, allowing seamless integration into other CMake-based projects using the `find_package` mechanism.

Created based on:
- https://cmake.org/cmake/help/git-master/manual/cmake-packages.7.html#creating-packages
- https://www.foonathan.net/2016/03/cmake-install/

##  Why This Project?

The goal of this project is to create a reusable template CMake package for libraries, making it easy to incorporate them into other projects without dealing with manual configurations.

## Build and Installation Instructions

On your build folder run the following command to be able to find your library with `find_package`:

```cmake
cmake --build . --target install
```

## Integration into Your CMake Project

In your CMakeLists.txt file, add the following lines to find and link against MyCppProject:

```cmake
find_package(MyCppProject REQUIRED)

# Your project target
add_executable(your_target src/main.cpp)

# Link against MyCppProject
target_link_libraries(your_target PRIVATE MyCppProject)
```

Now you can use MyCppProject in your project with the convenience of `find_package`.