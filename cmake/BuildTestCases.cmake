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

#! \brief Build Test cases
#!
#! \ingroup CMakeAPI
function (BuildTestCases)

	set(oneValueArgs NAME )
	set(multiValueArgs SOURCES ADDITIONAL_SOURCES UI_SRC INCLUDES RESOURCES TARGETS DEPENDS)
	cmake_parse_arguments(MY_BUILD "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN} )

	create_test_sourcelist(${MY_BUILD_NAME}_Test "${MY_BUILD_NAME}_Test.cpp" ${SOURCES} )
	
	add_executable(
		${MY_BUILD_NAME}
		${${MY_BUILD_NAME}_Test}
		${MY_BUILD_SOURCES}
		${MY_BUILD_ADDITIONAL_SOURCES}
		${MY_BUILD_INCLUDES}
		${MY_BUILD_RESOURCES}
		${MY_BUILD_UI_SRC}
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


	target_link_libraries(${MY_BUILD_NAME} "${MY_BUILD_DEPENDS};${MY_BUILD_TARGETS}")
	
	
	foreach(_source ${SOURCES})
		get_filename_component(testCase ${_source} NAME_WE) 
		ADD_TEST(NAME ${testCase} COMMAND ${MY_BUILD_NAME} ${testCase})
	endforeach()


endfunction(BuildTestCases)
