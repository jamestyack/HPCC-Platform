################################################################################
#    HPCC SYSTEMS software Copyright (C) 2012 HPCC Systems.
#
#    Licensed under the Apache License, Version 2.0 (the "License");
#    you may not use this file except in compliance with the License.
#    You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS,
#    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#    See the License for the specific language governing permissions and
#    limitations under the License.
################################################################################


# Component: pyembed

#####################################################
# Description:
# ------------
#    Cmake Input File for pyembed
#####################################################

set ( debug_python Off )   # A lot slower but can assist in debugging...
SET ( DEBUG_PYTHON_LIBRARY "/usr/lib/libpython2.7_d.so" )

project( pyembed )

if (USE_PYTHON)
  ADD_PLUGIN(pyembed PACKAGES PythonLibs OPTION MAKE_PYEMBED MINVERSION 2.6 MAXVERSION 2.7)
  if ( MAKE_PYEMBED )
    set ( SRCS
          pyembed.cpp
        )

    include_directories (
         "${PYTHON_INCLUDE_DIR}"
         ./../../system/include
         ./../../rtl/eclrtl
         ./../../rtl/include
         ./../../rtl/nbcd
         ./../../common/deftype
         ./../../roxie/roxiemem
         ./../../system/jlib
       )

    ADD_DEFINITIONS( -D_USRDLL -DPYEMBED_EXPORTS )
    if (debug_python)
      ADD_DEFINITIONS(-DPy_DEBUG)
    endif()

    HPCC_ADD_LIBRARY( pyembed SHARED ${SRCS} )
    if (${CMAKE_VERSION} VERSION_LESS "2.8.9")
      message("WARNING: Cannot set NO_SONAME. shlibdeps will give warnings when package is installed")
    else()
      set_target_properties( pyembed PROPERTIES NO_SONAME 1 )
    endif()

    install ( TARGETS pyembed DESTINATION plugins )
    if (debug_python)
      target_link_libraries ( pyembed ${DEBUG_PYTHON_LIBRARY} )
    else()
      target_link_libraries ( pyembed ${PYTHON_LIBRARY} )
    endif()

    target_link_libraries ( pyembed
        eclrtl
        roxiemem
        jlib
        )
  endif()
endif()
# Even if not making the Python plugin, we want to install the header
install ( FILES ${CMAKE_CURRENT_SOURCE_DIR}/python.ecllib DESTINATION plugins COMPONENT Runtime)
