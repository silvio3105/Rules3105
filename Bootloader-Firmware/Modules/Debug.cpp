/**
 * @file Debug.cpp
 * @author silvio3105 (www.github.com/silvio3105)
 * @brief Debug source file.
 * 
 * @copyright Copyright (c) 2025, silvio3105
 * 
 */

/*
	Copyright (c) 2025, silvio3105 (www.github.com/silvio3105)

	Access and use of this Project and its contents are granted free of charge to any Person.
	The Person is allowed to copy, modify and use The Project and its contents only for non-commercial use.
	Commercial use of this Project and its contents is prohibited.
	Modifying this License and/or sublicensing is prohibited.

	THE PROJECT AND ITS CONTENT ARE PROVIDED "AS IS" WITH ALL FAULTS AND WITHOUT EXPRESSED OR IMPLIED WARRANTY.
	THE AUTHOR KEEPS ALL RIGHTS TO CHANGE OR REMOVE THE CONTENTS OF THIS PROJECT WITHOUT PREVIOUS NOTICE.
	THE AUTHOR IS NOT RESPONSIBLE FOR DAMAGE OF ANY KIND OR LIABILITY CAUSED BY USING THE CONTENTS OF THIS PROJECT.

	This License shall be included in all functional textual files.
*/

// ----- INCLUDE FILES
#include			DEBUG_SRC
#include			"SEGGER_RTT.h"

#include			<stdint.h>
#include 			<string.h>
#include			<stdio.h>


// ----- DEFINES
#define RTT_CH_IDX							0 /**< @brief Segger RTT buffer index. */
#ifndef DEBUG_BUFFER_SIZE
#define DEBUG_BUFFER_SIZE					128 /**< @brief Buffer size in bytes for formatted strings. */
#endif // DEBUG_BUFFER_SIZE
//#define DEBUG_STACK_BUFFER /**< @brief Uncomment this to use stack buffer for formatted strings (thread-safe).  */


// ----- VARIABLES
#if !defined(DEBUG_STACK_BUFFER) && defined(DEBUG)
char buffer[DEBUG_BUFFER_SIZE];
#endif // DEBUG_STACK_BUFFER && DEBUG


// ----- FUNCTION DEFINITIONS
/**
 * @brief Output constant debug string.
 * 
 * @param string Pointer to constant string.
 * @param len Length of \c string
 * 
 * @return No return value. 
 */
void Debug::log(const char* string, const uint16_t len)
{
	#ifdef DEBUG
	SEGGER_RTT_Write(RTT_CH_IDX, string, len);
	#endif // DEBUG
}

/**
 * @brief Output constant string of unknown length.
 * 
 * @param string Pointer to constant string.
 * 
 * @return No return value.
 */
void Debug::log(const char* string)
{
	#ifdef DEBUG
	Debug::log(string, strlen(string));
	#endif // DEBUG
}

/**
 * @brief Output formatted string.
 * 
 * @param string Debug string format.
 * @param ... String arguments.
 * 
 * @return No return value
 */
void Debug::logf(const char* string, ...)
{
	#ifdef DEBUG

	#ifdef DEBUG_STACK_BUFFER
	char buffer[DEBUG_BUFFER_SIZE];
	#endif // DEBUG_STACK_BUFFER

	va_list args;
	va_start(args, string);
	uint16_t len = vsnprintf(buffer, sizeof(buffer), string, args);
	Debug::log(buffer, len);
	va_end(args);

	#endif // DEBUG
}


// END WITH NEW LINE
