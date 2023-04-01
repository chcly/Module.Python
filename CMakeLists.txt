cmake_minimum_required(VERSION 3.15)
project(Python)

# Use C++-17 by default.
enable_language(CXX)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


# Set the module path to include scripts
# CMake - Contains project local modules.
#
# CMake/Modules - Contains project independent modules.
#   GitUpdate.cmake invokes python ${Python_SOURCE_DIR}/gitupdate.py
#   to pull all submodules and update to head.
#   If this fails, it will attempt to invoke git directly to pull 
#   submodules. 
list(APPEND CMAKE_MODULE_PATH 
  ${Python_SOURCE_DIR}/CMake 
  ${Python_SOURCE_DIR}/CMake/Modules
)
include(Configure)
if (NOT Configure_SUCCEEDED)
   return()
endif()

if (Python_ExternalTarget)
    set(TargetFolders ${Python_TargetFolders})
    set(TargetName    ${Python_TargetName})
    set(TargetGroup   ${Python_TargetGroup})
else()
    include(${Utils_DIRECTORY}/CMake/Locals.cmake)
    add_subdirectory(CMake)

    if (NOT Python_SDK_DIR)
        message("The python source was not found")
        return()
    endif()

    add_subdirectory(Internal/Utils)

    set(TargetFolders TRUE)
    set(TargetName Python)
    set(TargetGroup )

    set(Python_INCLUDE  ${Python_SOURCE_DIR} ${Python_SDK_INCLUDE})
    set(Python_LIBRARY  ${TargetName} Python310)
endif()

add_subdirectory(Source)

if (Python_BUILD_TEST)
    if (NOT Python_ExternalTarget)
        add_gtest_source(Extern/ThirdParty)
    endif()

    set(TargetGroup Units)
    add_subdirectory(Test)
endif()
