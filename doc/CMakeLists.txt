#############################################################################
# Configuration #
#################

CONFIGURE_FILE(
    "${CMAKE_SOURCE_DIR}/doc/Doxyfile.in"
    "${CMAKE_BINARY_DIR}/doc/Doxyfile"
    @ONLY
)
CONFIGURE_FILE(
    "${CMAKE_CURRENT_SOURCE_DIR}/config.qdocconf.in"
    "${CMAKE_BINARY_DIR}/doc/config.qdocconf"
   @ONLY
)


set(QT_DIR ${_qt5Help_install_prefix})

FIND_PROGRAM(QDOC_EXECUTABLE qdoc PATH ${QT_DIR}/bin)
FIND_PROGRAM(QCOLLECTIONGENERATOR_EXECUTABLE qcollectiongenerator PATH ${QT_DIR}/bin/)
FIND_PROGRAM(QHELPGENERATOR_EXECUTABLE qhelpgenerator PATH ${QT_DIR}/bin/)


message("QT5_QCOLLECTIONGENERATOR_EXECUTABLE => ${QT_DIR}")


# add a target to generate API documentation with Doxygen
find_package(Doxygen)
if(DOXYGEN_FOUND)
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/Doxyfile.in ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile @ONLY)
    add_custom_target(doc
    ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    COMMENT "Generating API documentation with Doxygen" VERBATIM
    )
endif(DOXYGEN_FOUND)


       add_custom_target(qdoc 
            COMMAND ${QDOC_EXECUTABLE}
            ${CMAKE_BINARY_DIR}/doc/config.qdocconf --debug --log-progress --outputdir ${CMAKE_BINARY_DIR}/doc/qdoc --installdir ${CMAKE_BINARY_DIR}/doc/final
            VERBATIM)

add_custom_target(qdoc2 
            COMMAND ${QHELPGENERATOR_EXECUTABLE}
            "${CMAKE_BINARY_DIR}/doc/qdoc/qtestclass.qhp"
            DEPENDS qdoc
)



