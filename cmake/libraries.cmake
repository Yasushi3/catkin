
# BUILD_SHARED_LIBS is a global cmake variable (usually defaults to on) 
# that determines the build type of libraries:
#   http://www.cmake.org/cmake/help/cmake-2-8-docs.html#variable:BUILD_SHARED_LIBS
# It defaults to shared.
#
# Our only current major use case for static libraries is
# via the mingw cross compiler, though embedded builds
# could be feasibly built this way also (largely untested).

# Cached variable
option(BUILD_SHARED_LIBS "Build dynamically-linked binaries" ON)

function(configure_shared_library_build_settings)
  if (BUILD_SHARED_LIBS)
    message(STATUS "BUILD_SHARED_LIBS is on.")
    add_definitions(-DROS_BUILD_SHARED_LIBS=1)
  else()
    message(STATUS "BUILD_SHARED_LIBS is off.")
  endif()
endfunction()

function(configure_boost_build_settings)
  #set(Boost_DETAILED_FAILURE_MSG TRUE)
  #set(Boost_DEBUG TRUE)
  set(Boost_USE_MULTITHREADED ON)
  if(BUILD_SHARED_LIBS)
    set(Boost_USE_STATIC_LIBS OFF)
    set(Boost_USE_STATIC_RUNTIME OFF)
	# Make sure we don't auto-link in windoze 
	# (better portability -> see FindBoost.cmake)
    add_definitions(-DBOOST_ALL_NO_LIB)
	# This is actually redundant since we turn off auto-linking above
	# Ordinarily it will choose dynamic links instead of static links
    add_definitions(-DBOOST_ALL_DYN_LINK=1)
    # Set BOOST_LIB_DIAGNOSTIC if you want auto-linking messages
  else()
    set(Boost_USE_STATIC_LIBS ON)
    set(Boost_USE_STATIC_RUNTIME ON)
  endif()
endfunction()