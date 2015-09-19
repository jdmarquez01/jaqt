
set(SOURCES 
		testfoo.cpp 
		testfoo2.cpp
)

BuildTestCases(
	NAME FooTest
	SOURCES ${SOURCES}
	DEPENDS foo
	TARGETS "Qt5::Test;Qt5::Core"
)
