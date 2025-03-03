/**
 * @file Debug.hpp
 * @author silvio3105 (www.github.com/silvio3105)
 * @brief Debug header file.
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

#ifndef _DEBUG_HPP_
#define _DEBUG_HPP_

// ----- INCLUDE FILES
#include			"SEGGER_RTT.h"

#include 			<stdint.h>
#include 			<string.h>


// ----- DEFINES
#ifdef DEBUG_VERBOSE
#define DEBUG_PRINT				DEBUG_HANDLER_PRINT
#define DEBUG_PRINTF			DEBUG_HANDLER_PRINTF
#else
#define DEBUG_PRINT(...)		
#define DEBUG_PRINTF(...)	
#endif // DEBUG_VERBOSE

#ifdef DEBUG_INFO
#define DEBUG_PRINT_INFO		DEBUG_HANDLER_PRINT
#define DEBUG_PRINTF_INFO		DEBUG_HANDLER_PRINTF
#else
#define DEBUG_PRINT_INFO(...)		
#define DEBUG_PRINTF_INFO(...)	
#endif // DEBUG_INFO

#ifdef DEBUG_ERROR
#define DEBUG_PRINT_ERROR		DEBUG_HANDLER_PRINT
#define DEBUG_PRINTF_ERROR		DEBUG_HANDLER_PRINTF
#else
#define DEBUG_PRINT_ERROR(...)		
#define DEBUG_PRINTF_ERROR(...)	
#endif // DEBUG_ERROR


// ----- NAMESPACES
namespace Debug
{
	// FUNCTION DECLARATIONS
	/**
	 * @brief Output constant debug string.
	 * 
	 * @param string Pointer to constant string.
	 * @param len Length of \c string
	 * 
	 * @return No return value. 
	 * \addtogroup Debug
	 */	
	inline void log(const char* string, const uint16_t len)
	{
		#ifdef DEBUG
		SEGGER_RTT_Write(0, string, len);
		#endif // DEBUG
	}

	/**
	 * @brief Output constant string of unknown length.
	 * 
	 * @param string Pointer to constant string.
	 * 
	 * @return No return value.
	 * \addtogroup Debug
	 */
	inline void log(const char* string)
	{
		#ifdef DEBUG
		log(string, strlen(string));
		#endif // DEBUG
	}

	void logf(const char* string, ...);
};


#endif // _DEBUG_HPP_

// END WITH NEW LINE
