#
# Depends on:
#  CTK/CMake/ctkMacroParseArguments.cmake
#

#! \ingroup CMakeUtilities
macro(GenerateEmbeddedManifestMacro QRC_SRCS)

	
	
  # Sanity checks
  if(NOT DEFINED ManifestSymbolicName)
	message(FATAL_ERROR "SYMBOLIC_NAME is mandatory")
  endif()

  set(_manifest_content "Plugin-SymbolicName: ${ManifestSymbolicName}")

 if(DEFINED ManifestActivationPolicy)
   string(TOLOWER "${ManifestActivationPolicy}" _activation_policy)
   if(_activation_policy STREQUAL "eager")
     set(_manifest_content "${_manifest_content}\nPlugin-ActivationPolicy: eager")
   else()
     message(FATAL_ERROR "ACTIVATIONPOLICY is set to '${ManifestActivationPolicy}', which is not supported")
   endif()
 endif()

  if(DEFINED ManifestCategory)
    set(_manifest_content "${_manifest_content}\nPlugin-Category: ${ManifestCategory}")
  endif()

  if(DEFINED ManifestContactAddress)
    set(_manifest_content "${_manifest_content}\nPlugin-ContactAddress: ${ManifestContactAddress}")
  endif()

  if(DEFINED ManifestCopyright)
    set(_manifest_content "${_manifest_content}\nPlugin-Copyright: ${ManifestCopyright}")
  endif()

  if(DEFINED ManifestDescription)
    set(_manifest_content "${_manifest_content}\nPlugin-Description: ${ManifestDescription}")
  endif()

  if(DEFINED ManifestDocURL)
    set(_manifest_content "${_manifest_content}\nPlugin-DocURL: ${ManifestDocURL}")
  endif()

  if(DEFINED ManifestIcon)
    set(_manifest_content "${_manifest_content}\nPlugin-Icon: ${ManifestIcon}")
  endif()

  if(DEFINED ManifestLicense)
    set(_manifest_content "${_manifest_content}\nPlugin-License: ${ManifestLicense}")
  endif()

  if(DEFINED ManifestName)
    set(_manifest_content "${_manifest_content}\nPlugin-Name: ${ManifestName}")
  endif()

  if(DEFINED ManifestRequirePlugin)
    string(REPLACE ";" "," require_plugin "${ManifestRequirePlugin}")
    set(_manifest_content "${_manifest_content}\nRequire-Plugin: ${require_plugin}")
  endif()

  if(DEFINED ManifestVendor)
    set(_manifest_content "${_manifest_content}\nPlugin-Vendor: ${ManifestVendor}")
  endif()

  if(DEFINED ManifestVersion)
    set(_manifest_content "${_manifest_content}\nPlugin-Version: ${ManifestVersion}")
  endif()

  if(DEFINED ManifestCustomHeaders)
    set(_manifest_content "${_manifest_content}\n")
    foreach(_custom_header ${ManifestCustomHeaders})
      set(_manifest_content "${_manifest_content}\n${_custom_header}: ${${_custom_header}}")
    endforeach()
  endif()

  set(_manifest_filename "MANIFEST.MF")
  set(_manifest_filepath "${CMAKE_CURRENT_BINARY_DIR}/${_manifest_filename}")
  string(REPLACE "." "_" _symbolic_name ${ManifestSymbolicName})
  set(_manifest_qrc_filepath "${CMAKE_CURRENT_BINARY_DIR}/${_symbolic_name}_manifest.qrc")
  

  set(_manifest_qrc_content
"<!DOCTYPE RCC><RCC version=\"1.0\">
<qresource prefix=\"/${ManifestSymbolicName}/META-INF\">
 <file>${_manifest_filename}</file>
</qresource>
</RCC>
")

  configure_file("${CMAKE_SOURCE_DIR}/cmake/in/MANIFEST.MF.in" "${_manifest_filepath}" @ONLY)
  configure_file("${CMAKE_SOURCE_DIR}/cmake/in/plugin_manifest.qrc.in" "${_manifest_qrc_filepath}" @ONLY)

  
  set(${QRC_SRCS} ${${QRC_SRCS}} ${_qrc_src} )

endmacro()