cmake_minimum_required(VERSION 3.15)

project(__NAME VERSION 1.0.0)

find_package(PACKAGE CONFIG REQUIRED)
add_executable(${CMAKE_PROJECT_NAME} __PATH)
target_link_libraries(${CMAKE_PROJECT_NAME})

add_custom_target(run
	COMMAND ${CMAKE_PROJECT_NAME}
	DEPENDS ${CMAKE_PROJECT_NAME}
	WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
)
