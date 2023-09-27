
# THIS FILE IS MAIN MAKEFILE THAT IS USED FOR BUILDING THE PROJECT

######################################
# BUILD CONFIG
######################################

# MAKEFILE FILE NAME
MAKEFILE = mk

# SET TO 1 IF RTOS IS USED(NON BARE METAL BUILD)
RTOS = 0

# SELECT THE HW VERSION
HW_VER = mk_22-0091rev1

# INCLUDE HW CONFIG
include .hw/$(HW_VER)

# RELEASE BUILD
RELEASE = 0

# OPT FLAG FOR SIZE
SIZE = 0

# LAST LINE OF DEFENCE IN CASE OF ROM SHORTAGE
FLTO = 0

# USE -g3 FLAG IN NON RELEASE BUILD
USE_G3 = 0

# USE G++ INSTEAD OF GCC
GPP = 0

# BUILD FOLDER
BUILD_FOLDER = .builds/$(BUILD_NAME)

# PRINT GCC VERSION AFTER BUILD
PRINT_VER = 0

# GENERATE STACK ANALYSIS FILE FOR EACH TRANSLATION UNIT
STACK_ANALYSIS = 0

# WARN IF STACKOVERFLOW MIGHT HAPPEND. SET TO 0 TO DISABLE WARNING
STACK_OVERFLOW = 256

# GENERATE RUNTIME TYPE IDENTIFICATION INFORMATION
RTTI = 0

# CATCH EXCEPTIONS
EXCEPTIONS = 0

# USE DEFAULT LIB
DEF_LIB = 0

# JLINK SCRIPT NAMES
FLASH_SCRIPT = JLink_Flash_$(BUILD_NAME).jlink
ERASE_SCRIPT = JLink_Erase_$(BUILD_NAME).jlink

# TOOLCHAIN PREFIX
TC_PREFIX = arm-none-eabi-

# FOLDER WITH JLINK SCRIPTS
JLINK_FOLDER = .jlink


######################################
# TRANSLATION UNITS
######################################

# C UNITS
C_SOURCES = \
$(HW_C_SOURCES) \


# C++ UNITS
CPP_SOURCES =  \
$(HW_CPP_SOURCES) \
Main.cpp \


# ASSEMBLER UNITS
ASM_SOURCES =  \
$(HW_AS_SOURCES) \


######################################
# INCLUDE DIRECTORIES
######################################

# C/C++ INCLUDE DIRECTORIES
C_INCLUDES =  \
$(HW_INCLUDES) \
-I./ \
-IDrivers/Inc \
-ILibraries/Inc \
-IModules/Inc \


# ASSEMBLER INCLUDE DIRECTORIES
AS_INCLUDES =  \
$(HW_AS_INCLUDES) \


######################################
# DEFINES
######################################

# C/C++ DEFINES
C_DEFS =  \
$(HW_DEFS) \


# ASSEMBLER DEFINES
AS_DEFS =  \
$(HW_AS_DEFS) \


######################################
# RTOS UNITS
######################################
ifeq ($(RTOS), 1)
C_SOURCES += \
RTOS/Src/os_systick.c \
RTOS/Src/RTX_Config.c \
RTOS/Src/rtx_delay.c \
RTOS/Src/rtx_evflags.c \
RTOS/Src/rtx_evr.c \
RTOS/Src/rtx_kernel.c \
RTOS/Src/rtx_memory.c \
RTOS/Src/rtx_mempool.c \
RTOS/Src/rtx_msgqueue.c \
RTOS/Src/rtx_mutex.c \
RTOS/Src/rtx_semaphore.c \
RTOS/Src/rtx_system.c \
RTOS/Src/rtx_thread.c \
RTOS/Src/rtx_timer.c \
RTOS/Src/rtx_lib.c \


C_INCLUDES += \
-IRTOS/Inc \
-ITasks/Inc \


ASM_SOURCES += \


endif


#######################################
# OPTIMIZATION
#######################################
ifeq ($(RELEASE), 0)
C_DEFS += -DDEBUG
OPT += -Og
else ifeq ($(SIZE), 1)
OPT += -Os
else
OPT += -Ofast
endif

ifeq ($(RELEASE), 0)
ifeq ($(USE_G3), 1)
CFLAGS += -g3
else
CFLAGS += -g
endif
CFLAGS += -gdwarf-2
else ifeq ($(FLTO), 1)
CFLAGS += -flto
ASFLAGS += -flto
endif


#######################################
# TOOLCHAIN
#######################################
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
 

#######################################
# C/C++ COMPILER FLAGS
#######################################
SHARED_FLAGS = -mcpu=$(CPU_CORE) -mthumb $(FPU) $(FLOAT-ABI)
ASFLAGS += $(SHARED_FLAGS) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -Wdouble-promotion -Wshadow -Wformat=2 -Wformat-overflow -Wformat-truncation -fdata-sections -ffunction-sections
CFLAGS += $(SHARED_FLAGS) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -Wdouble-promotion -Wshadow -Wformat=2 -Wformat-overflow -Wformat-truncation -fdata-sections -ffunction-sections 

ifeq ($(GPP), 1)
ifeq ($(RTTI), 0)
ASFLAGS += -fno-rtti
CFLAGS += -fno-rtti
endif
endif

ifeq ($(EXCEPTIONS), 0)
ASFLAGS += -fno-exceptions
CFLAGS += -fno-exceptions
endif

ifeq ($(DEF_LIB), 0)
ASFLAGS += -nodefaultlibs
CFLAGS += -nodefaultlibs
endif

ifeq ($(STACK_ANALYSIS), 1)
ASFLAGS += -fstack-usage
CFLAGS += -fstack-usage
endif

ifneq ($(STACK_OVERFLOW), 0)
ASFLAGS += -Wstack-usage=$(STACK_OVERFLOW)
CFLAGS += -Wstack-usage=$(STACK_OVERFLOW)
endif

CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"


#######################################
# LINKER FLAGS
#######################################
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_FOLDER)/$(BUILD_NAME).map,--cref,--gc-sections,--print-memory-usage


#######################################
# BUILD
#######################################
all: $(BUILD_FOLDER)/$(BUILD_NAME).elf $(BUILD_FOLDER)/$(BUILD_NAME).hex $(BUILD_FOLDER)/$(BUILD_NAME).bin

# LIST OF C OBJECTS
OBJECTS = $(addprefix $(BUILD_FOLDER)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

# LIST OF C++ OBJECTS
OBJECTS_CPP = $(addprefix $(BUILD_FOLDER)/,$(notdir $(CPP_SOURCES:.cpp=.o)))
vpath %.cpp $(sort $(dir $(CPP_SOURCES)))

# LIST OF ASM OBJECTS
OBJECTS += $(addprefix $(BUILD_FOLDER)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_FOLDER)/%.o: %.c $(MAKEFILE) | $(BUILD_FOLDER) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_FOLDER)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_FOLDER)/%.o: %.cpp $(MAKEFILE) | $(BUILD_FOLDER) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_FOLDER)/$(notdir $(<:.cpp=.lst)) $< -o $@

$(BUILD_FOLDER)/%.o: %.s $(MAKEFILE) | $(BUILD_FOLDER)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_FOLDER)/$(BUILD_NAME).elf: $(OBJECTS) $(OBJECTS_CPP) Makefile
	$(CC) $(OBJECTS) $(OBJECTS_CPP) $(LDFLAGS) -o $@

$(BUILD_FOLDER)/%.hex: $(BUILD_FOLDER)/%.elf | $(BUILD_FOLDER)
	$(HEX) $< $@
	
$(BUILD_FOLDER)/%.bin: $(BUILD_FOLDER)/%.elf | $(BUILD_FOLDER)
	$(BIN) $< $@

ifeq ($(PRINT_VER), 1)
	$(CC) --version
endif	
	
$(BUILD_FOLDER):
	mkdir $@


#######################################
# FLASH CHIP
#######################################
flash: all
	if not exist $(JLINK_FOLDER)/$(FLASH_SCRIPT) (echo Creating flash script & (echo r& echo h& echo loadbin $(BUILD_FOLDER)/$(BUILD_NAME).bin,$(ADDR)& echo verifybin $(BUILD_FOLDER)/$(BUILD_NAME).bin,$(ADDR)& echo r& echo q) > $(JLINK_FOLDER)/$(FLASH_SCRIPT)) else (echo Flash script exists) 
	JLink.exe -device $(CHIP) -if SWD -speed 4000 -autoconnect 1 -CommandFile $(JLINK_FOLDER)/$(FLASH_SCRIPT)
	
#######################################
# ERASE CHIP FLASH MEMORY
#######################################		
erase:
	if not exist $(JLINK_FOLDER)/$(ERASE_SCRIPT) (echo Creating erase script & (echo r& echo h& echo erase& echo r& echo q) > $(JLINK_FOLDER)/$(ERASE_SCRIPT)) else (echo Erase script exists)
	JLink.exe -device $(CHIP) -if SWD -speed 4000 -autoconnect 1 -CommandFile $(JLINK_FOLDER)/$(ERASE_SCRIPT)
	

#######################################
# REMOVE BUILD FOLDER & OTHER STUFF
#######################################
clean:
	if exist $(BUILD_FOLDER) (echo Deleting build directory & rmdir /s /q $(BUILD_FOLDER))
	if exist $(JLINK_FOLDER)/$(FLASH_SCRIPT) (echo Deleting flash script & del $(JLINK_FOLDER)/$(FLASH_SCRIPT))
	if exist $(JLINK_FOLDER)/$(ERASE_SCRIPT) (echo Deleting erase script & del $(JLINK_FOLDER)/$(ERASE_SCRIPT))



-include $(wildcard $(BUILD_FOLDER)/*.d)
