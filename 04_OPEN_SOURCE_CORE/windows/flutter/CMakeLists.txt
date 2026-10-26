# Generated file, do not edit.

cmake_minimum_required(VERSION 3.14)

set(EPHEMERAL_DIR "${CMAKE_CURRENT_SOURCE_DIR}/ephemeral")

# Configuration provided via flutter tool.
include(${EPHEMERAL_DIR}/generated_config.cmake OPTIONAL)

set(WRAPPER_ROOT "${EPHEMERAL_DIR}/cpp_client_wrapper")

# === Flutter Library ===
set(FLUTTER_LIBRARY "${EPHEMERAL_DIR}/flutter_windows.dll")
set(FLUTTER_LIBRARY ${FLUTTER_LIBRARY} PARENT_SCOPE)

# Standard settings function
function(APPLY_STANDARD_SETTINGS TARGET)
  target_compile_features(${TARGET} PUBLIC cxx_std_17)
  target_compile_options(${TARGET} PRIVATE /W4 /WX /wd"4100")
  target_compile_options(${TARGET} PRIVATE /EHsc)
  target_compile_definitions(${TARGET} PRIVATE "_HAS_EXCEPTIONS=0")
  target_compile_definitions(${TARGET} PRIVATE "$<$<CONFIG:Debug>:_DEBUG>")
endfunction()

add_library(flutter INTERFACE)
target_include_directories(flutter INTERFACE
  "${EPHEMERAL_DIR}"
)

add_library(flutter_wrapper_app INTERFACE)
target_include_directories(flutter_wrapper_app INTERFACE
  "${EPHEMERAL_DIR}"
)

add_custom_target(flutter_assemble)
