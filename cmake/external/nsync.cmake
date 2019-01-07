include (ExternalProject)

set(NSYNC_URL https://github.com/google/nsync)
set(NSYNC_TAG 1.20.0)


set(NSYNC_SOURCE ${CMAKE_CURRENT_BINARY_DIR}/nsync/src)
set(NSYNC_INSTALL ${CMAKE_CURRENT_BINARY_DIR}/nsync/install)
set(NSYNC_LIB_DIR ${NSYNC_INSTALL}/lib)
set(NSYNC_INCLUDE_DIR ${NSYNC_INSTALL}/include)

if(WIN32)
    set(NSYNC_STATIC_LIBRARIES ${NSYNC_INSTALL}/lib/nsync.lib)
else()
  if (APPLE)
    set(NSYNC_SHARED_LIB libnsync.0.dylib)
  else()
    set(NSYNC_SHARED_LIB libnsync.so.0)
  endif()
endif()

ExternalProject_Add(nsync
  PREFIX nsync
  GIT_TAG ${NSYNC_TAG}
  GIT_REPOSITORY ${NSYNC_URL}
  BUILD_IN_SOURCE 1
  INSTALL_DIR ${NSYNC_INSTALL}
  CMAKE_CACHE_ARGS
        -DCMAKE_BUILD_TYPE:STRING=Release
        -DCMAKE_VERBOSE_MAKEFILE:BOOL=OFF
        -DCMAKE_INSTALL_PREFIX:STRING=${NSYNC_INSTALL}
        -DNSYNC_ENABLE_TESTS=0
        -DNSYNC_LANGUAGE:STRING=c++11
)