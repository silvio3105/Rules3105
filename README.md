
# About

This repo contains rules I obey in my projects.


# Application layers

<p align="center">
  <img src=".docs/Application%20layers.png" alt="Application layers diagram" title="Application layers diagram" />
</p>

The diagram shows the application layers.

### Hardware

The base for every application. It is the only physical layer.

### Drivers

Drivers are the gate for other layers of the application to interact with the hardware. They are written with minimal logic inside. Every driver is written without the other driver(s). The only way for the driver to interact with hardware(eg., I2C sensor, SPI flash, GPIO, etc.) is through an external handlers(user provided). Because of that, drivers are not fixed to certain MCU or SDK/framework. Drivers are not written with application logic. Drivers can interact with libraries. Every driver is written as a C++ class within its own namespace.

### Libraries

Libraries are pieces of software with basic logic and do not require interactions with the hardware. Every layer can use libraries. Libraries are not written with application logic. Every library is written within its own C++ namespace. Eg., a library with string manipulation functions.

### Modules

Modules are pieces of application logic. Each module combines drivers and libraries with application logic. Eg., ADC module will interact with ADC driver and provide access to voltage info for other modules. So other modules do not care about how voltage is measured. Each module is written within its own C++ namespace.

### Application

Application layer is made from RTOS tasks(or just `main` "task" in bare metal). If RTOS is used, every module will have its own task or will share task with other module.
Application layer glues different modules together and creates functional application. 


# Project templates

- [Application template](https://github.com/silvio3105/AppTemplate)
- [Library/driver template](https://github.com/silvio3105/LibTemplate)


# Versioning & Naming
### Software versioning

- **Application: vX.Y.Z(rcA)**
    - **Z**: Build number. Starts from zero. Cannot go over 99. With leading zero(if `Z` is not zero). Increased by some amount by bug fixes. Resets to zero when `Y` increases.
    - **Y**: Minor version number. Starts from zero. Cannot go over 99. With leading zero(if `Y` is not zero). Increased by one when `Z` overflows or new features are introduced. Resets to zero when `X` increases.
    - **X**: Mayor version number. Can start from zero. Cannot go over 99. Without leading zero. Increased by one when `Y` overflows or when big changes are introduced.
    - **rc**: Stands for release candidate which means test release.
    - **A**: Release candidate number. Starts from one. Cannot go over 99. Without leading zero. Increased by one with every new release candidate.

    `X` = 0 means the software does not contain all planned features for the first full release - beta phase (not the same as the release candidate).
    **Examples:**
    - `v0.13.18rc8` Release candidate #8 for version 0.13.18
    - `v13.12.0` Stable release, version 13.12.0

- **Library/Driver: vX.Y(rcA)**
	- **Y**: Minor version number. Starts from zero. Cannot go over 99. With leading zero(if `Y` is not zero). Increased by some amount with new features. Resets to zero when `X` increases.
    - **X**: Mayor version number. Can start from zero. Cannot go over 99. Without leading zero. Increased when `Y` overflows or with big update(eg., reworked project etc...).
    - **rc**: Stands for release candidate which means test release(version is not production ready).
    - **A**: Release candidate number. Starts from one. Cannot go over 99. Without leading zero. Increased by one with every new release candidate.
    
    `X` = 0 means the software does not contain all planned features for the first full release - beta phase (not the same as the release candidate).
    **Examples:**
    - `v0.01rc5` Release candidate #5 for version 0.01.
    - `v1.13` Stable release, version 1.13.

### Version timeline

`v1.10.32` -> `v1.11.0rc1` -> `v1.11.0rc2` -> `v1.11.0rc3` -> `v1.11.0` -> `v1.11.01`
`v1.0r1` -> `v1.0r2` -> `v1.1rc1` -> `v1.1rc2` -> `v1.1r1`

### Release naming

The naming rule is: **{app_name}\_{app_version}(_{HW})**
The rule also applies to naming application executables files(.bin and .hex).
Application name contains project name and application type tag, eg., `3DCLK-FW` is the name of firmware(FW) for 3D Clock. `3DCLK-BL` is the name of the bootloader(BL) for 3D Clock. The application name is max 16 chars long.
The firmware version is copied from the software versioning rule.
`_HW` is inserted in the case when release is for specific hardware, eg., hardware `22-0091rev1`.
One release can have multiple executables.
**Examples:**
- `3DCLK-FW_v0.13.18rc3` is release name for 3D Clock firmware, version 0.13.18, release candidate 3.
- `3DCLK-FW_v1.0.50rc1_22-0091rev1` is name of executables for hardware version `22-0091rev1`, release `3DCLK-FW_v1.0.50rc1` for 3D Clock, firmware version v1.0.50, release candidate 1.

### File naming

Every file is named with first uppercase letter(Main.cpp, not main.cpp).
Files made for C++ have a .hpp header file, while C files have a .h header file.


# Tools

List of the tools I use (Windows 10 Pro x64):
-	[VS Code](https://code.visualstudio.com/download)
	- [C/C++ IntelliSense by Microsoft](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
	- [Cortex-Debug by marus25](https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug)
	- [debug-tracker-vscode by mcu-debug](https://marketplace.visualstudio.com/items?itemName=mcu-debug.debug-tracker-vscode)
	- [Doxygen Documentation Generator by Christoph Schlosser](https://marketplace.visualstudio.com/items?itemName=cschlosser.doxdocgen)
	- [Hex Editor by Microsoft](https://marketplace.visualstudio.com/items?itemName=ms-vscode.hexeditor)
	- [Markdown All in One by Yu Zhang](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
	- [Markdown Preview by Yiyi Wang](https://marketplace.visualstudio.com/items?itemName=shd101wyy.markdown-preview-enhanced)
	- [MemoryView by mcu-debug](https://marketplace.visualstudio.com/items?itemName=mcu-debug.memory-view)
	- [Peripheral Viewer by mcu-debug](https://marketplace.visualstudio.com/items?itemName=mcu-debug.peripheral-viewer)
	- [RTOS Views by mcu-debug](https://marketplace.visualstudio.com/items?itemName=mcu-debug.rtos-views)
	- [Serial Monitor by Microsoft](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vscode-serial-monitor)
	- [Solarized by Ryan Olson](https://marketplace.visualstudio.com/items?itemName=ryanolsonx.solarized)
- [Git](https://git-scm.com/downloads)
- [ARM-GCC v14.2.Rel1 20241119](https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads)
- [GNU Make v3.81](https://gnuwin32.sourceforge.net/packages/make.htm)
- [Doxygen v1.9.8](https://www.doxygen.nl/download.html)
- [Graphviz v12.2.1](https://graphviz.org/download/)
- [SEGGER J-Link v7.88e](https://www.segger.com/downloads/jlink/)
- [STM32CubeMX](https://www.st.com/en/development-tools/stm32cubemx.html)
- [nRF PPK2](https://www.nordicsemi.com/Products/Development-hardware/Power-Profiler-Kit-2)
- [Salea Logic](https://www.saleae.com/downloads/)
- [CMSIS Configuration Wizard v0.0.7](https://sourceforge.net/projects/cmsisconfig/)
- [Draw.io](https://app.diagrams.net/)
- [Fusion 360 (Electronics)](https://www.autodesk.com/products/fusion-360/overview)
- [Saturn PCB Toolkit](https://saturnpcb.com/saturn-pcb-toolkit/)

### Environment variables

It is required to add next environment variables:
- `ARM-GCC` with location of bin folder from ARM-GCC.
- `JLink` with location of root J-Link folder.
- `Make` with location of bin folder from Make.
- Add location of Graphviz's bin folder to `Path` variable(Windows).

After adding variables, it is needed to log out from Windows account or reset whole PC.


# Code rules

### Indents

I prefer to use tabs for indents, size 4.

### C++ over C!

I prefer to use C++ over C, but only parts of C++ that do not induce runtime overhead and bloat, eg., classes, namespaces, templates and enum classes! CRTP pattern for drivers.

### Code layout

This is only a basic layout for source and header files. Layout depends on case-to-case and it is prone to changes.

- SourceFile.cpp:

    Defines, macro functions, enums, typedefs, structs, and classes in the translation unit means they are intended only and only for that translation unit.

	```cpp
	/**
	 * @file SourceFile.cpp
	 * @author silvio3105 (www.github.com/silvio3105)
	 * @brief This is template source file.
	 * 
	 * @copyright Copyright (c) 2025, silvio3105
	 * 
	 */

	// ----- INCLUDE FILES


	// ----- DEFINES


	// ----- ENUMS


	// ----- TYPEDEFS


	// ----- STRUCTS


	// ----- CLASSES	


	// ----- VARIABLES


	// ----- STATIC FUNCTION DECLARATIONS


	// ----- FUNCTION DEFINITIONS


	// ----- STATIC FUNCTION DEFINITIONS



	// END WITH NEW LINE

	```

- SourceFile.hpp
	```cpp
	/**
	 * @file SourceFile.hpp
	 * @author silvio3105 (www.github.com/silvio3105)
	 * @brief This is template header file.
	 * 
	 * @copyright Copyright (c) 2025, silvio3105
	 * 
	 */

	#ifndef _SOURCEFILE_HPP_
	#define _SOURCEFILE_HPP_

	// ----- INCLUDE FILES


	// ----- DEFINES


	// ----- MACRO FUNCTIONS


	// ----- NAMESPACES


	// ----- ENUMS


	// ----- TYPEDEFS


	// ----- STRUCTS


	// ----- CLASSES


	// ----- EXTERNS


	// ----- FUNCTION DECLARATIONS


	#endif // _SOURCEFILE_HPP_


	// END WITH NEW LINE

	```

### Code example

Pointers and references are written like this:

```cpp
uint8_t* ptr8 = nullptr;

void foo(uint16_t& argRef);
```

not like this:

```cpp
uint8_t * ptr8 = nullptr;
uint8_t *ptr8 = nullptr;

void foo(uint16_t & argRef);
void foo(uint16_t &argRef);
```

After comma should be space, so `uint8_t foo(void* ptr, uint16_t len);` not `uint8_t foo(void* ptr,uint16_t len);`. Same applies to arrays.

Here's complete code example:

```cpp

/*
    This is a comment block.
    The comment block is a multiline comment.
*/

// This is an inline comment

/*
    Defines are written in uppercase and space is replaced with underscore.
    Since defines does not have "namespace", every define should start with a module abbreviation, eg., "#define FWCFG_GSM_UART USART1".
    If a macro contains multiple elements(eg., another macro), its value is placed between ().
*/
#define THIS_IS_MACRO					value
#define THIS_IS_SECOND_MACRO			(THIS_IS_MACRO - 5)

/*
    The macro function is written in uppercase, it starts with two underscores, and spaces are replaced with underscores.
    Argument names start with underscore and the first letter is in lowercase.
    The function body is written in a new line.
*/
#define __THIS_IS_MACRO_FUNCTION(_argOne, _argTwo) \
    ((_argOne) - (_argTwo))

/*
    Same as classes:
    Enum value names in the enum class are named with uppercase letters for every word.
    Value names do not start with an abbreviation(eg., "ERROR", not "GSM_ERROR").
*/
enum class EnumClass_t : uint16_t
{
    One = 0,
    Two
};

// Type alias is written using the same rules as enum classes. 
typedef uint16_t Idx_t;

// Same for function typedef but it ends with "_f".
typedef void (*ExtHandler_f)(void);

/*
    Same as enum classes but it ends with "_s".
    Struct members are named using rules for global variables.
    Structs are used only for data storage(no functions/methods).
*/
struct ThisIsStruct_s
{
    uint8_t someVar;
    uint32_t* somePtr;
};

/*
    Classes hold data(as structs) and methods(not functions!) to manipulate the data.
    The class name is written with the uppercase first letter of every word in the name.
    Only the private part of the class contains variables. To get or set variables from outside, getter and setter methods are used.
    Variables and methods in class use naming rules from global variables and functions 
*/
/**
 * @brief Class brief.
 * 
 * Class description.
 */
class ThisIsClass
{
    public:
    ThisIsClass(void);
    ~ThisIsClass(void);

    uint8_t somePublicFunction(void);

	protected:
	// Here goes protected stuff (between public and private tag)

    private:
    char someArray[16]; /**< @brief This is inline doxygen comment. */

    inline void somePrivateFunction(void);
};

// Extern
extern volatile uint8_t someVaraible;

/*
    Global variable name starts with module abbreviation if not in namespace.
    Module abbreviation is written in lowercase while every other word starts in uppercase.
    The variable should have a default value.
*/
uint32_t thisIsVariable = 0;

/*
    Global function name starts with module abbreviation if not in namespace.
    Module abbreviation is written in lowercase while every other word starts in uppercase.
*/
/**
 * @brief Function brief.
 * 
 * Function description.
 * 
 * @param argOne Some argument.
 * @param argsList Some argument.
 * @param varRef Some argument.
 * 
 * @return No return value.
 */
void someFunction(const uint8_t argOne, uint16_t* argsList, uint32_t& varRef);

// Namespace uses naming rules from classes. Content in the namespace uses the same global type rule.
namespace SomeNameSpace
{
    // VARIABLES
    uint64_t xVar;

    // FUNCTIONS
    void setFoo(char someChar);
};

```

### Code workflow comments

For some reason, I like to add a bunch of "workflow comments".
Workflow comments describe what the lines below (comment) do. I tend to "group" lines of code into little sections.

```cpp
void foo(void)
{
	float tmp = 0.00f; // Every float value has two decimal digits and f to indicate float, not double
	uint16_t x = 1;
	char str[32] = { '\0' };
	uint32_t* ptr = nullptr;

	// Execute something with value x
	exe(x);

	// Calculate result and convert it
	foo2(ptr, x);
	tmp = 2.00f * (*ptr);

	// Do something with value
	if (tmp > 10.00f)
	{
		tmp = 10.00f;
	}
	else
	{
		tmp -= 0.55f;
	}

	// Check does string exist
	if (str[0])
	{
		// Do something with string		
	}
	else // String does not exist, abort
	{
		return;
	}

	// ...
}
```

### Nested if statments

I prefer less nested code. If I can check requirements before the function does its job, I do it.

Short examples:
```cpp
void foo(void)
{
	// Check if device is online
	if (isOnline())
	{
		// Check if data is ready
		if (isReady())
		{
			// Send data
			bar();
			bar2();
		}
		else
		{
			print("Not ready\n");
		}
	}
	else
	{
		print("Not online\n");
	}
}
```

```cpp
void foo(void)
{
	// Abort if not online
	if (!isOnline())
	{
		print("Not online\n");
		return;
	}

	// Abort if data is not ready
	if (!isReady())
	{
		print("Not ready\n");
		return:	
	}

	// Send data
	bar();
	bar2();
}
```

### Single or multi line if statment

For the sake of easy debugging I prefer multi line if statments.

```cpp
if (statment)
{
	foo();
}
```

not

```cpp
if (statment) foo();
```

or 

```cpp
if (statment)
	foo();
```

### Curly bracket placment

Every curly bracket is in new line.

```cpp
function()
{
	someCodeHere;
	foo();
	return 1;
}
```

Not like this(or any variation where curly bracket is not in new line)

```cpp
function() {
	someCodeHere;
	foo();
	return 1;
}
```

Except for simple arrays.

```cpp
uint8_t arr[] = { 1, 2, 3, 4, 5 };
```



### Declarations & Definitions

Declarations are placed in header files(.hpp).<br>
Definitions and private (static) stuff are placed in translation units(.cpp).<br>
Inline and template stuff are defined in header files.
