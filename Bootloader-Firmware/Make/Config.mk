
######################################
# MISC CONFIG
######################################

# SET TO 1 TO PRINT COMPILER VERSION AFTER BUILD
TC_PRINT_VER = 1

# TOOLCHAIN PREFIX
TC_PREFIX = arm-none-eabi-

ifeq ($(GPP), 1)
CC = $(TC_PREFIX)g++
AS = $(TC_PREFIX)g++
else
CC = $(TC_PREFIX)gcc
AS = $(TC_PREFIX)gcc -x assembler-with-cpp
endif

CP = $(TC_PREFIX)objcopy
SZ = $(TC_PREFIX)size
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

# J-LINK SWD SPEED
JLINK_SPEED = 4000


######################################
# DIRECTORIES AND FILES
######################################

# DIRECTORY FOR CURRENT BUILD
BUILD = .builds\$(BUILD_NAME)

# DIRECTORY FOR HARDWARE BUILD
HARDWARE = Hardware/$(HW_NAME)

# DIRECTORY WITH LINKER SCRIPT
LINKER = $(HARDWARE)/Linker

# DIRECTORY WITH STARTUP FILE
STARTUP = $(HARDWARE)/Startup

# OUTPUT FILE
OUTPUT = .outputs\$(BUILD_NAME)

# J-LINK SCRIPT FILE LOCATIONS
JLINK_FLASH = .jlink\JLink_Flash_$(HW_NAME).jlink
JLINK_ERASE = .jlink\JLink_Erase_$(HW_NAME).jlink
JLINK_ERASE_ALL = .jlink\JLink_EraseAll_$(HW_NAME).jlink
JLINK_RESET = .jlink\JLink_Reset_$(HW_NAME).jlink

# CMSIS CONFIGURATION WIZARD LOCATION
CMSIS_WIZARD = CMSIS/CMSIS_Configuration_Wizard.jar