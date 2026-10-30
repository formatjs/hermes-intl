cmake_minimum_required(VERSION 3.13)
project(appmodules)

include(${REACT_ANDROID_DIR}/cmake-utils/ReactNative-application.cmake)

if(NOT DEFINED FORMATJS_HERMES_SDK)
  message(FATAL_ERROR "Set FORMATJS_HERMES_SDK to extracted Android SDK directory")
endif()

include("${FORMATJS_HERMES_SDK}/cmake/FormatJSIntl.cmake")
formatjs_intl(${CMAKE_PROJECT_NAME})
target_compile_features(${CMAKE_PROJECT_NAME} PRIVATE cxx_std_20)
