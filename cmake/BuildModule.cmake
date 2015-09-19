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
 

# 	BuildModule

#! \brief Build a module of the framework
#! 
#!  This function creates a target library, 

#!  \param DESTINATION         ???
#!  \param EXPORT_DIRECTIVE    declexport_name
#!  \param MOC_SRC             sources to be moc'ed
#!  \param INCLUDES  		   public headers
#!  \param RESOURCES           Qt resources to be compiled
#!  \param TARGETS 			   External libraries to link the target
#!  \param DEPENDS             In-project dependencies 
#!  \param MOC_GENERATED_SRC   in-target moc targets

#! \ingroup CMakeAPI
function(BuildModule)

	set(options 
		
	)
	set(oneValueArgs
		NAME 
		TYPE
		DESTINATION 
		EXPORT_DIRECTIVE 
		PREFIX_DIR		
	)	
	set(multiValueArgs				
		SOURCES 
		MOC_SRC 
		UI_SRC 
		INCLUDES 
		RESOURCES 
		TARGETS
		DEPENDS
		MOC_GENERATED_SRC
		TARGET_LIBRARIES
	)				
	cmake_parse_arguments(MY_BUILD "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	
	

	# Make sure variable are cleared
	set(MY_MOC_CPP)
	set(MY_MOC_GENERATED_SRC)
	set(MY_UI_CPP)
	set(MY_QRC_SRCS)
	set(MY_BUILD_STATIC_OR_SHARED )
    set(MY_BUILD_VERSION "${${PROJECT_NAME}_VERSION}")

	#Manifest_resources, this only applies if manifest.cmake is detected
	if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/manifest.cmake")
		include (macros/ClearManifestMacro)
		include(${CMAKE_CURRENT_SOURCE_DIR}/manifest.cmake)
		if (ManifestIcon AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${ManifestIcon}") #<-- should be included in a qrc file
			SET(ICON_SET "IDI_ICON1   ICON    DISCARDABLE ${ManifestIcon}")
		else() 
			SET(ICON_SET "")
		endif()
		configure_file("${CMAKE_SOURCE_DIR}/cmake/in/resources.rc.in" "${CMAKE_CURRENT_BINARY_DIR}/resources.rc" @ONLY)

		GenerateEmbeddedManifestMacro(MY_QRC_SRCS)  ## <--------- It should done only if shared library is created
		set(winResource "${CMAKE_CURRENT_BINARY_DIR}/resources.rc") 
		
	endif()
	
		
	#cmake auto options
	if(NOT CMAKE_AUTOMOC)
		qt5_wrap_cpp(MY_MOC_CPP ${MY_BUILD_MOC_SRC})
	endif()
	
	if(NOT CMAKE_AUTO_UI)
		qt5_wrap_ui(MY_UI_CPP ${MY_BUILD_UI_SRC})
	endif()
	
	if(NOT AUTORCC)
		qt5_add_resources(MY_QRC_SRCS ${MY_BUILD_RESOURCES})
	endif()

	
	#documentation
	set(BUILD_DOC on)
	if (BUILD_DOC)
		if (EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/Documentation/doc.qdocconf)
		# hacer un parent_scope
		
			include(FindQDoc)
			
			configure_file(${CMAKE_SOURCE_DIR}/cmake/in/config.qdocconf.in 
			${CMAKE_CURRENT_BINARY_DIR}/config.qdocconf @ONLY
			)
					configure_file(${CMAKE_SOURCE_DIR}/cmake/in/helpcollection.qhcp.in
			${CMAKE_CURRENT_BINARY_DIR}/helpcollection.qhcp @ONLY
			)
			
		   add_custom_target(${MY_BUILD_NAME}Documentation ALL
				COMMAND ${QDOC_EXECUTABLE}
					"${CMAKE_CURRENT_BINARY_DIR}/config.qdocconf" -debug -log-progress  -outputdir "${CMAKE_CURRENT_BINARY_DIR}/Documentation" -installdir "${CMAKE_BINARY_DIR}/doc"
				COMMAND ${QHELPGENERATOR_EXECUTABLE} 
					"${CMAKE_CURRENT_BINARY_DIR}/Documentation/${MY_BUILD_NAME}.qhp"
				 VERBATIM)
		endif()
	endif(BUILD_DOC)		
	
	
	set (EXPORT_INCLUDE "")

	#only libraries can be linked
	if (MY_BUILD_TYPE MATCHES "EXECUTABLE")
		add_executable(
			${MY_BUILD_NAME} 
			${MY_BUILD_SOURCES}
			${MY_BUILD_INCLUDES}
			${MY_MOC_CPP}
			${MY_UI_CPP}
			${MY_QRC_SRCS}
			${winResource}	
		)
		#todo: generate installator.
		
	else() # BUILD A LIBRARY
		string(TOUPPER ${MY_BUILD_EXPORT_DIRECTIVE} LIB_EXPORT)
		string(TOUPPER "${MY_BUILD_EXPORT_DIRECTIVE}_EXPORT_H" HEADER_CAPS)
		set (EXPORT_INCLUDE "${CMAKE_BINARY_DIR}/include/${MY_BUILD_NAME}/${MY_BUILD_NAME}Export.h")
		add_library(
			${MY_BUILD_NAME} 
			${MY_BUILD_TYPE}
			${MY_BUILD_SOURCES}
			${MY_BUILD_INCLUDES}
			${MY_MOC_CPP}
			${MY_UI_CPP}
			${MY_QRC_SRCS}
			${winResource}	
			${EXPORT_INCLUDE}
		) 
		target_include_directories(${MY_BUILD_NAME} PRIVATE ${CMAKE_BINARY_DIR}/include/${MY_BUILD_NAME})
		
		set_target_properties(${MY_BUILD_NAME} PROPERTIES
			PUBLIC_HEADER "${MY_BUILD_INCLUDES};${CMAKE_BINARY_DIR}/include/${MY_BUILD_NAME}/${MY_BUILD_NAME}Export.h" )

		generate_export_header(${MY_BUILD_NAME} EXPORT_FILE_NAME "${CMAKE_BINARY_DIR}/include/${MY_BUILD_NAME}/${MY_BUILD_NAME}Export.h" EXPORT_MACRO_NAME ${LIB_EXPORT})
		
		
		
		#Library configurations
	
		set(MY_BUILD_NAME_DEFINITIONS "")
		set(MY_BUILD_NAME_DEPENDS "${MY_BUILD_DEPENDS}")
		set(MY_BUILD_NAME_LIBRARIES "${MY_BUILD_NAME}")
		set(MY_BUILD_NAME_INCLUDE_DIRS "${CMAKE_BINARY_DIR}/include/${MY_BUILD_NAME};${CMAKE_CURRENT_SOURCE_DIR}")			
		set(MY_BUILD_NAME_LIBRARY_DIRS "${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}")
		set(MY_BUILD_NAME_RUNTIME_LIBRARY_DIRS "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
		set(MY_BUILD_NAME_WRAP_HIERARCHY_FILE "")
		
		set_target_properties(${MY_BUILD_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_RUNTIME_OUTPUT_DIRECTORY}")
		set_target_properties(${MY_BUILD_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${CMAKE_LIBRARY_OUTPUT_DIRECTORY}")
		
		
		configure_package_config_file(${CMAKE_SOURCE_DIR}/cmake/in/LibraryConfig.cmake.in
			CMakeFiles/${MY_BUILD_NAME}Config.cmake
			INSTALL_DESTINATION ${LIB_INSTALL_DIR}/${MY_BUILD_NAME}/cmake/Modules
			PATH_VARS INCLUDE_INSTALL_DIR LIB_INSTALL_DIR SYSCONFIG_INSTALL_DIR MY_BUILD_NAME MY_BUILD_NAME_DEPENDS
		)



	configure_file(${CMAKE_SOURCE_DIR}/cmake/in/ModuleConfig.cmake.in ${CMAKE_BINARY_DIR}/lib/cmake/Modules/${MY_BUILD_NAME}/${MY_BUILD_NAME}Config.cmake)


	write_basic_package_version_file(${CMAKE_BINARY_DIR}/lib/cmake/Modules/${MY_BUILD_NAME}/${MY_BUILD_NAME}ConfigVersion.cmake
                VERSION ${MY_BUILD_VERSION}
		COMPATIBILITY SameMajorVersion
	)
	
	install (FILES "${CMAKE_CURRENT_BINARY_DIR}/CMakeFiles/${MY_BUILD_NAME}Config.cmake"
		"${CMAKE_BINARY_DIR}/lib/cmake/Modules/${MY_BUILD_NAME}/${MY_BUILD_NAME}ConfigVersion.cmake"
		DESTINATION "${INSTALL_LIB_DIR}/cmake/Modules/${MY_BUILD_NAME}" COMPONENT dev
	)
		
	endif()

	
	source_group("Resources" FILES
		${MY_RESOURCES}
		${MY_UI_FORMS}
		${winResource}
	)

	source_group("Generated Sources" FILES
		${MY_QRC_SRCS}
		${MY_MOC_CPP}
		${MY_UI_CPP}
		${MOC_CPP_DECORATOR}
		${EXPORT_INCLUDE}
	)
	

	if(NOT MY_BUILD_DEPENDS)
		set (MY_BUILD_DEPENDS "")
	else()
		foreach(my_depencency ${MY_BUILD_DEPENDS})
                        _module_load(${my_depencency})
			include_directories("${${my_depencency}_INCLUDE_DIRS}")
            add_dependencies(${MY_BUILD_NAME} ${my_depencency})
		endforeach()
	endif()


	if(NOT CMAKE_AUTOMOC)
		qt5_wrap_cpp(MY_MOC_GENERATED_SRC ${MY_BUILD_MOC_GENERATED_SRC})
		add_custom_target(${MY_BUILD_NAME}_mocs DEPENDS ${MY_MOC_GENERATED_SRC})
		add_dependencies(${MY_BUILD_NAME} ${MY_BUILD_NAME}_mocs)
		SET_PROPERTY(TARGET ${MY_BUILD_NAME}  PROPERTY FOLDER ${MY_BUILD_NAME})
		SET_PROPERTY(TARGET ${MY_BUILD_NAME}_mocs  PROPERTY FOLDER ${MY_BUILD_NAME})	
	endif()


	target_link_libraries(${MY_BUILD_NAME} ${MY_BUILD_TARGETS} ${MY_BUILD_DEPENDS})
	target_include_directories(${MY_BUILD_NAME} PRIVATE ${CMAKE_BINARY_DIR}/include/${MY_BUILD_NAME})



	install(TARGETS ${MY_BUILD_NAME}
		EXPORT wclTargets
		RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
		LIBRARY DESTINATION "${INSTALL_LIB_DIR}" COMPONENT shlib
		ARCHIVE DESTINATION "${INSTALL_LIB_DIR}" COMPONENT lib
		PUBLIC_HEADER DESTINATION "${INSTALL_INCLUDE_DIR}/${MY_BUILD_NAME}" COMPONENT dev
	)
	


endfunction(BuildModule)
