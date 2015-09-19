cmake_minimum_required(VERSION 3.0.0)

#####################
# Project information 

FILE(READ ${CMAKE_SOURCE_DIR}/PROJECT PRJ_NAME)
STRING(REGEX REPLACE "\n" "" PRJ_NAME "${PRJ_NAME}") # get rid of the newline at the end


#Get Version
###############
FILE(READ ${CMAKE_SOURCE_DIR}/VERSION PRJ_VERSION)

string(REGEX REPLACE "\n" "" PRJ_VERSION "${PRJ_VERSION}") # get rid of the newline at the end
string(REPLACE "." ";" PRJ_VERSION_STR ${PRJ_VERSION})
set (PRJ_VERSION_LIST ${PRJ_VERSION_STR})
separate_arguments(PRJ_VERSION_LIST)


list(LENGTH PRJ_VERSION_LIST PRJ_VERSION_SIZE)
list(GET PRJ_VERSION_LIST 0 PRJ_VERSION_MAJOR)
list(GET PRJ_VERSION_LIST 1 PRJ_VERSION_MINOR)

set(PRJ_VERSION_BUGFIX 0)
set(PRJ_VERSION_TWEAK 0)

if(PRJ_VERSION_SIZE EQUAL 3)
    list(GET PRJ_VERSION_LIST 2 PRJ_VERSION_BUGFIX)
else(PRJ_VERSION_SIZE EQUAL 3)
    set(PRJ_VERSION_BUGFIX 0)
endif(PRJ_VERSION_SIZE EQUAL 3)

# Find Git Version tweak
find_package(Git)
if(GIT_FOUND)
    execute_process(
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
        OUTPUT_VARIABLE GIT_OUT OUTPUT_STRIP_TRAILING_WHITESPACE

    )
	if (NOT GIT_OUT)
		set (GIT_OUT 0)
	endif()
	set (GIT_OUT 0)
    set(PRJ_VERSION_TWEAK "${GIT_OUT}")
endif(GIT_FOUND)

#-----------------------------------------------------------------------------------------
project(${PRJ_NAME} VERSION ${PRJ_VERSION_MAJOR}.${PRJ_VERSION_MINOR}.${PRJ_VERSION_BUGFIX}.${PRJ_VERSION_TWEAK})

message("-------------------------------------------------------------")
message("Building ${PROJECT_NAME} - ${PROJECT_VERSION} for ${CMAKE_SYSTEM}")
message("-------------------------------------------------------------")


# OS Selection
#
#

if(APPLE)
    # enable @rpath in the install name for any shared library being built
    # note: it is planned that a future version of CMake will enable this by default
    set(CMAKE_MACOSX_RPATH 1)
endif() 


SET_PROPERTY(GLOBAL PROPERTY USE_FOLDERS ON)



# Default configuration values. These must be before the project command or
# they won't work in Windows.
# If no build type is specified, default to "Release"
if (NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release CACHE STRING
      "None Debug Release RelWithDebInfo MinSizeRel"
      FORCE)
endif()


#PARA DEPURAR UTILIZAR -DCMAKE_BUILD_TYPE=Debug


#############################
# CMake global modules
#
include(CTest)
include(GenerateExportHeader)
include(CMakePackageConfigHelpers)


################################
#Setup the internal cmake modules
#
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)
message(" Module path at ${CMAKE_MODULE_PATH}")
#
include(ImportExternalLibrary)
include(macros/GenerateEmbeddedManifestMacro)
include(ctkMacroSimpleTest)
include(BuildModule)
include(ModuleAPI)
include(BuildTestCases)
include(ImportExternalLibrary)
include(FindQDoc)
#------------------------------


#Esta linea es para que todas las dll generadas y ejecutables vayan al mismo directorio


set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin" )
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib" )
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib" )

#CMake modules
set(${PROJECT_NAME}_MODULE_DIR "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}/CMake/Modules")




#OPTIONS !---------------------------
OPTION(BUILD_SHARED_LIBS "Build as shared library" ON)

#BUILD MACROS .....
if(BUILD_SHARED_LIBS)
    message("BUILD ---->SHARED LIB")
    set(BUILD_TYPE SHARED)
    set(PROJECT_BUILD_TYPE ${PROJECT_NAME}_EXPORTS)
else()
    set(PROJECT_BUILD_TYPE ${PROJECT_NAME}_STATIC)
    set(BUILD_TYPE STATIC)
endif()



# Install to "dist" directory in Windows for testing and as a staging directory
# for the installer.
if (WIN32 AND NOT CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX dist CACHE STRING "Install path prefix.")
endif()






# Configure Qt
find_package(Qt5 COMPONENTS Core Widgets Sql Concurrent LinguistTools Svg Help WebKit WebKitWidgets Test)


# Global CMake options ------------
set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTO_UIC ON)
set(CMAKE_AUTO_RCC ON)
#----------------------------------


# Offer the user the choice of overriding the installation directories

set(INCLUDE_INSTALL_DIR include/   )
set(LIB_INSTALL_DIR lib/   )
set(SYSCONFIG_INSTALL_DIR etc/foo/   )
set(INSTALL_LIB_DIR lib CACHE PATH "Installation directory for libraries")
set(INSTALL_BIN_DIR bin CACHE PATH "Installation directory for executables")
set(INSTALL_DOC_DIR doc CACHE PATH "DOCUMENTATION")
set(INSTALL_TESTS_DIR test CACHE PATH "TESTS")
set(INSTALL_PLUGINS_DIR plugins CACHE PATH "PLUGINS")
set(INSTALL_INCLUDE_DIR include CACHE PATH
  "Installation directory for header files")

#if(WIN32 AND NOT CYGWIN)
#  set(DEF_INSTALL_CMAKE_DIR CMake)
#else()
#  set(DEF_INSTALL_CMAKE_DIR lib/CMake/wcl)
#endif()

set(INSTALL_CMAKE_DIR ${DEF_INSTALL_CMAKE_DIR} CACHE PATH
  "Installation directory for CMake files")

# Make relative paths absolute (needed later on)
foreach(p LIB BIN INCLUDE TESTS DOC PLUGINS CMAKE)
  set(var INSTALL_${p}_DIR)
  if(NOT IS_ABSOLUTE "${${var}}")
    set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
  endif()
endforeach()

# set up include-directories
include_directories(
  "${PROJECT_SOURCE_DIR}"   # to find foo/foo.h
  "${PROJECT_BINARY_DIR}")  # to find foo/config.h

SET(INCLUDE_SRC_DIRECTORIES )
SET(INCLUDE_BUILD_DIRECTORIES )


# Add sub-directories
add_subdirectory(src)
add_subdirectory(lang)
#add_subdirectory(doc)

add_subdirectory(examples)

#Testing configuration
enable_testing()





#documentation
# add a target to generate API documentation with Doxygen


# add a target to generate API documentation with qdoc
#configure_file(${CMAKE_SOURCE_DIR}/doc/config.qdocconf.in ${CMAKE_BINARY_DIR}/config.qdocconf @ONLY)
#add_custom_target(qdoc
#qdoc ${CMAKE_CURRENT_BINARY_DIR}/config.qdocconf
#WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
#COMMENT "Generating API documentation with qdoc" VERBATIM
#)






# The interesting stuff goes here
# ===============================

# Add all targets to the build-tree export set
#export(TARGETS ctkCore foo qtpropertybrowser qwt
#  FILE "${PROJECT_BINARY_DIR}/lib/cmake/wclTargets.cmake")

# Export the package for use from the build-tree
# (this registers the build-tree with a global CMake-registry)
export(PACKAGE wcl)

# Create the wclConfig.cmake and wclConfigVersion files
file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}"
   "${INSTALL_INCLUDE_DIR}")
# ... for the build tree
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}/src" "${PROJECT_BINARY_DIR}/src")


#----------------------------


configure_package_config_file(${PROJECT_SOURCE_DIR}/cmake/in/wclConfig.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/lib/cmake/wclConfig.cmake
                              INSTALL_DESTINATION ${LIB_INSTALL_DIR}
                              PATH_VARS INCLUDE_INSTALL_DIR LIB_INSTALL_DIR SYSCONFIG_INSTALL_DIR PROJECT_NAME)
file(COPY ${PROJECT_SOURCE_DIR}/cmake/ModuleApi.cmake DESTINATION ${CMAKE_CURRENT_BINARY_DIR}/lib/cmake)


write_basic_package_version_file(${CMAKE_CURRENT_BINARY_DIR}/lib/cmake/wclConfigVersion.cmake
                                 VERSION 1.2.3
                                 COMPATIBILITY SameMajorVersion)






#----------------------------
#configure_file(wclConfig.cmake.in
#  "${PROJECT_BINARY_DIR}/wclConfig.cmake" @ONLY)

#----------------------------------------------------------------------------
# ... for the install tree
# set(CONF_INCLUDE_DIRS "\${wcl_CMAKE_DIR}/${REL_INCLUDE_DIR}")
# 
# configure_file(wclConfig.cmake.in
#   "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/wclConfig.cmake" @ONLY)
# # ... for both
# configure_file(wclConfigVersion.cmake.in
#   "${PROJECT_BINARY_DIR}/wclConfigVersion.cmake" @ONLY)
# 
# # Install the wclConfig.cmake and wclConfigVersion.cmake
install(FILES
  "${PROJECT_BINARY_DIR}//lib/cmake/wclConfig.cmake"
  "${PROJECT_BINARY_DIR}/lib/cmake/wclConfigVersion.cmake"
  "${PROJECT_BINARY_DIR}/lib/cmake/ModuleApi.cmake"
  DESTINATION "${LIB_INSTALL_DIR}/cmake" COMPONENT dev)

# Install the export set for use with the install-tree
install(EXPORT wclTargets DESTINATION
  "${LIB_INSTALL_DIR}/cmake" COMPONENT dev)

