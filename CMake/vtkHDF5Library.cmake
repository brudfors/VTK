#########################################################################
# Configure HDF5

IF(VTK_USE_SYSTEM_HDF5)
  #find_package(HDF5 REQUIRED)
  #INCLUDE(${ParaView_CMAKE_DIR}/FindZLIB.cmake)
  #SET(VTK_HDF5_LIBRARIES ${HDF5_LIBRARIES})
ELSE(VTK_USE_SYSTEM_HDF5)

  # Tell hdf5 that we are manually overriding certain settings
  SET(HDF5_EXTERNALLY_CONFIGURED 1)
  # Avoid duplicating names of installed libraries
  SET(HDF5_EXTERNAL_LIB_PREFIX "vtk")
  # Export configuration to this export variable
  SET(HDF5_EXPORTED_TARGETS ${VTK_INSTALL_EXPORT_NAME})

  # Silence HDF5's warnings. We'll let them get fixed upstream
  # and merge in updates as necessary.
  SET(HDF5_DISABLE_COMPILER_WARNINGS ON CACHE BOOL "Disable HDF5 warnings" FORCE)

  SET(HDF5_INSTALL_NO_DEVELOPMENT ${VTK_INSTALL_NO_DEVELOPMENT})
  SET(HDF5_INSTALL_BIN_DIR ${VTK_INSTALL_BIN_DIR})
  SET(HDF5_INSTALL_LIB_DIR ${VTK_INSTALL_LIB_DIR})
  SET(HDF5_INSTALL_INCLUDE_DIR ${VTK_INSTALL_INCLUDE_DIR})

  SET(HDF5_ENABLE_Z_LIB_SUPPORT ON CACHE BOOL "Enable Zlib Filters" FORCE)

  # Setup all necessary overrides for zlib so that HDF5 uses our
  # internally compiled zlib rather than any other version
  IF(HDF5_ENABLE_Z_LIB_SUPPORT)
    # We must tell the main HDF5 library that it depends on our zlib
    SET(HDF5_LIB_DEPENDENCIES vtkzlib)
    # Override the zlib header file
    IF(VTK_USE_SYSTEM_ZLIB)
      SET(H5_ZLIB_HEADER "zlib.h")
    ELSE(VTK_USE_SYSTEM_ZLIB)
      SET(H5_ZLIB_HEADER "vtk_zlib.h")
      # Set vars that FindZlib would have set if used in sub project
      SET(ZLIB_INCLUDE_DIRS "${VTK_ZLIB_INCLUDE_DIRS}")
      SET(ZLIB_LIBRARIES vtkzlib)
    ENDIF(VTK_USE_SYSTEM_ZLIB)
  ENDIF(HDF5_ENABLE_Z_LIB_SUPPORT)

  SET(HDF5_INCLUDE_DIR
     ${VTK_SOURCE_DIR}/Utilities/vtkhdf5/src
     ${VTK_BINARY_DIR}/Utilities/vtkhdf5
     ${VTK_SOURCE_DIR}/Utilities/vtkhdf5/hl/src)

  # Some other modules use these vars to get the hdf5 lib name(s)
  #SET(VTK_HDF5_LIBRARIES
  #  vtkhdf5
#    ${HDF5_CPP_LIB_NAME}
#    ${HDF5_HL_LIB_NAME}
#    ${HDF5_HL_CPP_LIB_NAME}
  #  CACHE INTERNAL ""
  #)

  MARK_AS_ADVANCED(
    H5_SET_LIB_OPTIONS
    H5_LEGACY_NAMING
    HDF5_ENABLE_COVERAGE
    HDF5_DISABLE_COMPILER_WARNINGS
    HDF5_ENABLE_PARALLEL
    HDF5_USE_16_API_DEFAULT
    HDF5_USE_FILTER_FLETCHER32
    HDF5_USE_FILTER_NBIT
    HDF5_USE_FILTER_SCALEOFFSET
    HDF5_USE_FILTER_SHUFFLE
    HDF5_ENABLE_Z_LIB_SUPPORT
    HDF5_ENABLE_SZIP_SUPPORT
    HDF5_ENABLE_SZIP_ENCODING
    HDF5_ENABLE_THREADSAFE
    HDF5_ENABLE_TRACE
    HDF5_USE_H5DUMP_PACKED_BITS
    HDF5_BUILD_FORTRAN
    HDF5_BUILD_EXAMPLES
    HDF5_BUILD_CPP_LIB
    HDF5_BUILD_TOOLS
    HDF5_BUILD_HL_LIB
    HDF5_Enable_Clear_File_Buffers
    HDF5_Enable_Instrument
    HDF5_STRICT_FORMAT_CHECKS
    HDF5_METADATA_TRACE_FILE
    HDF5_WANT_DATA_ACCURACY
    HDF5_WANT_DCONV_EXCEPTION
    HDF5_ENABLE_LARGE_FILE
    HDF5_STREAM_VFD
    HDF5_ENABLE_HSIZET
    H5_SET_LIB_OPTIONS
    HDF5_BUILD_WITH_INSTALL_NAME
    HDF5_PACKAGE_EXTLIBS
    )

ENDIF(VTK_USE_SYSTEM_HDF5)