set(HEADERS
      foo.h)

set(SOURCES
    foo.cpp)

BuildModule(
    NAME foo
	TYPE SHARED
    SOURCES  ${SOURCES}
    INCLUDES  ${HEADERS}
    EXPORT_DIRECTIVE "foo_EXPORT"
)

if(BUILD_TESTING)
	add_subdirectory(Testing)
endif()

if (BUILD_DOCUMENTATION)
	add_subdirectory(Documentation)
endif()
