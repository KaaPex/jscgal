cmake_minimum_required(VERSION 3.16)
project(jscgal)

list(PREPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# include(cgal)

include(gmp)

include(mpfr)

# include(boost)

# include_directories(
#   include
# )

# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -s USE_BOOST_HEADERS=1")
# set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --bind")

# file(GLOB_RECURSE SRC_FILES "src/*.cpp")
# add_executable(${PROJECT_NAME} ${SRC_FILES})

# target_link_libraries(${PROJECT_NAME} PUBLIC
#   CGAL::CGAL
#   CGAL::CGAL_Core
# )