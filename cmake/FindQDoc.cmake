
set(QT_DIR ${_qt5Help_install_prefix})

FIND_PROGRAM(QDOC_EXECUTABLE qdoc PATH ${QT_DIR}/bin)
FIND_PROGRAM(QCOLLECTIONGENERATOR_EXECUTABLEE qcollectiongenerator PATH ${QT_DIR}/bin/)
FIND_PROGRAM(QHELPGENERATOR_EXECUTABLE qhelpgenerator PATH ${QT_DIR}/bin/)