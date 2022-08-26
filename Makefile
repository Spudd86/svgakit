
# Simple, DJGPP only makefile for building SciTech's SVGAKit library.
#
# Requires Borland's Turbo Assembler and obj2bfd
# obj2bfd: http://ftp.delorie.com/pub/djgpp/current/v2apps/o2bfd01b.zip

.PHONY: all clean
.SUFFIXES:



CC      := gcc      # C-compiler and flags
AR      := ar       # Librarian
TASM    := tasm     # Borland Turbo Assembler
OBJ2BFD := obj2bfd  # obj2bfd, convert object file formats, can get from djgpp ftp


CFLAGS     := -std=gnu90 -g3 -O2 -march=pentium-mmx -m80387 -malign-double -mpc64 -w
CPPFLAGS   := -DDJGPP -DFPU387 -Iinclude
ARFLAGS    := rs
TASM_FLAGS := /t /z /zi /mx /D__FLAT__ /DDJGPP /DFPU387 /iINCLUDE


SVGAKIT_OBJECTS := vesavbe.o svgasdk.o vbeaf.o font8x16.o vgapal.o gtfcalc.o cpu.o \
                  _svgasdk.o _linsdk.o _vbeaf.o \
                   event.o maskcode.o _event.o
SVGAKIT_OBJECTS := $(addprefix svgakit/, $(SVGAKIT_OBJECTS))

PMODE_OBJECTS := pmlite.o pmpro.o vflat.o _pmlite.o _pmpro.o _vflat.o
PMODE_OBJECTS := $(addprefix pmode/, $(PMODE_OBJECTS))


all: svgakit.a

clean:
	-rm -f $(SVGAKIT_OBJECTS)
	-rm -f $(PMODE_OBJECTS)
	-rm -f pmode/*.obj svgakit/*.obj
	-rm -f svgakit.a

%.o: %.c
	@echo CC $<
	@$(CC) -c $(CPPFLAGS) $(CFLAGS) $< -o $@

%.obj: %.asm
	@echo AS $<
	@$(TASM) $(TASM_FLAGS) $(subst /,\,$<),$(subst /,\,$@)

%.o: %.obj
	@$(OBJ2BFD) -u -O coff-go32 -o $@ $<
	
	
svgakit.a: $(SVGAKIT_OBJECTS) $(PMODE_OBJECTS)
	@echo AR $@
	$(AR) $(ARFLAGS) $@ $^

	
