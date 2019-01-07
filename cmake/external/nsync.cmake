include (ExternalProject)

set(NSYNC_URL https://github.com/google/nsync.git)
set(NSYNC_TAG 1.20.1)

if(WIN32)
  set(NSYNC_SHARED_LIB libnsync_cpp.dll)
  set(NSYNC_IMPORT_LIB mkldnn.lib)
else()
  if (APPLE)
    set(NSYNC_SHARED_LIB libnsync.0.dylib)
  else()
    set(NSYNC_SHARED_LIB libnsync.so.0)
  endif()
endif()


set(NSYNC_SOURCE ${CMAKE_CURRENT_BINARY_DIR}/nsync/src)
set(NSYNC_INSTALL ${CMAKE_CURRENT_BINARY_DIR}/nsync/install)
set(NSYNC_LIB_DIR ${NSYNC_INSTALL}/lib)
set(NSYNC_INCLUDE_DIR ${NSYNC_INSTALL}/include)

ExternalProject_Add(project_mkldnn
  PREFIX mkl-dnn
  GIT_REPOSITORY ${NSYNC_URL}
  GIT_TAG ${NSYNC_TAG}
  SOURCE_DIR ${NSYNC_SOURCE}
  CMAKE_ARGS -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} -DCMAKE_INSTALL_PREFIX=${NSYNC_INSTALL} -DNSYNC_ENABLE_TESTS=0
)