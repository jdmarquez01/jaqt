set(INCLUDES
	mainwindow.h
	mainwindow_p.h
	abstractDocument.h
	abstractCommand.h
	documentManager.h
	documentManagerModel.h
	widgets/AboutDialog.h
	settings/AppSettings.h
	helpbrowser.h
	settings/defaultSettings.h
)

set(SOURCES
	main.cpp 
	mainwindow.cpp
	mainwindow_p.cpp
	abstractDocument.cpp
	abstractCommand.cpp
	documentManager.cpp
	documentManagerModel.cpp
	widgets/AboutDialog.cpp
	settings/AppSettings.cpp
	settings/defaultSettings.cpp
	helpbrowser.cpp

)

set(QRC
	../../data/icons/default/default.qrc
	../../info.qrc
)

set(UI_FORMS
	mainwindow.ui
	widgets/AboutDialog.ui
)


BuildModule( 
	TYPE EXECUTABLE
    NAME jaqt
    PREFIX_DIR "jaqt"
    SOURCES   ${SOURCES}
    INCLUDES  ${INCLUDES}
    UI_SRC    ${UI_FORMS}
    RESOURCES ${QRC}
    TARGETS   "Qt5::Core;Qt5::Gui;Qt5::Widgets;Qt5::Help;Qt5::WebKitWidgets;Qt5::WebKit" 
    DEPENDS foo
)
  set_target_properties(jaqt  PROPERTIES
    COMPILE_FLAGS "-std=c++11"
    )





