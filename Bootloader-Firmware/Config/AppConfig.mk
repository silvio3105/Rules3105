
######################################
# APPLICATION-RELATED FILE LIST
######################################

# APPLICATION C++ TRANSLATION FILES
APP_CPP_FILES = \
Application/Main.cpp \
Modules/Debug.cpp 

# APPLICATION C TRANSLATION FILES
APP_C_FILES = \
Libraries/SEGGER_RTT.c \

# APPLICATION ASSEMBLER TRANSLATION FILES
APP_ASM_FILES = \


######################################
# APPLICATION-RELATED INCLUDE PATHS
######################################

# APPLICATION INCLUDE DIRECTORIES
APP_INCLUDE_PATHS = \
-IApplication/Inc \
-ICMSIS \
-IConfig \
-IDrivers/Inc \
-ILibraries/Inc \
-IModules/Inc


######################################
# APPLICATION-RELATED DEFINES
######################################

# HW/MCU DEFINES
APP_DEFINES = \


######################################
# APPLICATION-RELATED CONFIG
######################################

# STACK SIZE IN BYTES
APP_STACK = 1024

# HEAP SIZE IN BYTES
APP_HEAP = 0

# SET TO 1 TO BUILD WITH RTOS
APP_RTOS = 1

APP_DEFINES += -DDEBUG_SRC=\"$(DEBUG_SRC)\" -DDEBUG_PRINT=$(DEBUG_PRINT)
APP_DEFINES += $(DEBUG_ENABLE)
APP_DEFINES += $(DEBUG_LEVEL)
APP_DEFINES += $(DEBUG_HANDLER)
APP_DEFINES += -DDEBUG_PRINTF=$(DEBUG_PRINT)f
