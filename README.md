
# ABOUT

This repo contains template for projects I use. Template includes:
- Makefile for building the projects(multi hardware builds and RTOS are supported)
- Readme file
- License file
- Git ignore file
- Project structures
- Set of coding rules I follow in embedded software development


# PROJECT APPLICATION STRUCTURE

**This part applies only to firmware projects.**

![Project structure diagram](.backend/Project%20structure.png "Project structure diagram")

Diagram shows project structure. It goes from the base up.

### Hardware

The base for every project. It runs the project.

### Drivers

Drivers are the gate for other layers of the application to interact with the hardware. They are written with minimal logic inside. Every driver is wirrten without other driver(s). Only way for the driver to interact with hardware(eg., I2C sensor, SPI flash, GPIO etc.) is through external handler(user provided). Drivers are not written with application logic. They are like little lego, You can use it everywhere. Drivers can interact with libraries.
Every driver is written as C++ class within own namespace.

### Libraries

Library is piece of the software with basic logic that does not require interactions with the hardware. Every layer can use libraries. Libraries are not wirtten with application logic.
Eg., library with string manipulation functions.
Every library is written within own namespace.

### Application modules

Application modules combines drivers and libraries to produce basic logic for the application. Module alone is worthless(one plank is not bench, but many planks combined create the bench).
Every module has its own namespace and can be written as many C++ classes.

### Tasks

Tasks combine application modules and their logic to do something useful. In case of bare metal project there is only one task - endless loop in main().



# PROJECT FOLDER STRUCTURE

- 📂 **{Project_name}**: Root folder.
    - 📂 **.backend**: Folder with files for readme.
	- 📂 **.builds***: Folder with other build folders(used by Make and ARM-GCC).
  	- 📂 **.docs***: Folder with project documentation generated with Doxygen.
  	- 📂 **.doxygen***: Folder with Doxygen project file.
  	- 📂 **.hw***: Folder with hardware related configs for Make.
  	- 📂 **.jlink***: Folder with JLink scripts from flash and erase. 
  	- 📂 **.releases***: Folder with stable releases.
    	- 📂 **RC***: Folder with release candidate releases.
  	- 📂 **.vscode**: Folder with VS Code config files.
  	- 📂 **Inc***: Folder with .h and .hpp header files.
  	- 📂 **RTOS***: Folder with RTOS related files.
    	- 📂 **Inc***: Folder with RTOS related header files.
    	- 📂 **Src***: Folder with RTOS related source files.
  	- 📂 **Src***: Folder with .c and .cpp source files.
  	- .gitignore: Git ignore file.
  	- LICENSE: Project license.
  	- mk*: Main Makefile used for bulding the project.
  	- README.md: Main readme file.

_*: File/folder not needed if project is library/driver. Library/driver files are placed in root folder._


# VERSIONING & NAMING
### Software versioning

- **Library/Driver: vX.Y(rcA)**
  `X` is mayor, `Y` is minor, `rc` stands for `release candidate` which means test/alpha/beta release.
  `X`, `Y` and `A` are the numbers. `X` and `Y` can start from 0 while `A` starts from 1. 
  `X`, `Y` and `Z` must be "8-bit number" while `A` cannot go over 99. If `Y` goes over 255, `X` will increase by one and `Y` will reset to zero.
  Examples:
  `v0.1rc5` Release candidate #5 for version 0.1.
  `v1.13` Stable release, version 1.13.

- **Firmware: vX.Y.Z(rcA)**
  `X` is mayor, `Y` is minor, `Z` is build and `rc` stands for `release candidate` which means test/alpha/beta release.
  `X`, `Y`, `Z` and `A` are the numbers. `X`, `Y` and `Z` can start from 0 while `A` starts from 1.
  Every number is "8-bit" which means it cannot go over 255.
  Examples:
  `v0.13.18rc8` Release candidate #8 for version 0.13.18
  `v13.12.0` Stable release, version 13.12.0

### Build naming

This rule applies to naming build executables files(.bin and .hex).
Naming rule is: **{fw_name}\_{fw_version}(_{HW})**
Firmware name contains project name and firmware type, eg., `3DCLK-FW` is name of firmware for 3D Clock project. `3DCLK-BL` is name of bootloader for 3D Clock project. Firmware name is max 16 chars long.
Firmware version is copied from software versioning rule.
`_HW` is inserted in case when build is for specific hardware, eg., hardware 22-0091rev1.
Examples:
`3DCLK-FW_v0.13.18rc3` is name of .bin/.hex file for 3D Clock firmware, version 0.13.18, release candidate 3.
`3DCLK-FW_v1.0.5rc1_22-0091rev1` is name of .bin/.hex file for 3D Clock firmware for hardware version 22-0091rev1, firmware version v1.0.5, release candidate 1.

### File naming

Every file is named with first uppercase letter(Main.cpp, not main.cpp).
Files made for C++ have .hpp header file, while C files have .h header file.


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
- [Doxygen](https://www.doxygen.nl/download.html)
- [SEGGER J-Link(SWD)](https://www.segger.com/downloads/jlink/)
- [STM32CubeMX](https://www.st.com/en/development-tools/stm32cubemx.html)
- [nRF PPK2](https://www.nordicsemi.com/Products/Development-hardware/Power-Profiler-Kit-2)
- [Salea Logic](https://www.saleae.com/downloads/)
- [CMSIS Configuration Wizard](https://sourceforge.net/projects/cmsisconfig/)
- [Draw.io](https://app.diagrams.net/)
- [Fusion 360 (Electronics)](https://www.autodesk.com/products/fusion-360/overview)
- [Saturn PCB Toolkit](https://saturnpcb.com/saturn-pcb-toolkit/)


# CODE STANDARD

### C++ over C!

I prefer to use C++ over C, but only parts of C++ that do not induce overhead(except templates).
Classes, namespaces and enum classes FTW!


# LICENSE

Copyright (c) 2023, silvio3105 (www.github.com/silvio3105)

Access and use of this Project and its contents are granted free of charge to any Person.
The Person is allowed to copy, modify and use The Project and its contents only for non-commercial use.
Commercial use of this Project and its contents is prohibited.
Modifying this License and/or sublicensing is prohibited.

THE PROJECT AND ITS CONTENT ARE PROVIDED "AS IS" WITH ALL FAULTS AND WITHOUT EXPRESSED OR IMPLIED WARRANTY.
THE AUTHOR KEEPS ALL RIGHTS TO CHANGE OR REMOVE THE CONTENTS OF THIS PROJECT WITHOUT PREVIOUS NOTICE.
THE AUTHOR IS NOT RESPONSIBLE FOR DAMAGE OF ANY KIND OR LIABILITY CAUSED BY USING THE CONTENTS OF THIS PROJECT.

This License shall be included in all functional textual files.

---

Copyright (c) 2023, silvio3105