# partially coped from libigl/cmake/recipes/external/gmp.cmake

if(TARGET gmp::gmp)
    return()
endif()

message(STATUS "Third-party: creating target 'gmp::gmp'")

include(FetchContent)
include(ProcessorCount)
ProcessorCount(Ncpu)
include(ExternalProject)

set(prefix ${FETCHCONTENT_BASE_DIR}/gmp)
set(gmp_INSTALL ${prefix}/install)
set(gmp_LIB_DIR ${gmp_INSTALL}/lib)
set(gmp_LIBRARY 
  ${gmp_LIB_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}gmp${CMAKE_STATIC_LIBRARY_SUFFIX}
  ${gmp_LIB_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}gmpxx${CMAKE_STATIC_LIBRARY_SUFFIX}
  )
set(gmp_INCLUDE_DIR ${gmp_INSTALL}/include)

# Try to use CONFIGURE_HANDLED_BY_BUILD ON to avoid constantly reconfiguring
if(${CMAKE_VERSION} VERSION_LESS 3.20)
  # CMake < 3.20, do not use any extra option
  set(gmp_ExternalProject_Add_extra_options)
else()
  # CMake >= 3.20
  set(gmp_ExternalProject_Add_extra_options "CONFIGURE_HANDLED_BY_BUILD;ON")
endif()

ExternalProject_Add(gmp
  PREFIX ${prefix}
  URL     https://github.com/alisw/GMP/archive/refs/tags/v6.2.1.tar.gz
  URL_MD5 f060ad4e762ae550d16f1bb477aadba5
  UPDATE_DISCONNECTED true  # need this to avoid constant rebuild
  PATCH_COMMAND 
    curl "https://gist.githubusercontent.com/alecjacobson/d34d9307c17d1b853571699b9786e9d1/raw/8d14fc21cb7654f51c2e8df4deb0f82f9d0e8355/gmp-patch" "|" git apply -v
  ${gmp_ExternalProject_Add_extra_options}
  CONFIGURE_COMMAND 
    emconfigure ${CMAKE_COMMAND} -E env
    CFLAGS=${gmp_CFLAGS}
    LDFLAGS=${gmp_LDFLAGS}
    ${prefix}/src/gmp/configure
    --disable-debug 
    --disable-dependency-tracking 
    --enable-cxx 
    --with-pic
    --prefix=${gmp_INSTALL}
    --build=none
    --host=none
    --disable-shared
  BUILD_COMMAND emmake make -j${Ncpu}
  INSTALL_COMMAND emmake make -j${Ncpu} install
  INSTALL_DIR ${gmp_INSTALL}
  TEST_COMMAND ""
  BUILD_BYPRODUCTS ${gmp_LIBRARY}
  DOWNLOAD_EXTRACT_TIMESTAMP TRUE
)
ExternalProject_Get_Property(gmp SOURCE_DIR)
set(gmp_LIBRARIES ${gmp_LIBRARY})
add_library(gmp::gmp INTERFACE IMPORTED GLOBAL)
file(MAKE_DIRECTORY ${gmp_INCLUDE_DIR})  # avoid race condition
target_include_directories(gmp::gmp INTERFACE ${gmp_INCLUDE_DIR})
target_link_libraries(gmp::gmp INTERFACE "${gmp_LIBRARIES}")  # need the quotes to expand list
add_dependencies(gmp::gmp gmp)

if(NOT TARGET gmp::gmp)
  message(FATAL_ERROR "Creation of target 'gmp::gmp' failed")
endif()