###########################################################################
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0.txt
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
###########################################################################


# 	BuildLibrary

#! \brief Build a Library
#! 
#!  This function creates a target library, 

#!  \param DESTINATION         ???
#!  \param EXPORT_DIRECTIVE    declexport_name
#!  \param MOC_SRC             sources to be moc'ed
#!  \param INCLUDES  		   public headers
#!  \param RESOURCES           Qt resources to be compiled
#!  \param TARGETS 			   External libraries to link the target
#!  \param DEPENDENCIES        In-project dependencies 
#!  \param MOC_GENERATED_SRC   in-target moc targets

#! \ingroup CMakeAPI
function(ImportExternalLibrary)

	set(options SHARED STATIC)
	set(oneValueArgs NAME DESTINATION EXPORT_DIRECTIVE)
        set(multiValueArgs SOURCES MOC_SRC UI_SRC INCLUDES RESOURCES TARGETS DEPENDENCIES MOC_GENERATED_SRC LIBRARY_NAME LIBRARY_RUNTIME)

	cmake_parse_arguments(MY_BUILD "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )




        if (NOT MY_BUILD_DEPENDENCIES)
            set (MY_BUILD_DEPENDENCIES "")
        endif()
		


	message(STATUS "{MY_BUILD_NAME}=${MY_BUILD_NAME}")

        message(STATUS "{IMPORTED_LOCATION}=${CMAKE_CURRENT_SOURCE_DIR}/${MY_BUILD_LIBRARY_NAME}")
        message(STATUS "{IMPORTED_IMPLIB}=${CMAKE_CURRENT_SOURCE_DIR}/${MY_BUILD_LIBRARY_RUNTIME}")


	
         add_library(${MY_BUILD_NAME} SHARED IMPORTED GLOBAL)

         set_property(TARGET ${MY_BUILD_NAME} PROPERTY IMPORTED_LOCATION "${CMAKE_CURRENT_SOURCE_DIR}/${MY_BUILD_LIBRARY_RUNTIME}")
         set_property(TARGET ${MY_BUILD_NAME} PROPERTY IMPORTED_IMPLIB "${CMAKE_CURRENT_SOURCE_DIR}/${MY_BUILD_LIBRARY_NAME}")




	set_target_properties(${MY_BUILD_NAME} PROPERTIES
		PUBLIC_HEADER "${MY_BUILD_INCLUDES}"
	)

	#target_link_libraries(${MY_BUILD_NAME} ${MY_BUILD_TARGETS} ${MY_BUILD_DEPENDENCIES})
	

	# SETUP MODULE INFO


	configure_package_config_file(${CMAKE_SOURCE_DIR}/cmake/LibraryConfig.cmake.in
		CMakeFiles/${MY_BUILD_NAME}Config.cmake
		INSTALL_DESTINATION ${LIB_INSTALL_DIR}/${MY_BUILD_NAME}/cmake/Modules
		PATH_VARS INCLUDE_INSTALL_DIR LIB_INSTALL_DIR SYSCONFIG_INSTALL_DIR MY_BUILD_NAME MY_BUILD_DEPENDENCIES
	)


        set(loc $<TARGET_FILE:${MY_BUILD_NAME}>)
#        get_target_property(loc ${MY_BUILD_NAME} LIBRARY_OUTPUT_DIRECTORY)
message("LOC => ${loc}")
#get_filename_component(MY_BUILD_NAME_LIBRARY_DIRS $<TARGET_FILE> DIRECTORY)

        set(MY_BUILD_NAME_DEFINITIONS "")
	set(MY_BUILD_NAME_DEPENDS "${MY_BUILD_DEPENDENCIES}")
	set(MY_BUILD_NAME_LIBRARIES "${MY_BUILD_NAME}")
	set(MY_BUILD_NAME_INCLUDE_DIRS "${CMAKE_CURRENT_SOURCE_DIR}")
        
	set(MY_BUILD_NAME_LIBRARY_DIRS "${CMAKE_CURRENT_SOURCE_DIR}")
    set(MY_BUILD_NAME_RUNTIME_LIBRARY_DIRS "${CMAKE_CURRENT_SOURCE_DIR}")
	set(MY_BUILD_NAME_WRAP_HIERARCHY_FILE "")
	
	set_target_properties(${MY_BUILD_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")
    set_target_properties(${MY_BUILD_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}")


	configure_file(${CMAKE_SOURCE_DIR}/cmake/ModuleConfig.cmake.in ${CMAKE_BINARY_DIR}/lib/cmake/Modules/${MY_BUILD_NAME}/${MY_BUILD_NAME}Config.cmake)


	write_basic_package_version_file(${CMAKE_BINARY_DIR}/lib/cmake/Modules/${MY_BUILD_NAME}/${MY_BUILD_NAME}ConfigVersion.cmake
                VERSION ${MY_BUILD_VERSION}
		COMPATIBILITY SameMajorVersion
	)
	


# install(TARGETS ${MY_BUILD_NAME} DESTINATION ${RUNTIME_OUTPUT_DIRECTORY}/${MY_BUILD_NAME} EXPORT ${MY_BUILD_NAME}-targets)
# install(EXPORT ${MY_BUILD_NAME} DESTINATION ${CMAKE_CURRENT_SOURCE_DIR})
	
	install (FILES "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${MY_BUILD_NAME}Config.cmake"
		"${CMAKE_BINARY_DIR}/lib/cmake/Modules/${MY_BUILD_NAME}/${MY_BUILD_NAME}ConfigVersion.cmake"
		DESTINATION "${INSTALL_LIB_DIR}/cmake/Modules/${MY_BUILD_NAME}" COMPONENT dev
	)

endfunction(ImportExternalLibrary)
