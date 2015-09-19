###########################################################################
#
#  Library:   CTK
#
#  Copyright (c) Kitware Inc.
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



#! \brief Build a CTK library.
#!
#! \ingroup CMakeAPI
function (BuildTests)

 set(oneValueArgs NAME DESTINATION EXPORT_DIRECTIVE PREFIX_DIR)
 set(multiValueArgs SOURCES MOC_SRC UI_SRC INCLUDES RESOURCES TARGETS DEPENDENCIES MOC_GENERATED_SRC)

 cmake_parse_arguments(MY_BUILD "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )


	# Make sure variable are cleared
	set(MY_MOC_CPP)
        set(MY_MOC_GENERATED_SRC)
	set(MY_UI_CPP)
	set(MY_QRC_SRCS)




        #foreach(moc_src ${MY_BUILD_MOC_SRC})
        #  qt5_wrap_cpp(MY_MOC_CPP ${moc_src} OPTIONS -f${moc_src} OPTIONS -DHAVE_QT5)
        #endforeach()




        if(NOT AUTOMOC)
            qt5_wrap_cpp(MY_MOC_CPP ${MY_BUILD_MOC_SRC})
        endif()


        qt5_wrap_ui(MY_UI_CPP ${MY_BUILD_UI_SRC})




        qt5_add_resources(MY_QRC_SRCS ${MY_BUILD_RESOURCES})
	

        string(TOUPPER ${MY_BUILD_EXPORT_DIRECTIVE} LIB_EXPORT)
        string(TOUPPER "${MY_BUILD_EXPORT_DIRECTIVE}_EXPORT_H" HEADER_CAPS)

        message(STATUS "{LIB_EXPORT}=${LIB_EXPORT}")


		  
	source_group("Resources" FILES
		${MY_RESOURCES}
		${MY_UI_FORMS}
		)

	  source_group("Generated Sources" FILES
		${MY_QRC_SRCS}
		${MY_MOC_CPP}
		${MY_UI_CPP}
		${MOC_CPP_DECORATOR}
        "${CMAKE_BINARY_DIR}/include/${MY_BUILD_NAME}/${MY_BUILD_NAME}Export.h"
		)

         add_library(${MY_BUILD_NAME} SHARED
                 ${MY_BUILD_SOURCES}
                 ${MY_BUILD_INCLUDES}
		 ${MY_MOC_CPP}
		 ${MY_UI_CPP}
                 ${MY_QRC_SRCS}

		 # items included so they show up in your IDE
         "${CMAKE_BINARY_DIR}/include/${MY_BUILD_NAME}/${MY_BUILD_NAME}Export.h"
		 ) 



        if(NOT MY_BUILD_DEPENDENCIES)
            set (MY_BUILD_DEPENDENCIES "")
        else()

            foreach(my_depencency ${MY_BUILD_DEPENDENCIES})
                vtk_module_load(wcl ${my_depencency})
                include_directories("${${my_depencency}_INCLUDE_DIRS}")
                add_dependencies(${MY_BUILD_NAME} ${my_depencency})
            endforeach()
        endif()


        set_target_properties(${MY_BUILD_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/plugins/${MY_BUILD_PREFIX_DIR}")



        generate_export_header(${MY_BUILD_NAME} EXPORT_FILE_NAME "${CMAKE_BINARY_DIR}/include/${MY_BUILD_NAME}/${MY_BUILD_NAME}Export.h" EXPORT_MACRO_NAME ${LIB_EXPORT})


         if(NOT AUTOMOC)
             qt5_wrap_cpp(MY_MOC_GENERATED_SRC ${MY_BUILD_MOC_GENERATED_SRC})
            add_custom_target(${MY_BUILD_NAME}_mocs DEPENDS ${MY_MOC_GENERATED_SRC})
            add_dependencies(${MY_BUILD_NAME} ${MY_BUILD_NAME}_mocs)
        endif()

        set_target_properties(${MY_BUILD_NAME} PROPERTIES
                  PUBLIC_HEADER "${MY_BUILD_INCLUDES};${CMAKE_BINARY_DIR}/include/${MY_BUILD_NAME}/${MY_BUILD_NAME}Export.h")

        target_link_libraries(${MY_BUILD_NAME} ${MY_BUILD_TARGETS} ${MY_BUILD_DEPENDENCIES})
        target_include_directories(${MY_BUILD_NAME} PRIVATE ${CMAKE_BINARY_DIR}/include/${MY_BUILD_NAME})


        install(TARGETS ${MY_BUILD_NAME}
          EXPORT wclTargets
          RUNTIME DESTINATION "${INSTALL_PLUGINS_DIR}" COMPONENT plugins
        )




endfunction(BuildPlugin)
