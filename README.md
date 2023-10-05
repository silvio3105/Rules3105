
# ABOUT

This repo contains a template for projects I use. Template includes:
- Makefile for building the projects(multi hardware builds and RTOS are supported)
- Readme file
- License file
- Git ignore file
- Project structures
- Set of coding rules I follow in embedded software development


# PROJECT APPLICATION STRUCTURE

**This part applies only to firmware projects.**

<p align="center">
  <img src=".docs/Project%20structure.png" alt="Project application structure diagram" title="Project application structure diagram" />
</p>

The diagram shows the project structure. It goes from the base up.

### Hardware

The base for every project. It runs the project.

### Drivers

Drivers are the gate for other layers of the application to interact with the hardware. They are written with minimal logic inside. Every driver is written without another driver(s). The only way for the driver to interact with hardware(eg., I2C sensor, SPI flash, GPIO, etc.) is through an external handler(user provided). Because of that, drivers are not fixed to certain MCU or framework.<br>
Drivers are not written with application logic. They are like little legos, You can use them everywhere. Drivers can interact with libraries.<br>
Every driver is written as a C++ class within its namespace.

### Libraries

Libraries are pieces of software with basic logic and do not require interactions with the hardware. Every layer can use libraries. Libraries are not written with application logic.<br>
Every library is written within its namespace.<br>
Eg., a library with string manipulation functions.

### Application modules

Application modules combine drivers and libraries to produce basic logic for the application. Module alone is worthless(one plank is not a bench, but many planks combined create the bench).<br>
Every module has its namespace and can be written as one or more C++ classes.<br>

### Tasks

Tasks combine application modules and their logic to do something useful. In the case of the bare metal project, there is only one task - an endless loop in `main()`.


# PROJECT FOLDER STRUCTURE

### Bootloader/firmware project folder structure

- 📂 **{Project_name}**: Root folder.
    - 📂 **.builds**: Folder with per hardware build folders(used by Make and ARM-GCC).
        - 📂 **{Build_name}**
    - 📂 **.git**: Git folder.
    - 📂 **.jlink**: Folder with J-Link scripts for flash and erase.
    - 📂 **.releases**: Folder with stable releases.
        - 📂 **RC**: Folder with release candidate releases.
    - 📂 **.vscode**: Folder with VS Code config files.
    - 📂 **Application**: Folder with application layer source files.
        - 📂 **Inc**: Folder with application layer header files.
        - 📂 **Tasks**: Folder with task source files.
            - 📂 **Inc**: Folder with task header files.
    - 📂 **CMSIS**: Folder with CMSIS-related files.
      - 📂 **Core**: Folder with CMSIS-related core files.
      - 📂 **RTX**: Folder with CMSIS RTX source files.
        	- 📂 **Inc**: Folder with CMSIS RTX header files.
            - 📂 **IRQ**: Folder with RTX startup files. 
    - 📂 **Config**: Folder with hardware-related configuration files.
    - 📂 **Documentation**: Folder with project documentation generated with Doxygen and files used for documentation.
    - 📂 **Drivers**: Folder with driver source files.
        - 📂 **{Driver_Name}**
            - 📂 **Inc**: Folder with driver header files.
    - 📂 **Libraries**: Folder with library source files.
        - 📂 **Inc**: Folder with library header files.
    - 📂 **Linker**: Folder with linker scripts. 
    - 📂 **Make**: Folder with per hardware Make files.
    - 📂 **MCU**: Folder with MCU-related source files.
        - 📂 **Inc**: Folder with MCU-related header files.
    - .gitignore: List of items for Git to ignore.
    - AppConfig.hpp: Header file with configuration for application layer.
    - Doxyfile: Doxygen project file.
    - LICENSE: Project license.
    - Main.cpp: Main source file with application entry point.
    - main.h: Legacy main header file.
    - Main.hpp: Main header file.
    - README.md: Project readme file.

**Note:**
- MCU-related drivers are grouped with folder in `Drivers` folder(both source and header files).
- Folder `Make` contains one Make file for every hardware version.

### Driver/library project folder structure

- 📂 **{Project_name}**: Root folder.
    - 📂 **.git**: Git folder.
    - 📂 **.vscode**: Folder with VS Code config files.
    - 📂 **Documentation**: Folder with project documentation generated with Doxygen and files used for documentation.
    - 📂 **Example**: Folder with project example files. 
    - .gitignore: List of items for Git to ignore.
    - Doxyfile: Doxygen project file.
    - LICENSE: Project license.
    - README.md: Project readme file.

**Note:**
Driver/library files are placed in root folder or in `Src` or `Inc` folder if project has multiple source or header files.




# VERSIONING & NAMING
### Software versioning

- **Library/Driver: vX.Y(rcA)**<br>
	- **Y**: Minor version number. Starts from zero. Cannot go over 99. With leading zero(if `Y` is not zero). Increased by some amount by bug fixes and new features. Resets to zero when `X` increases.
    - **X**: Mayor version number. Can start from zero. Cannot go over 99. Without leading zero. Increased when `Y` overflows.
    - **rc**: Stands for release candidate which means test release.
    - **A**: Release candidate number. Starts from one. Cannot go over 99. Without leading zero. Increased by one with every new release candidate.
    
    `X` = 0 means the software does not contain all features for the first full release - beta phase (not the same as the release candidate).<br>
    **Examples:**<br>
    - `v0.01rc5` Release candidate #5 for version 0.01.
    - `v1.13` Stable release, version 1.13.
<br>

- **Application: vX.Y.Z(rcA)**<br>
    - **Z**: Build number. Starts from zero. Cannot go over 99. With leading zero(if `Z` is not zero). Increased by some amount by bug fixes. Resets to zero when `Y` increases.
    - **Y**: Minor version number. Starts from zero. Cannot go over 99. With leading zero(if `Y` is not zero). Increased by one when `Z` overflows or new features are introduced. Resets to zero when `X` increases.
    - **X**: Mayor version number. Can start from zero. Cannot go over 99. Without leading zero. Increased by one when `Y` overflows or when big changes are introduced(on the application code side).
    - **rc**: Stands for release candidate which means test release.
    - **A**: Release candidate number. Starts from one. Cannot go over 99. Without leading zero. Increased by one with every new release candidate.

    `X` = 0 means the software does not contain all features for the first full release - beta phase (not the same as the release candidate).<br>
    **Examples:**<br>
    - `v0.13.18rc8` Release candidate #8 for version 0.13.18<br>
    - `v13.12.0` Stable release, version 13.12.0

### Release naming

Naming rule is: **{fw_name}\_{fw_version}(_{HW})**<br>
This rule applies to naming application executables files(.bin and .hex).<br>
Application name contains project name and application type tag, eg., `3DCLK-FW` is the name of firmware for 3D Clock. `3DCLK-BL` is the name of the bootloader for 3D Clock. The firmware name is max 16 chars long.<br>
The firmware version is copied from the software versioning rule.<br>
`_HW` is inserted in the case when release is for specific hardware, eg., hardware `22-0091rev1`.<br>
**Examples:**<br>
- `3DCLK-FW_v0.13.18rc3` is release name for 3D Clock firmware, version 0.13.18, release candidate 3.<br>
- `3DCLK-FW_v1.0.50rc1_22-0091rev1` is name of executables for hardware version `22-0091rev1`, release `3DCLK-FW_v1.0.50rc1` for 3D Clock, firmware version v1.0.50, release candidate 1.

### File naming

Every file is named with first uppercase letter(Main.cpp, not main.cpp).<br>
Files made for C++ have a .hpp header file, while C files have a .h header file.


# TOOLS

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
- [ARM-GCC v10.3.1 20210824 (GNU Arm Embedded Toolchain 10.3-2021.10)](https://developer.arm.com/downloads/-/gnu-rm)
- [GNU Make v3.81](https://gnuwin32.sourceforge.net/packages/make.htm)
- [Doxygen v1.9.7](https://www.doxygen.nl/download.html)
- [SEGGER J-Link(SWD) v7.88e](https://www.segger.com/downloads/jlink/)
- [STM32CubeMX](https://www.st.com/en/development-tools/stm32cubemx.html)
- [nRF PPK2](https://www.nordicsemi.com/Products/Development-hardware/Power-Profiler-Kit-2)
- [Salea Logic](https://www.saleae.com/downloads/)
- [CMSIS Configuration Wizard v0.0.7](https://sourceforge.net/projects/cmsisconfig/)
- [Draw.io](https://app.diagrams.net/)
- [Fusion 360 (Electronics)](https://www.autodesk.com/products/fusion-360/overview)
- [Saturn PCB Toolkit](https://saturnpcb.com/saturn-pcb-toolkit/)


# CODE STANDARD

### Indents

I prefer to use tabs for indents, size 4.

### C++ over C!

I prefer to use C++ over C, but only parts of C++ that do not induce overhead and bloat(except templates).<br>
Classes, namespaces, and enum classes!

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
	 * @copyright Copyright (c) 2023, silvio3105
	 * 
	 */

	// ----- INCLUDE FILES


	// ----- DEFINES


	// ----- MACRO FUNCTIONS


	// ----- TYPEDEFS


	// ----- ENUMS


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
	 * @copyright Copyright (c) 2023, silvio3105
	 * 
	 */

	#ifndef _SOURCEFILE_H_
	#define _SOURCEFILE_H_

	// ----- INCLUDE FILES


	// ----- DEFINES


	// ----- MACRO FUNCTIONS


	// ----- TYPEDEFS


	// ----- ENUMS


	// ----- STRUCTS


	// ----- CLASSES


	// ----- EXTERNS


	// ----- NAMESPACES


	// ----- FUNCTION DECLARATIONS


	#endif // _SOURCEFILE_H_


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
#define THIS_IS_MACRO               value
#define THIS_IS_SECOND_MACRO            (THIS_IS_MACRO - 5)

/*
    The macro function is written in uppercase, it starts with two underscores, and spaces are replaced with underscores.
    Argument names start with underscore and the first letter is in lowercase.
    The function body is written in a new line.
*/
#define __THIS_IS_MACRO_FUNCTION(_argOne, _argTwo) \
    (_argOne - _argTwo)

/*
    C-style enum type is written in lowercase, spaces are replaced with underscores and the type name ends with "_t".
    Enum values are written like defines.
    Enum definition also contains data size(uint8_t, uint16_t, etc..).
    Every value starts with an abbreviation(eg., "GSM_ERROR") if not placed inside the namespace.
*/
enum enum_type_t : uint8_t
{
    THIS_IS_ENUM1 = 0,
    THIS_IS_ENUM2
};

/*
    Same as C-style enums but:
    Enum value names in the enum class are named with uppercase letters for every word.
    Value names do not start with an abbreviation(eg., "GSM_ERROR").
*/
enum class enum_class_t : uint16_t
{
    EnumOne = 0,
    EnumTwo
};

// Type alias is written using the same rules as enum types. 
typedef uint16_t idx_t;

// Same as typedef above but it ends with "_f".
typedef void (*ext_handler_f)(void);

/*
    Struct type uses rules from typedefs.
    Struct members are named using rules for global variables.
    Each member should have a default value.
    Structs are used only for data storage(no functions).
*/
struct this_is_struct_t
{
    uint8_t someVar = 1;
    uint32_t* somePtr = nullptr;
};

/*
    Classes hold data(as structs) and methods to manipulate the data.
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

    private:
    const char someArray[] = "Array"; /**< @brief This is inline doxygen comment. */

    inline void somePrivateFunction(void);
};

// Classic extern
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
    uint64_t x;

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
	float tmp = 0;
	uint16_t x = 1;
	char str[32] = { '\0' };
	uint32_t* ptr = nullptr;

	// Execute something with value x
	exe(x);

	// Calculate result and convert it
	foo2(ptr, x);
	tmp = 2.00f * (*ptr);

	// Do something with value
	if (tmp > 10.00f) tmp = 10.00f;
		else tmp -= 0.55f;

	// Check does string exist
	if (str[0])
	{
		// Do something with string		
	}
	else return; // String does not exist, abort

	// Rest of the function...

}
```

### Nested if statments?

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
		else print("Not ready\n");
	}
	else print("Not online\n");
}
```

```cpp
void foo(void)
{
	// Check if device is online
	if (!isOnline())
	{
		print("Not online\n");

		// Abort
		return;
	}

	// Check if data is ready
	if (!isReady())
	{
		print("Not ready\n");

		// Abort
		return:	
	}

	// Send data
	bar();
	bar2();
}
```

### Declarations & Definitions

Declarations are placed in header files(.hpp/.h).<br>
Definitions and private (static) stuff are placed in translation units(.cpp/.c).<br>
Inline and template stuff are defined in header files.
