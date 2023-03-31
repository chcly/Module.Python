find_path(Python_SDK_DIR
    NAMES "python.bat"
    HINTS
        "$ENV{PYTHON_DEV}"
)

find_path(Python_SDK_INCLUDE_DIR
    NAMES  Python.h
    HINTS
        "${Python_SDK_DIR}/Include/"
)

if (Python_SDK_INCLUDE_DIR)
    find_path(Python_SDK_CFG_INCLUDE_DIR
        NAMES  pyconfig.h
        HINTS
            "${Python_SDK_DIR}/PC/"
    )
    if (Python_SDK_CFG_INCLUDE_DIR)
        set(Python_SDK_INCLUDE_DIR ${Python_SDK_INCLUDE_DIR} ${Python_SDK_CFG_INCLUDE_DIR})
    endif()
endif()

find_library(Python_SDK_LIBRARY
    NAMES python310_d.lib
    HINTS
        "${Python_SDK_DIR}/PCBuild/amd64/"
)


macro(include_proj TargetName projectname TargetLocation)
    if (NOT ${TargetName}_IMPORTED)
        set(${TargetName}_IMPORTED ${TargetLocation}/${projectname}.vcxproj CACHE PATH "" FORCE)

        include_external_msproject(
            ${projectname}
            ${TargetLocation}/${projectname}.vcxproj
        )

        add_library(${TargetName} STATIC IMPORTED)
        add_dependencies(${TargetName} ${projectname})
        
        set_property(
          TARGET ${TargetName} APPEND 
            PROPERTY 
            IMPORTED_CONFIGURATIONS RELEASE MINSIZEREL DEBUG
        )

        list(APPEND Python_SDK_LIBRARY ${TargetName})

        set_target_properties(${TargetName} PROPERTIES
            IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG "CXX"
            IMPORTED_LOCATION_DEBUG "${TargetLocation}/amd64/${projectname}_d.lib"
            IMPORTED_LOCATION_RELEASE "${TargetLocation}/amd64/${projectname}.lib"
            MAP_IMPORTED_CONFIG_DEBUG Debug
            MAP_IMPORTED_CONFIG_MINSIZEREL Release
            MAP_IMPORTED_CONFIG_RELWITHDEBINFO Release
            FOLDER "Extern/ThirdParty/Imported"
        )


    endif()
endmacro()




if (Python_SDK_LIBRARY)
    find_path(Python_PROJ_INC
        NAMES  pythoncore.vcxproj
        HINTS "${Python_SDK_DIR}/PCbuild/"
    )

    if (Python_PROJ_INC)
        include_proj(Python_DLL python3dll ${Python_PROJ_INC})
        include_proj(Python_CORE pythoncore ${Python_PROJ_INC})
    endif()
endif()
