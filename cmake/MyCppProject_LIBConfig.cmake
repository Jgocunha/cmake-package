include("${CMAKE_CURRENT_LIST_DIR}/${LIB_PROJECT}Targets.cmake")

target_include_directories(${LIB_PROJECT}  INTERFACE
  $<INSTALL_INTERFACE:include/${LIB_PROJECT}>
)