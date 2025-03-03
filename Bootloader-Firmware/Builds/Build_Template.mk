# BUILD NAME
BUILD_NAME = Build_Template

# NAME OF MAKE FOR HARDWARE BUILD
HW_NAME = HW_Template


######################################
# DEBUG CONFIG
######################################

# SET TO 1 TO ENABLE DEBUG BUILD
DEBUG = 1

# ENABLE DEBUG FOR
DEBUG_ENABLE = \

# DEBUG LEVEL
DEBUG_LEVEL = \
-DDEBUG_VERBOSE \
-DDEBUG_INFO \
-DDEBUG_ERROR \


######################################
# BUILD CONFIG
######################################

# SET TO 1 TO OPTIMIZE BUILD FOR SIZE
SIZE = 0

# SET TO 1 TO ENABLE LINK TIME OPTIMIZATION (LAST LINE OF DEFENCE IN CASE OF ROM SHORTAGE)
FLTO = 0

# SET TO 1 TO USE -g3 FLAG IN DEBUG BUILD
USE_G3 = 0

# SET TO 1 TO USE G++ INSTEAD OF GCC COMPILER
GPP = 0

# SET TO 1 TO GENERATE STACK ANALYSIS FILE FOR EACH TRANSLATION UNIT
STACK_ANALYSIS = 0

# SET TO 0 TO DISABLE WARNING IF STACKOVERFLOW MIGHT HAPPEND OR SET TO X BYTES FOR MAXIMUM STACK SIZE
STACK_OVERFLOW = 0

# SET TO 1 TO GENERATE RUNTIME TYPE IDENTIFICATION INFORMATION
RTTI = 0

# SET TO 1 TO CATCH EXCEPTIONS
EXCEPTIONS = 0

# SET TO 1 TO USE DEFAULT LIB
DEF_LIB = 0


######################################
# J-LINK-RELATED CONFIG
######################################

# J-LINK RTT UP BUFFER SIZE (32-bit aligned, 0 to use default)
JLINK_RTT_UP = 512

# J-LINK RTT UP BUFFER SIZE (32-bit aligned, 0 to use default)
JLINK_RTT_DOWN = 0


######################################
# CONFIGURE APPLICATION OR HARDWARE MAKE
######################################


######################################
# MAKE CONFIG
######################################

include Make/Config.mk


######################################
# APPLICATION MAKE
######################################

include Config/AppConfig.mk


######################################
# HARDWARE MAKE
######################################

include $(HARDWARE)/$(HW_NAME).mk


######################################
# RECONFIGURE APPLICATION OR HARDWARE MAKE
######################################



######################################
# BUILD FILES, INCLUDES OR DEFINES
######################################

# C++ TRANSLATION FILES
CPP_FILES = \

# C TRANSLATION FILES
C_FILES = \

# ASSEMBLER TRANSLATION FILES
ASM_FILES = \

# INCLUDE DIRECTORIES
INCLUDE_PATHS = \

# DEFINES
DEFINES = \


############################################################################
# DO NOT ALTER STUFF BELOW
############################################################################

#######################################
# BACKEND MAKE FILE
#######################################

include Make/Backend.mk



-include $(wildcard $(BUILD_FOLDER)/*.d)
