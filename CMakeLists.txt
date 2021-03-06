cmake_minimum_required(VERSION 3.13.4)

if(POLICY CMP0068)
  cmake_policy(SET CMP0068 NEW)
  set(CMAKE_BUILD_WITH_INSTALL_NAME_DIR ON)
endif()

if(POLICY CMP0075)
  cmake_policy(SET CMP0075 NEW)
endif()

if(POLICY CMP0077)
  cmake_policy(SET CMP0077 NEW)
endif()

include(FetchContent)

project(PlaidML LANGUAGES C CXX)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(PML_IDE_FOLDER PML)
set(PLAIDML_VERSION 1.0.0)
set(MAIN_BRANCH plaidml-v1)
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

if("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows")
  # Support for ninja on windows
  enable_language(ASM)
  add_compile_definitions(
    _SILENCE_ALL_CXX17_DEPRECATION_WARNINGS
    NOMINMAX
    WIN32_LEAN_AND_MEAN
  )
endif()

# -------------------------------------------------------------------------------
# Project component configuration
# -------------------------------------------------------------------------------
option(PML_BUILD_TESTS "Builds PML unit tests." ON)
option(PML_OPENVINO_BRIDGE "Enable the OpenVINO plugin" ON)
option(PML_ENABLE_OPENCL "Enable OpenCL support" ON)
option(PML_ENABLE_VULKAN "Enable Vulkan support" ON)

list(APPEND CMAKE_MODULE_PATH
  ${CMAKE_CURRENT_LIST_DIR}/cmake
  ${CMAKE_CURRENT_LIST_DIR}/cmake/third_party
)

find_program(CCACHE_PROGRAM ccache)
if(CCACHE_PROGRAM)
  set(CMAKE_C_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
  set(CMAKE_CXX_COMPILER_LAUNCHER "${CCACHE_PROGRAM}")
endif()

# -------------------------------------------------------------------------------
# Third party dependencies
# -------------------------------------------------------------------------------
include(CPM)
include(boost)
include(easylogging)
include(gflags)
include(googletest)
include(half)
include(llvm-project)
if(PML_ENABLE_OPENCL)
  include(opencl_headers)
  include(opencl_hpp_headers)
  include(opencl_icd_loader)
endif()
if(PML_ENABLE_VULKAN)
  include(vulkan_headers)
  include(volk)
endif()
include(xsmm)

# -------------------------------------------------------------------------------
# Enable testing
# -------------------------------------------------------------------------------
if(PML_BUILD_TESTS)
  enable_testing()
  add_custom_target(check-smoke
    COMMAND ${CMAKE_CTEST_COMMAND} -L smoke
    USES_TERMINAL
  )
  add_custom_target(check-test
    COMMAND ${CMAKE_CTEST_COMMAND} -L test
    USES_TERMINAL
  )
endif()

# -------------------------------------------------------------------------------
# cmake modules
# -------------------------------------------------------------------------------
include(pml_format)
include(pml_copts)
include(pml_macros)
include(pml_cc_binary)
include(pml_cc_library)
include(pml_cc_test)
include(pml_lit_test)
include(pml_tblgen_library)
include(pml_whole_archive_link)

get_directory_property(HAS_PARENT PARENT_DIRECTORY)
if(HAS_PARENT)
  set(IS_SUBPROJECT TRUE)
else()
  add_custom_target(check
    DEPENDS
      check-test
      check-clang-format
  )
endif()

# Set general cpack variables for package description
set(CPACK_GENERATOR "TGZ")
set(CPACK_ARCHIVE_COMPONENT_INSTALL 1)
set(CPACK_PACKAGE_NAME "PlaidML")
set(CPACK_PACKAGE_VENDOR "Intel Corp")
set(CPACK_PACKAGE_CONTACT "Intel")
set(CPACK_PACKAGE_VERSION ${PLAIDML_VERSION})
set(CPACK_COMPONENTS_IGNORE_GROUPS 1)
set(CPACK_COMPONENTS_ALL
  devkit
  testkit
)
include(CPack)


add_subdirectory(plaidml)
add_subdirectory(pmlc)
add_subdirectory(docs)

# Note: this must be called after all libraries have been declared.
pml_complete_binary_link_options()

configure_lit_site_cfg(
  ${CMAKE_CURRENT_SOURCE_DIR}/lit.site.cfg.py.in
  ${CMAKE_CURRENT_BINARY_DIR}/lit.site.cfg.py
  MAIN_CONFIG
  ${CMAKE_CURRENT_SOURCE_DIR}/lit.cfg.py
)

include(devkit)
