
# THIS FILE IS MAIN MAKEFILE THAT IS USED FOR BUILDING THE PROJECT
# PER HARDWARE STUFF IS IN MakeHW FOLDER


######################################
# BUILD CONFIG
######################################

# MAKEFILE FILE NAME
MAKEFILE = mk

# SET TO 1 IF RTOS IS USED(NON BARE METAL BUILD)
RTOS = 0

# SELECT THE HW VERSION
HW_VER = mk_22-0091rev1

# INCLUDE HW STUFF
ifeq ($(HW_VER), mk_22-0091rev1)
include .hw/mk_22-0091rev1
endif

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

# OUTPUT LOCATION
BUILD_DIR = .build

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
FLASH_SCRIPT = JLink_Flash_$(TARGET).jlink
ERASE_SCRIPT = JLink_Erase_$(TARGET).jlink

# PREFIX
TC_PREFIX = arm-none-eabi-
SRC_PREFIX = Core/Src
ifeq ($(RTOS), 1)
RTOS_PREFIX = RTOS
RTOS_SRC_PREFIX = $(RTOS_PREFIX)/Src
RTOS_INC_PREFIX = $(RTOS_PREFIX)/Inc
endif




######################################
# TRANSLATION UNITS
######################################

# C UNITS
C_SOURCES = \
$(HW_C_SOURCES) \
$(SRC_PREFIX)/main.c \


# C++ UNITS
CPP_SOURCES =  \
$(HW_CPP_SOURCES) \


# ASSEMBLER UNITS
ASM_SOURCES =  \
$(STARTUP) \


######################################
# INCLUDE DIRECTORIES
######################################

# ASSEMBLER INCLUDE DIRECTORIES
AS_INCLUDES =  \


# C/C++ INCLUDE DIRECTORIES
C_INCLUDES =  \
$(HW_INCLUDES) \
-ICore/Inc \


######################################
# DEFINES
######################################

# ASSEMBLER DEFINES
AS_DEFS =  \
$(HW_AS_DEFS) \


# C/C++ DEFINES
C_DEFS =  \
$(HW_DEFS) \


######################################
# RTOS UNITS
######################################
ifeq ($(RTOS), 1)
C_SOURCES += \
$(RTOS_SRC_PREFIX)/os_systick.c \
$(RTOS_SRC_PREFIX)/RTX_Config.c \
$(RTOS_SRC_PREFIX)/rtx_delay.c \
$(RTOS_SRC_PREFIX)/rtx_evflags.c \
$(RTOS_SRC_PREFIX)/rtx_evr.c \
$(RTOS_SRC_PREFIX)/rtx_kernel.c \
$(RTOS_SRC_PREFIX)/rtx_memory.c \
$(RTOS_SRC_PREFIX)/rtx_mempool.c \
$(RTOS_SRC_PREFIX)/rtx_msgqueue.c \
$(RTOS_SRC_PREFIX)/rtx_mutex.c \
$(RTOS_SRC_PREFIX)/rtx_semaphore.c \
$(RTOS_SRC_PREFIX)/rtx_system.c \
$(RTOS_SRC_PREFIX)/rtx_thread.c \
$(RTOS_SRC_PREFIX)/rtx_timer.c \
$(RTOS_SRC_PREFIX)/rtx_lib.c \

ASM_SOURCES += \
$(RTOS_PREFIX)/irq_armv7m.S \

C_INCLUDES += \
$(RTOS_INC_PREFIX) \

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
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref,--gc-sections,--print-memory-usage


#######################################
# BUILD
#######################################
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

# LIST OF C OBJECTS
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))

# LIST OF C++ OBJECTS
OBJECTS_CPP = $(addprefix $(BUILD_DIR)/,$(notdir $(CPP_SOURCES:.cpp=.o)))
vpath %.cpp $(sort $(dir $(CPP_SOURCES)))

# LIST OF ASM OBJECTS
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c $(MAKEFILE) | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.cpp $(MAKEFILE) | $(BUILD_DIR) 
	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.cpp=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s $(MAKEFILE) | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) $(OBJECTS_CPP) Makefile
	$(CC) $(OBJECTS) $(OBJECTS_CPP) $(LDFLAGS) -o $@

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@

ifeq ($(PRINT_VER), 1)
	$(CC) --version
endif	
	
$(BUILD_DIR):
	mkdir $@


#######################################
# FLASH CHIP
#######################################
flash: all
	if not exist $(FLASH_SCRIPT) (echo Creating flash script & (echo r& echo h& echo loadbin $(BUILD_DIR)/$(TARGET).bin,$(ADDR)& echo verifybin $(BUILD_DIR)/$(TARGET).bin,$(ADDR)& echo r& echo q) > $(FLASH_SCRIPT)) else (echo Flash script exists) 
	JLink.exe -device $(CHIP) -if SWD -speed 4000 -autoconnect 1 -CommandFile $(FLASH_SCRIPT)
	
#######################################
# ERASE CHIP FLASH MEMORY
#######################################		
erase:
	if not exist $(ERASE_SCRIPT) (echo Creating erase script & (echo r& echo h& echo erase& echo r& echo q) > $(ERASE_SCRIPT)) else (echo Erase script exists)
	JLink.exe -device $(CHIP) -if SWD -speed 4000 -autoconnect 1 -CommandFile $(ERASE_SCRIPT)
	

#######################################
# REMOVE BUILD FOLDER & OTHER STUFF
#######################################
clean:
	if exist $(BUILD_DIR) (echo Deleting build directory & rmdir /s /q $(BUILD_DIR))
	if exist $(FLASH_SCRIPT) (echo Deleting flash script & del $(FLASH_SCRIPT))
	if exist $(ERASE_SCRIPT) (echo Deleting erase script & del $(ERASE_SCRIPT))



-include $(wildcard $(BUILD_DIR)/*.d)
