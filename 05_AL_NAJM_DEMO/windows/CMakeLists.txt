cmake_minimum_required(VERSION 3.14)
project(al_najm_wallet_demo LANGUAGES CXX)

set(BINARY_NAME "al_najm_wallet_demo")

cmake_policy(SET CMP0079 NEW)

set(INSTALL_BUNDLE_DATA_DIR "${CMAKE_INSTALL_PREFIX}/data")
set(INSTALL_BUNDLE_LIB_DIR "${CMAKE_INSTALL_PREFIX}")

add_subdirectory(flutter)
add_subdirectory(runner)

set(FLUTTER_MANAGED_DIR "${CMAKE_CURRENT_SOURCE_DIR}/flutter")
