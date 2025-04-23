cmake_minimum_required(VERSION 3.15)
set(PROJECT_NAME "snap_layouts")
project(${PROJECT_NAME} LANGUAGES CXX)

set(PLUGIN_NAME "snap_layouts_plugin")

add_library(${PLUGIN_NAME} SHARED
  "snap_layouts_plugin.cpp"
)

apply_standard_settings(${PLUGIN_NAME})

set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)
# target_compile_definitions(${PLUGIN_NAME} PRIVATE _SILENCE_CXX17_CODECVT_HEADER_DEPRECATION_WARNING)

target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin)

set(snap_layouts_bundled_libraries
  ""
  PARENT_SCOPE
)
