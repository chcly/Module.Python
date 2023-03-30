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

if (Python_SDK_LIBRARY)


endif()

message("Python_SDK_DIR=${Python_SDK_DIR}")
message("Python_SDK_INCLUDE_DIR=${Python_SDK_INCLUDE_DIR}")
message("Python_SDK_LIBRARY=${Python_SDK_LIBRARY}")
