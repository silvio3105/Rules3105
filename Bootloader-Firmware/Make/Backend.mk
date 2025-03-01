
# MAKE FILE LOCATION
MAKEFILE = Builds/$(BUILD_NAME).mk


######################################
# FILE LIST
######################################

# C++ TRANSLATION FILES
CPP_FILES += \
$(HW_CPP_FILES) \
$(APP_CPP_FILES)

# C TRANSLATION FILES
C_FILES += \
$(HW_C_FILES) \
$(APP_C_FILES)

# ASSEMBLER TRANSLATION FILES
ASM_FILES += \
$(HW_ASM_FILES) \
$(APP_ASM_FILES)


######################################
# INCLUDE PATHS
######################################

# INCLUDE DIRECTORIES
INCLUDE_PATHS += \
$(HW_INCLUDE_PATHS) \
$(APP_INCLUDE_PATHS) \
-I$(HARDWARE)


######################################
# DEFINES
######################################

# DEFINES
DEFINES += \
-DHW_CONFIG=\"$(HW_NAME).hpp\" \
-DHW_$(HW_NAME) \
-D$(MCU_DEFINE) \
$(HW_DEFINES) \
$(APP_DEFINES)

# J-LINK RTT DEFINES
ifneq ($(JLINK_RTT_UP), 0)
DEFINES += -DBUFFER_SIZE_UP=$(JLINK_RTT_UP)
endif

ifneq ($(JLINK_RTT_DOWN), 0)
DEFINES += -DBUFFER_SIZE_DOWN=$(JLINK_RTT_DOWN)
endif

# RTOS DEFINE
ifeq ($(APP_RTOS), 1)
DEFINES += -DRTOS
endif


#######################################
# DEBUG
#######################################

# DEBUG BUILD
ifeq ($(DEBUG), 1)

# DEBUG DEFINE
DEFINES += -DDEBUG

# COMPILER FLAGS
OPTIMIZATION = -Og
COMPILER_FLAGS += -ggdb

ifeq ($(USE_G3), 1)
COMPILER_FLAGS += -g3
else
COMPILER_FLAGS += -g
endif

else

# SIZE OPTIMIZATION
ifeq ($(SIZE), 1)
OPTIMIZATION = -Os
else
OPTIMIZATION = -Ofast
endif
ifeq ($(FLTO), 1)
COMPILER_FLAGS += -flto
endif

endif


#######################################
# COMPILER-ASSEMBLER-LINKER FLAGS
#######################################

CAL_FLAGS = -mcpu=$(MCU_CORE) -mthumb -mfloat-abi=$(MCU_FLOAT)

ifeq ($(MCU_BIG_ENDIAN), 1)
CAL_FLAGS += -mbig-endian
endif


#######################################
# COMPILER FLAGS
#######################################

COMPILER_FLAGS += $(CAL_FLAGS) $(DEFINES) $(INCLUDE_PATHS) $(OPTIMIZATION) -MMD -MP -MF"$(@:%.o=%.d)" -Wall -Wdouble-promotion -Wshadow -Wformat=2 -Wformat-overflow -Wformat-truncation -fdata-sections -ffunction-sections

ifeq ($(GPP), 1)
ifeq ($(RTTI), 0)
COMPILER_FLAGS += -fno-rtti
endif
endif

ifeq ($(EXCEPTIONS), 0)
COMPILER_FLAGS += -fno-exceptions
endif

ifeq ($(DEF_LIB), 0)
COMPILER_FLAGS += -nodefaultlibs
endif

ifeq ($(STACK_ANALYSIS), 1)
COMPILER_FLAGS += -fstack-usage
endif

ifneq ($(STACK_OVERFLOW), 0)
COMPILER_FLAGS += -Wstack-usage=$(STACK_OVERFLOW)
endif


#######################################
# LINKER FLAGS
#######################################

LINKER_FLAGS = $(CAL_FLAGS) -specs=nano.specs -T$(LINKER)/$(MCU_LINKER) -L$(LINKER) -lc -lm -lnosys -Wl,-Map=$(BUILD)/$(BUILD_NAME).map,--cref,--gc-sections,--print-memory-usage,--fuse-ld=gold


#######################################
# BUILD
#######################################

all: $(BUILD)/$(BUILD_NAME).elf $(BUILD)/$(BUILD_NAME).hex $(BUILD)/$(BUILD_NAME).bin

# LIST OF C OBJECTS
OBJECTS = $(addprefix $(BUILD)/,$(notdir $(C_FILES:.c=.o)))
vpath %.c $(sort $(dir $(C_FILES)))

# LIST OF C++ OBJECTS
OBJECTS += $(addprefix $(BUILD)/,$(notdir $(CPP_FILES:.cpp=.o)))
vpath %.cpp $(sort $(dir $(CPP_FILES)))

# LIST OF ASM OBJECTS
OBJECTS += $(addprefix $(BUILD)/,$(notdir $(ASM_FILES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_FILES)))

$(BUILD)/%.o: %.c $(MAKEFILE) | $(BUILD) 
	$(CC) -c $(COMPILER_FLAGS) -Wa,-a,-ad,-alms=$(BUILD)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD)/%.o: %.cpp $(MAKEFILE) | $(BUILD) 
	$(CC) -c $(COMPILER_FLAGS) -Wa,-a,-ad,-alms=$(BUILD)/$(notdir $(<:.cpp=.lst)) $< -o $@

$(BUILD)/%.o: %.s $(MAKEFILE) | $(BUILD)
	$(AS) -c $(COMPILER_FLAGS) $< -o $@

$(BUILD)/$(BUILD_NAME).elf: $(OBJECTS) $(MAKEFILE)
	$(CC) $(OBJECTS) $(LINKER_FLAGS) -o $@
	copy /-y /y $(BUILD)\$(BUILD_NAME).map $(OUTPUT).map

$(BUILD)/%.hex: $(BUILD)/%.elf | $(BUILD)
	$(HEX) $< $@
	copy /-y /y $(BUILD)\$(BUILD_NAME).hex $(OUTPUT).hex
	
$(BUILD)/%.bin: $(BUILD)/%.elf | $(BUILD)
	$(BIN) $< $@
	copy /-y /y $(BUILD)\$(BUILD_NAME).bin $(OUTPUT).bin

ifeq ($(TC_PRINT_VER), 1)
	$(CC) --version
endif
	
$(BUILD):
	mkdir $@


#######################################
# FLASH CHIP
#######################################

flash: all
	if not exist $(JLINK_FLASH) ((echo r & echo h & echo loadbin $(BUILD)/$(BUILD_NAME).bin,$(JLINK_ADDR_START) & echo verifybin $(BUILD)/$(BUILD_NAME).bin,$(JLINK_ADDR_START) & echo r & echo q) > $(JLINK_FLASH))
	JLink.exe -device $(JLINK_DEVICE) -if SWD -speed $(JLINK_SPEED) -autoconnect 1 -CommandFile $(JLINK_FLASH)
	

#######################################
# ERASE APPLICATION FROM MEMORY
#######################################		

erase:
	if not exist $(JLINK_ERASE) ((echo r & echo h & echo erase $(JLINK_ADDR_START) $(JLINK_ADDR_END) & echo r & echo q) > $(JLINK_ERASE))
	JLink.exe -device $(JLINK_DEVICE) -if SWD -speed $(JLINK_SPEED) -autoconnect 1 -CommandFile $(JLINK_ERASE)


#######################################
# ERASE MCU MEMORY
#######################################		

erase_all:
	if not exist $(JLINK_ERASE_ALL) ((echo r & echo h & echo erase & echo r & echo q) > $(JLINK_ERASE_ALL))
	JLink.exe -device $(JLINK_DEVICE) -if SWD -speed $(JLINK_SPEED) -autoconnect 1 -CommandFile $(JLINK_ERASE_ALL)


#######################################
# RESET MCU
#######################################		

reset:
	if not exist $(JLINK_RESET) ((echo r & echo q) > $(JLINK_RESET))
	JLink.exe -device $(JLINK_DEVICE) -if SWD -speed $(JLINK_SPEED) -autoconnect 1 -CommandFile $(JLINK_RESET)
	

#######################################
# REMOVE BUILD FOLDER & OTHER STUFF
#######################################

clean: clean_jlink
	if exist $(BUILD) (echo Deleting build directory & rmdir /s /q $(BUILD))
	if exist $(OUTPUT).bin (echo Deleting bin executable & del $(OUTPUT).bin)
	if exist $(OUTPUT).hex (echo Deleting hex executable & del $(OUTPUT).hex)
	if exist $(OUTPUT).map (echo Deleting build map file & del $(OUTPUT).map)

clean_jlink:
	if exist $(JLINK_FLASH) (echo Deleting flash script & del $(JLINK_FLASH))
	if exist $(JLINK_ERASE) (echo Deleting erase script & del $(JLINK_ERASE))
	if exist $(JLINK_ERASE_ALL) (echo Deleting erase ALL script & del $(JLINK_ERASE_ALL))
	if exist $(JLINK_RESET) (echo Deleting reset script & del $(JLINK_RESET))	


#######################################
# OPEN RTOS CONFIG FILE IN CMSIS CONFIG WIZARD
#######################################

rtos_cfg:
	java -jar $(CMSIS_WIZARD) $(RTOS_CFG)