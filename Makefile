
.SUFFIXES:
.DEFAULTTARGET: all

include Make.conf

# Code and compilation directories
SRCDIR 	= src
OBJDIR 	= obj
BINDIR 	= bin
DEPSDIR = deps

# RGBDS arguements
ASFLAGS += -E -i $(SRCDIR)/ -p $(PadValue)
LDFLAGS += -p $(PadValue)
FXFLAGS += -v -k $(NewLicensee) -l $(OldLicensee) -m $(MBCType) -n $(ROMVersion) -p $(PadValue) -r $(SRAMSize) -t $(ROMTitle)

# Target output
ROMFILE = $(BINDIR)/$(ROMFileName).gb

# The list of "root" ASM files that RGBASM will be invoked on
ASMFILES := $(wildcard $(SRCDIR)/*.asm)

.PHONY: all
all: $(ROMFILE)

.PHONY: clean
clean:
	-rm -rf $(BINDIR) $(DEPSDIR) $(OBJDIR)

# This target opens an instance of the bgb GB emulator, watching the binary location for changes.
# However, it only works on Windows Subsystem for Linux with bgb in the environment path of the Windows host.
.PHONY: bgb
bgb: all
	@echo " NOTE: 'make bgb' only works on WSL with bgb in the host Windows environment path"
	bgb.exe -rom "$(shell wslpath -m `pwd`)/$(ROMFILE)" -watch

# Generate dependencies
$(DEPSDIR)/%.d: $(SRCDIR)/%.asm
	@mkdir -p $(DEPSDIR)
	@mkdir -p $(OBJDIR)
	rgbasm $(ASFLAGS) -M $@.tmp -o $(patsubst $(SRCDIR)/%.asm,$(OBJDIR)/%.o,$<) $<
	@sed 's,\($*\)\.o[ :]*,\1.o $@: ,g' < $@.tmp > $@
	@rm $@.tmp

# Include (and potentially remake) all dependency files if the target isn't "clean".
ifneq ($(MAKECMDGOALS),clean)
-include $(patsubst $(SRCDIR)/%.asm,$(DEPSDIR)/%.d,$(ASMFILES))
endif

# How to build the .gb file
$(ROMFILE): $(patsubst $(SRCDIR)/%.asm,$(OBJDIR)/%.o,$(ASMFILES))
	@mkdir -p $(BINDIR)

	rgblink $(LDFLAGS) -o $@ -m $(BINDIR)/$(ROMFileName).map -n $(BINDIR)/$(ROMFileName).sym $^
	rgbfix $(FXFLAGS) $@

# How to build the .o files
# Note: This will not be used unless a .o file is missing and the corresponding .d dependency is not missing
$(OBJDIR)/%.o: $(SRCDIR)/%.asm
	@mkdir -p $(OBJDIR)
	rgbasm $(ASFLAGS) -o $@ $<