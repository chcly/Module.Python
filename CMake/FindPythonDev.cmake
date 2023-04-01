find_path(Python_SDK_DIR NAMES "pyconfig.h.in" HINTS "$ENV{PYTHON_DEV}")
if (NOT Python_SDK_DIR)
    return()
endif()

option(Python_SDK_IMPORT_TARGETS 
"Builds the external python source along with the project this is included in" OFF)

function(cache_list_prefix PREFIX)
    foreach(LI ${ARGN})
        get_filename_component(V1 ${LI} NAME_WE)
        set(${PREFIX}_${V1} ${LI}
            CACHE PATH ""
           FORCE
        )
    endforeach()
endfunction()

function(clear_list_prefix PREFIX)
    foreach(LI ${ARGN})
        get_filename_component(V1 ${LI} NAME_WE)
        unset(${PREFIX}_${V1} CACHE )
    endforeach()
endfunction()

function(search_python_source_dist 
        Python_SDK_INCLUDE
        Python_SDK_LIBRARY_DBG
        Python_SDK_LIBRARY_REL
        Python_SDK_SO_DBG
        Python_SDK_SO_REL)

    find_path(
        PYTHON_INCLUDE
        NAMES Python.h
        HINTS "${Python_SDK_DIR}/Include/"
    )


    find_path(
        PYCONFIG_INCLUDE
        NAMES pyconfig.h
        HINTS "${Python_SDK_DIR}/PC/"
    )

    
    find_path(
        PY310_LIBRARY_PATH
        NAMES python310_d.lib python310.lib
        HINTS "${Python_SDK_DIR}/PCBuild/amd64/"
    )


    if (PYTHON_INCLUDE AND PYCONFIG_INCLUDE)
        set(${Python_SDK_INCLUDE}
            ${PYTHON_INCLUDE}
            ${PYCONFIG_INCLUDE}
            CACHE
            PATH "" FORCE
        )
    endif()

    if (PY310_LIBRARY_PATH)
        
        file(GLOB LIB_DEBUG ${PY310_LIBRARY_PATH}/py*_d.lib)
        file(GLOB LIB_REL ${PY310_LIBRARY_PATH}/py*.lib)

        file(GLOB DLL_DEBUG ${PY310_LIBRARY_PATH}/py*_d.dll)
        file(GLOB DLL_REL ${PY310_LIBRARY_PATH}/py*.dll)


        cache_list_prefix(Python_LIB_DBG ${LIB_DEBUG})
        cache_list_prefix(Python_LIB_REL ${LIB_REL})
        cache_list_prefix(Python_DLL_DBG ${DLL_DEBUG})
        cache_list_prefix(Python_DLL_REL ${DLL_REL})

    endif()

    
endfunction()

function(clear_temp)

    if (PY310_LIBRARY_PATH)
        
        file(GLOB LIB_DEBUG ${PY310_LIBRARY_PATH}/py*_d.lib)
        file(GLOB LIB_REL ${PY310_LIBRARY_PATH}/py*.lib)

        file(GLOB DLL_DEBUG ${PY310_LIBRARY_PATH}/py*_d.dll)
        file(GLOB DLL_REL ${PY310_LIBRARY_PATH}/py*.dll)


        clear_list_prefix(Python_LIB_DBG ${LIB_DEBUG})
        clear_list_prefix(Python_LIB_REL ${LIB_REL})
        clear_list_prefix(Python_DLL_DBG ${DLL_DEBUG})
        clear_list_prefix(Python_DLL_REL ${DLL_REL})

    endif()
    unset(PYTHON_INCLUDE CACHE)
    unset(PYCONFIG_INCLUDE CACHE)
    unset(PY310_LIBRARY_PATH CACHE)

endfunction()

macro(add_import Name D1 R1)
    if (NOT ${Name}_IMPORTED)
        set(${Name}_IMPORTED TRUE PARENT_SCOPE)

        if (NOT EXISTS ${Python_LIB_DBG_${D1}})
            message("Build the python source first!")
            clear_temp()
            return()
        endif()

        add_library(${Name} STATIC IMPORTED)

        set_property(
            TARGET ${Name} APPEND 
                PROPERTY 
                IMPORTED_CONFIGURATIONS RELEASE DEBUG MINSIZEREL RELWITHDEBINFO
            )



            message("${Python_LIB_DBG_${D1}}")

        set_target_properties(
            ${Name} 
            PROPERTIES
            IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG  "CXX"
            IMPORTED_LOCATION_DEBUG                  "${Python_LIB_DBG_${D1}}"
            IMPORTED_LOCATION_RELEASE                "${Python_LIB_REL_${R1}}"
            MAP_IMPORTED_CONFIG_DEBUG                Debug
            MAP_IMPORTED_CONFIG_MINSIZEREL           Release
            MAP_IMPORTED_CONFIG_RELWITHDEBINFO       Release
            MAP_IMPORTED_CONFIG_RELEASE              Release
        )
    endif()
endmacro()



macro(include_projects)

    if (NOT PyVsProjects_IMPORTED)
        set(PyVsProjects_IMPORTED TRUE PARENT_SCOPE)
        file(GLOB V1 "${PY310_LIBRARY_PATH}/../py*.vcxproj")


        foreach(L1 ${V1})
            get_filename_component(V2 ${L1} NAME_WE)

            set(TargetName "${V2}")
            include_external_msproject(
                ${TargetName}
                ${L1}
            )

            set_target_properties(
                ${TargetName} 
                PROPERTIES FOLDER "Extern/ThirdParty/Python"
            )
        endforeach()
    endif()
endmacro()

function(import_targets)

    search_python_source_dist(
        Python_SDK_INCLUDE 
        Python_SDK_LIBRARY_DEBUG 
        Python_SDK_LIBRARY_RELEASE
        Python_SDK_DLL_DEBUG 
        Python_SDK_DLL_RELEASE
    )
    if (Python_SDK_IMPORT_TARGETS)
        include_projects()
    endif()

    add_import(Python310  python310_d python310)

    clear_temp()

endfunction()

import_targets()

