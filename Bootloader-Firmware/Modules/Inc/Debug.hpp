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
#include <stdint.h>


// ----- NAMESPACES
namespace Debug
{
	// ----- FUNCTION DECLARATIONS
	void log(const char* string, const uint16_t len);
	void log(const char* string);
	void logf(const char* string, ...);
};


#endif // _DEBUG_HPP_

// END WITH NEW LINE
