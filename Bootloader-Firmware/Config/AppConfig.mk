
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


######################################
# DEBUG-RELATED CONFIG
######################################

# NAME OF THE HEADER FILE WITH DEBUG DECLARATIONS
DEBUG_SRC=Debug.hpp

# SET TO 1 TO USE STACK FOR FORMATTED PRINTS
DEBUG_STACK_PRINTF = 0

# DEBUG FORMATTED PRINT BUFFER SIZE IN BYTES	
DEBUG_BUFFER_SIZE = 128

# DEBUG PRINT HANDLER
DEBUG_HANDLER_PRINT = Debug::log

# DEBUG PRINTF HANDLER
DEBUG_HANDLER_PRINTF = Debug::logf
