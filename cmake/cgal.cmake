if(TARGET CGAL::CGAL)
    return()
endif()

include(FetchContent)

message(STATUS "Third-party: creating target 'CGAL::CGAL'")

FetchContent_Declare(
  cgal
  GIT_REPOSITORY https://github.com/CGAL/cgal.git
  GIT_TAG v5.6.1
  FIND_PACKAGE_ARGS
)

FetchContent_MakeAvailable(cgal)

# add_library(CGAL::CGAL INTERFACE IMPORTED GLOBAL)
target_include_directories(CGAL::CGAL INTERFACE ${cgal_SOURCE_DIR})
add_dependencies(CGAL::CGAL CGAL)

if(NOT TARGET CGAL::CGAL)
  message(FATAL_ERROR "Creation of target 'CGAL::CGAL' failed")
endif()