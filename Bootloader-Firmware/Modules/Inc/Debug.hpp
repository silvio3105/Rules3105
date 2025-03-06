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
#define VERBOSE_OUTPUTF	Debug::__outputf
#else
#define VERBOSE_OUTPUTF	Debug::__dummy
#endif // DEBUG_VERBOSE

#ifdef DEBUG_INFO
#define INFO_OUTPUTF	Debug::__outputf
#else
#define INFO_OUTPUTF	Debug::__dummy
#endif // DEBUG_INFO

#ifdef DEBUG_ERROR
#define ERROR_OUTPUTF	Debug::__outputf
#else
#define ERROR_OUTPUTF	Debug::__dummy
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
	 * 
	 * \addtogroup Debug
	 */	
	inline void __output(const char* string, const uint16_t len)
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
	 * 
	 * \addtogroup Debug
	 */
	inline void __output(const char* string)
	{
		#ifdef DEBUG
		__output(string, strlen(string));
		#endif // DEBUG
	}

	void __outputf(const char* string, ...);
	void __dummy(...);

	/**
	 * @brief Output verbose prints.
	 * 
	 * @param string Pointer to constant string.
	 * @param len Length of \c string
	 * 
	 * @return No return value. 
	 * 
	 * \addtogroup Debug
	 * @{
	 */	
	inline void verbose(const char* string, const uint16_t len)
	{
		#ifdef DEBUG_VERBOSE
		__output(string, len);
		#endif // DEBUG_VERBOSE
	}

	inline void verbose(const char* string)
	{
		#ifdef DEBUG_VERBOSE
		__output(string, strlen(string));
		#endif // DEBUG_VERBOSE
	}

	/** @} */
	
	/**
	 * @brief Output info prints.
	 * 
	 * @param string Pointer to constant string.
	 * @param len Length of \c string
	 * 
	 * @return No return value. 
	 * 
	 * \addtogroup Debug
	 * @{
	 */	
	inline void info(const char* string, const uint16_t len)
	{
		#ifdef DEBUG_INFO
		__output(string, len);
		#endif // DEBUG_INFO
	}

	inline void info(const char* string)
	{
		#ifdef DEBUG_INFO
		__output(string, strlen(string));
		#endif // DEBUG_INFO
	}

	/** @} */

	/**
	 * @brief Output error prints.
	 * 
	 * @param string Pointer to constant string.
	 * @param len Length of \c string
	 * 
	 * @return No return value.
	 *  
	 * \addtogroup Debug
	 * @{
	 */	
	inline void error(const char* string, const uint16_t len)
	{
		#ifdef DEBUG_ERROR
		__output(string, len);
		#endif // DEBUG_ERROR
	}

	inline void error(const char* string)
	{
		#ifdef DEBUG_ERROR
		__output(string, strlen(string));
		#endif // DEBUG_ERROR
	}
	
	/** @} */
};


// ----- SNIPPETS
/**
 * @brief Enable verbose debug.
 *  
 * \addtogroup Debug
 */
#define DEBUG_VERBOSE_ENABLE() \
	static const auto& PRINTN = static_cast<void(*)(const char*, const uint16_t)>(Debug::verbose); \
	static const auto& PRINT = static_cast<void(*)(const char*)>(Debug::verbose); \
	static constexpr auto& PRINTF = VERBOSE_OUTPUTF;

/**
 * @brief Enable info debug.
 *  
 * \addtogroup Debug
 */
#define DEBUG_INFO_ENABLE() \
	static const auto& PRINTN_INFO = static_cast<void(*)(const char*, const uint16_t)>(Debug::info); \
	static const auto& PRINT_INFO = static_cast<void(*)(const char*)>(Debug::info); \
	static constexpr auto& PRINTF_INFO = INFO_OUTPUTF;	

/**
 * @brief Enable error debug.
 *  
 * \addtogroup Debug
 */
#define DEBUG_ERROR_ENABLE() \
	static const auto& PRINTN_ERROR = static_cast<void(*)(const char*, const uint16_t)>(Debug::error); \
	static const auto& PRINT_ERROR = static_cast<void(*)(const char*)>(Debug::error); \
	static constexpr auto& PRINTF_ERROR = ERROR_OUTPUTF;
	
/**
 * @brief Disable verbose debug.
 *  
 * \addtogroup Debug
 */
#define DEBUG_VERBOSE_DISABLE() \
	static constexpr auto& PRINTN = Debug::__dummy; \
	static constexpr auto& PRINT = Debug::__dummy; \
	static constexpr auto& PRINTF = Debug::__dummy;	

/**
 * @brief Disable info debug.
 *  
 * \addtogroup Debug
 */
#define DEBUG_INFO_DISABLE() \
	static constexpr auto& PRINTN_INFO = Debug::__dummy; \
	static constexpr auto& PRINT_INFO = Debug::__dummy; \
	static constexpr auto& PRINTF_INFO = Debug::__dummy;	
	
/**
 * @brief Disable error debug.
 *  
 * \addtogroup Debug
 */
#define DEBUG_ERROR_DISABLE() \
	static constexpr auto& PRINTN_ERROR = Debug::__dummy; \
	static constexpr auto& PRINT_ERROR = Debug::__dummy; \
	static constexpr auto& PRINTF_ERROR = Debug::__dummy;		



#endif // _DEBUG_HPP_

// END WITH NEW LINE
