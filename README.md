# Bare-Metal LED Blink on STM32 Blue Pill (STM32F103CBT6)

> A bare-metal firmware project demonstrating register-level GPIO programming on the STM32F103CBT6 using Embedded C, GNU Arm Embedded Toolchain, OpenOCD, and GDB.

<p align="center">
  <img src="https://img.shields.io/badge/Language-C-blue">
  <img src="https://img.shields.io/badge/Architecture-ARM%20Cortex--M3-green">
  <img src="https://img.shields.io/badge/MCU-STM32F103CBT6-orange">
  <img src="https://img.shields.io/badge/Programming-Bare--Metal-red">
  <img src="https://img.shields.io/badge/Build-GNU%20Make-yellow">
</p>

---

# 📖 Overview

This project demonstrates bare-metal firmware development on the **STM32 Blue Pill (STM32F103CBT6)** using **Embedded C** without relying on HAL, STM32CubeMX, or third-party libraries.

The firmware directly configures the GPIOC peripheral through memory-mapped registers to blink the onboard **PC13 LED**. The project includes a custom startup file, linker script, Makefile, and a complete build, flash, and debug workflow using the GNU Arm Embedded Toolchain.

---

# ✨ Features

- Bare-Metal Embedded C
- Register-Level GPIO Programming
- Memory-Mapped Peripheral Access
- Custom Startup Code
- Custom Linker Script
- GNU Make Build System
- GNU Arm Embedded Toolchain
- OpenOCD Flashing
- GDB Debugging
- ELF & MAP File Generation

---

# 🛠 Hardware

| Component | Description |
|-----------|-------------|
| STM32 Blue Pill | STM32F103CBT6 Development Board |
| ST-Link V2 | SWD Programmer & Debugger |
| Jumper Wires | SWD Connections |

---

## STM32 Blue Pill

<p align="center">
  <img src="images/stm32 blue pill.jpeg" width="550" alt="STM32 Blue Pill">
</p>

---

## ST-Link V2

<p align="center">
  <img src="images/stlink v2.jpeg" width="400" alt="ST-Link V2">
</p>

---

# 💻 Software Used

| Software | Purpose |
|-----------|---------|
| GNU Arm Embedded Toolchain | Cross Compilation |
| GNU Make | Build Automation |
| OpenOCD | Flash Programming |
| GNU GDB | Firmware Debugging |
| Visual Studio Code | Source Code Editor |

---

# 📂 Repository Structure

```text
bare-metal-led-blink-stm32-blue-pill/
│
├── blinkingled.c
├── startup.c
├── linker.ld
├── Makefile
├── README.md
├── LICENSE
│
└── images/
    ├── compiler image.png
    ├── memory mapping.png
    ├── stm32 blue pill.jpeg
    ├── stlink v2.jpeg
    ├── vector table.png
    ├── vector table1.png
    └── vector table2.png
```

---
# 🔨 Build & Flash

This project uses the **GNU Arm Embedded Toolchain**, **GNU Make**, **OpenOCD**, and **GDB** to build, flash, and debug the firmware.

---

# 🏗️ Build Workflow

<p align="center">
  <img src="images/compiler image.png" width="850" alt="Compiler Workflow">
</p>

The firmware is compiled using **arm-none-eabi-gcc**, linked with the custom **linker.ld** script, and generates the final executable (`blink.elf`) for the STM32F103CBT6.

---

# 🛠️ Build Tools

| Tool | Purpose |
|------|---------|
| GNU Arm Embedded GCC | Compiles and links the firmware |
| GNU Make | Automates the build process |
| OpenOCD | Programs the STM32 Blue Pill |
| GNU GDB | Debugs the firmware |

---

# ⚙️ Build the Project

Open a terminal in the project directory and run:

```bash
make all
```

This command:

- Compiles `blinkingled.c`
- Compiles `startup.c`
- Links both object files using `linker.ld`
- Generates `blink.elf`
- Generates `blink.map`

---

# 📦 Build Output

| File | Description |
|------|-------------|
| `blinkingled.o` | Application object file |
| `startup.o` | Startup object file |
| `blink.elf` | Final firmware executable |
| `blink.map` | Linker memory map |

---

# 📥 Flash the Firmware

Connect the STM32 Blue Pill to the ST-Link V2 programmer and run:

```bash
make load
```

OpenOCD uses the ST-Link interface to program the firmware onto the target device.

---

# 🐞 Debug the Firmware

Start GDB:

```bash
arm-none-eabi-gdb blink.elf
```

Connect to the target:

```gdb
target remote localhost:3333
```

Initialize the target:

```gdb
monitor reset init
```

Load the firmware:

```gdb
load
```

Run the application:

```gdb
monitor reset run
```

To halt the processor after reset:

```gdb
monitor reset halt
```

Exit GDB:

```gdb
quit
```

---
# 🗂️ Memory Layout

The memory layout used by this project is defined in the custom **`linker.ld`** file.

<p align="center">
  <img src="images/memory mapping.png" width="850" alt="STM32 Memory Map">
</p>

---

## Memory Regions

| Region | Start Address | Size |
|---------|---------------|------|
| Flash | `0x08000000` | 128 KB |
| SRAM | `0x20000000` | 20 KB |

---

## Linker Configuration

The linker script defines:

- Firmware entry point (`Reset_handler`)
- Flash memory region
- SRAM memory region
- Section placement
- Linker symbols required by the startup code

---

## Firmware Sections

| Section | Memory | Description |
|---------|--------|-------------|
| `.isr_vector` | Flash | Interrupt Vector Table |
| `.text` | Flash | Program Instructions |
| `.rodata` | Flash | Read-Only Data |
| `.data` | SRAM | Initialized Global & Static Variables |
| `.bss` | SRAM | Uninitialized Global & Static Variables |

---

# 🚀 Startup Sequence

The startup sequence is implemented in **`startup.c`** and begins execution immediately after a system reset.

---

## Interrupt Vector Table

<p align="center">
  <img src="images/vector table.png" width="850" alt="Interrupt Vector Table">
</p>

The interrupt vector table is placed at the beginning of Flash memory and contains the initial stack pointer, reset handler, exception handlers, and interrupt handlers.

---

## Peripheral Interrupts

<p align="center">
  <img src="images/vector table1.png" width="850" alt="Peripheral Interrupts">
</p>

The vector table also contains entries for peripheral interrupts supported by the STM32F103CBT6.

---

## Remaining Interrupts

<p align="center">
  <img src="images/vector table2.png" width="850" alt="Remaining Interrupts">
</p>

Additional interrupt vectors are reserved for the remaining peripherals available on the STM32F103CBT6.

---

## Reset Handler

The `Reset_handler` performs the required runtime initialization before transferring execution to the application.

The initialization sequence includes:

- Copying the `.data` section from Flash to SRAM
- Clearing the `.bss` section
- Initializing the stack pointer
- Calling the `main()` function

After the initialization is complete, execution continues in `blinkingled.c`, where the onboard **PC13 LED** is configured and continuously blinked.

---
# 📁 Source Files

| File | Description |
|------|-------------|
| `blinkingled.c` | Configures GPIOC and blinks the onboard PC13 LED using direct register access. |
| `startup.c` | Contains the interrupt vector table, Reset Handler, runtime initialization, and default exception handlers. |
| `linker.ld` | Defines the memory layout, section placement, and program entry point. |
| `Makefile` | Automates the build, linking, and flashing process. |

---

# 📋 Project Summary

- Target MCU: **STM32F103CBT6 (STM32 Blue Pill)**
- Programming Language: **Embedded C**
- Programming Method: **Bare-Metal**
- Build System: **GNU Make**
- Compiler: **GNU Arm Embedded GCC**
- Debugger: **GNU GDB**
- Programmer: **OpenOCD**
- Communication Interface: **SWD (Serial Wire Debug)**

---

# 📂 Repository Structure

```text
bare-metal-led-blink-stm32-blue-pill/
│
├── blinkingled.c
├── startup.c
├── linker.ld
├── Makefile
├── README.md
├── LICENSE
│
└── images/
    ├── compiler image.png
    ├── memory mapping.png
    ├── stm32 blue pill.jpeg
    ├── stlink v2.jpeg
    ├── vector table.png
    ├── vector table1.png
    └── vector table2.png
```

---

# 📚 References

- ARM Cortex-M3 Technical Reference Manual
- STM32F103 Reference Manual (RM0008)
- STM32F103CBT6 Datasheet
- GNU Arm Embedded Toolchain Documentation
- GNU Make Documentation
- OpenOCD Documentation
- GNU GDB Documentation

---

# 📄 License

This project is licensed under the **MIT License**.

See the `LICENSE` file for more details.

---

# ⭐ Support

If you found this project helpful, consider giving it a **⭐ Star** on GitHub.

Feedback and suggestions are always welcome.



