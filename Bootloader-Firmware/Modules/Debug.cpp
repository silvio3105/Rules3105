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
#include			<stdio.h>


/**
 * @addtogroup Debug
 * 
 * Module with debug print functions.
 * @{
 */


// ----- DEFINES
#ifndef DEBUG_BUFFER_SIZE
#define DEBUG_BUFFER_SIZE					128 /**< @brief Buffer size in bytes for formatted strings. */
#endif // DEBUG_BUFFER_SIZE


// ----- NAMESPACES
/**
 * @brief Debug namespace.
 * 
 */
namespace Debug
{

	// FUNCTION DEFINITIONS
	/**
	 * @brief Output formatted string.
	 * 
	 * @param string Debug string format.
	 * @param ... Format arguments.
	 * 
	 * @return No return value
	 */
	void logf(const char* string, ...)
	{
		#ifdef DEBUG

		#ifdef DEBUG_STACK_PRINTF
		char buffer[DEBUG_BUFFER_SIZE];
		#else
		static char buffer[DEBUG_BUFFER_SIZE];
		#endif // DEBUG_STACK_PRINTF

		va_list args;
		va_start(args, string);
		uint16_t len = vsnprintf(buffer, sizeof(buffer), string, args);
		DEBUG_PRINT(buffer, len);
		va_end(args);

		// Prevent warning if no debug level is enabled
		#if !defined(DEBUG_VERBOSE) && !defined(DEBUG_INFO) && !defined(DEBUG_ERROR)
		(void)len;
		#endif 

		#endif // DEBUG
	}

};

/** @} */

// END WITH NEW LINE
