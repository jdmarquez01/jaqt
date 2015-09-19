
set(HEADERS
)
set(SOURCES
	bar.cpp
)

BuildModule( 
	TYPE EXECUTABLE
    NAME bar
    PREFIX_DIR "bar"
    SOURCES   ${SOURCES}
    INCLUDES  ${HEADERS}
    DEPENDS foo
)




