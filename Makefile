#---------------------------------------------------------------------------------
.SUFFIXES:
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment")
endif

include $(DEVKITARM)/ds_rules

#---------------------------------------------------------------------------------
# Project
#---------------------------------------------------------------------------------

TARGET   := ginseng_strip_gta
BUILD    := build
SOURCES  := source
INCLUDES := include

#---------------------------------------------------------------------------------
# Compiler options
#---------------------------------------------------------------------------------

ARCH := -march=armv5te -mtune=arm946e-s

CFLAGS   := -g -Wall -O2 -ffunction-sections -fdata-sections $(ARCH)
CFLAGS  += $(INCLUDE) -DARM9

CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions

ASFLAGS  := -g $(ARCH)

LDFLAGS = -specs=ds_arm9.specs -g -Wl,-Map,$(notdir $*.map)

LIBS     := -lnds9
LIBDIRS  := $(LIBNDS) $(PORTLIBS)

#---------------------------------------------------------------------------------
# Build setup
#---------------------------------------------------------------------------------

ifneq ($(BUILD),$(notdir $(CURDIR)))

export OUTPUT := $(CURDIR)/$(TARGET)

export VPATH := \
	$(foreach dir,$(SOURCES),$(CURDIR)/$(dir))

export DEPSDIR := $(CURDIR)/$(BUILD)

CFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))

ifeq ($(strip $(CPPFILES)),)
export LD := $(CC)
else
export LD := $(CXX)
endif

export OFILES_SOURCES := \
	$(CFILES:.c=.o) \
	$(CPPFILES:.cpp=.o) \
	$(SFILES:.s=.o)

export OFILES := $(OFILES_SOURCES)

export INCLUDE := \
	$(foreach dir,$(INCLUDES),-iquote $(CURDIR)/$(dir)) \
	$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
	-I$(CURDIR)/$(BUILD)

export LIBPATHS := \
	$(foreach dir,$(LIBDIRS),-L$(dir)/lib)

#---------------------------------------------------------------------------------
# Targets
#---------------------------------------------------------------------------------

.PHONY: all clean

all: $(BUILD)

$(BUILD):
	@mkdir -p $@
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

clean:
	@echo "Cleaning..."
	@rm -rf $(BUILD)
	@rm -f $(TARGET).nds
	@rm -f $(TARGET).elf
	@rm -f $(TARGET).map

#---------------------------------------------------------------------------------
else
#---------------------------------------------------------------------------------

#---------------------------------------------------------------------------------
# Build the NDS
#---------------------------------------------------------------------------------

$(OUTPUT).nds: $(OUTPUT).elf

$(OUTPUT).elf: $(OFILES)

#---------------------------------------------------------------------------------
# Dependencies
#---------------------------------------------------------------------------------

-include $(DEPSDIR)/*.d

#---------------------------------------------------------------------------------
endif
#---------------------------------------------------------------------------------
