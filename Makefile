#######################################################################
#                      GNU ARM Cross Compiler
#
# CC stores the name of the cross compiler.
#
# A cross compiler runs on the host computer (Windows/Linux)
# but generates machine code for a different architecture,
# in this case the ARM Cortex-M3 microcontroller.
#######################################################################

CC = arm-none-eabi-gcc


#######################################################################
#                      Target Processor
#
# Specifies the target processor architecture.
# This variable is reused throughout the Makefile to avoid
# repeating "cortex-m3" multiple times.
#######################################################################

MACH = cortex-m3


#######################################################################
#                      Compiler Flags
#
# These options are used while compiling C source files.
#
# -c                Compile only (no linking)
# -mcpu             Target processor
# -mthumb           Generate Thumb instructions
# -mfloat-abi=soft  Software floating-point operations
# -std=gnu11        GNU C11 standard
# -O0               Disable optimization for easier debugging
#######################################################################

CFLAGS = -c -mcpu=$(MACH) -mthumb -mfloat-abi=soft -std=gnu11 -O0 -g


#######################################################################
#                      Linker Flags
#
# These options are used while linking object files.
#  -nostdlib        do not include any standard libraries
# -T linker.ld      Use the custom linker script
# -Wl,-Map          Generate a memory map file
#
# The map file is useful for analyzing Flash usage,
# RAM usage and symbol locations.
#######################################################################

LDFLAGS = -mcpu=$(MACH) -mfloat-abi=soft -mthumb -nostdlib -T linker.ld -Wl,-Map=blink.map

#######################################################################
# Default Target
#
# This is the first target executed when "make" is run.
#
# It tells Make which files must be built to successfully
# generate the final executable.
#######################################################################

all : blinkingled.o startup.o blink.elf


#######################################################################
# Application Source
#
# Contains the main application logic for configuring the
# peripherals and blinking the onboard LED.
#######################################################################

blinkingled.o : blinkingled.c
	$(CC) $(CFLAGS) blinkingled.c -o blinkingled.o


#######################################################################
# The startup code is compiled separately because it contains
# the reset handler, vector table, and runtime initialization
# required before main() is executed.
#######################################################################

startup.o : startup.c
	$(CC) $(CFLAGS) startup.c -o startup.o


#######################################################################
#                      Linking Stage
#
# Combines all object files into the final executable.
#
# During this stage the linker:
#
# • Uses linker.ld to determine the memory layout.
# • Resolves references between object files.
# • Places code in Flash and data in RAM.
# • Generates the final ELF executable.
#######################################################################

blink.elf : blinkingled.o startup.o
	$(CC) $(LDFLAGS) blinkingled.o startup.o -o blink.elf


#######################################################################
#                      Clean Project
#
# Removes all generated build files.
#
# Usage:
# make clean
#######################################################################

clean:
	del /Q *.o *.elf


#######################################################################
#                      Start OpenOCD
#
# Usage:
# make load
#
# Launches the OpenOCD server using the ST-Link interface
# and STM32F1 target configuration.
#
# This command only starts OpenOCD. Firmware flashing can
# later be performed using GDB or the OpenOCD "program" command.
#######################################################################

load:
	openocd -f interface/stlink.cfg -f target/stm32f1x.cfg
	