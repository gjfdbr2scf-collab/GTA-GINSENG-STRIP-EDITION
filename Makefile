#---------------------------------------------------------------------------------
# Nintendo DS / devkitPro Makefile
#---------------------------------------------------------------------------------

ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. Use the official devkitPro/devkitARM environment.")
endif

include $(DEVKITARM)/ds_rules

TARGET := ginseng_strip_gta
BUILD := build
SOURCES := source
INCLUDES := include

# ARM9/libnds application
ARCH := -march=armv5te -mtune=arm946e-s
CFLAGS := -g -Wall -O2 -ffunction-sections -fdata-sections $(ARCH) $(INCLUDE) -DARM9
CXXFLAGS := $(CFLAGS) -fno-rtti -fno-exceptions
ASFLAGS := -g $(ARCH)
LDFLAGS := -specs=ds_arm9.specs -g $(ARCH) -Wl,-Map,$(notdir $*.map)
LIBS := -lnds9

DATA :=
GRAPHICS :=
AUDIO :=
ICON :=
NITRO :=

ifeq ($(BUILD),$(notdir $(CURDIR)))

else

export OUTPUT := $(CURDIR)/$(TARGET)
export VPATH := $(foreach dir,$(SOURCES),$(CURDIR)/$(dir))
export DEPSDIR := $(CURDIR)/$(BUILD)

CFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
SFILES := $(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))

LIBDIRS := $(LIBNDS) $(PORTLIBS)
export INCLUDE := $(foreach dir,$(INCLUDES),-iquote $(CURDIR)/$(dir)) \
                  $(foreach dir,$(LIBDIRS),-I$(dir)/include) \
                  -I$(CURDIR)/$(BUILD)
export LIBPATHS := $(foreach dir,$(LIBDIRS),-L$(dir)/lib)

export OFILES_SOURCES := $(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(SFILES:.s=.o)
export OFILES := $(OFILES_SOURCES)

ifeq ($(strip $(CPPFILES)),)
export LD := $(CC)
else
export LD := $(CXX)
endif

.PHONY: all clean

all:
	@mkdir -p $(BUILD)
	@$(MAKE) --no-print-directory -C $(BUILD) -f $(CURDIR)/Makefile

clean:
	@echo clean ...
	@rm -fr $(BUILD) $(TARGET).elf $(TARGET).nds

$(OUTPUT).nds: $(OUTPUT).elf

$(OUTPUT).elf: $(OFILES)

$(OFILES_SOURCES): $(HFILES)

-include $(DEPSDIR)/*.d

endif
