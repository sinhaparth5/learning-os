# Learning OS in C & Assembly

[![Typo Check](https://github.com/sinhaparth5/learning-os/actions/workflows/typo-check.yml/badge.svg)](https://github.com/sinhaparth5/learning-os/actions/workflows/typo-check.yml)

A minimal operating system implementation for educational purpose, built from scratch using C and x86 Assembly. This project aims to teach low-level systems programming and OS fundamentals.

## Features

- 🖥️ Basic 32-bit kernel with protected mode
- ⌨️ Keyboard input handling
- 🖨️ Text-mode VGA display driver
- 📟 Basic shell implementation
- 🗂️ Simple FAT12 filesystem reader
- 🧠 Physical memory management
- 🕹️ Basic game (Pong) demonstration

## Prerequisites

- **x86 cross-compiler toolchain**
- **NASM** (Netwide Assembler)
- **QEMU** (for emulation)
- **Make** (build system)
- **GCC** & **Binutils**

*Recommended:*
- Ubuntu/Debian: `sudo apt-get install build-essential nasm qemu-system-x86`
- Fedora: `sudo dnf install @development-tools nasm qemu-system-x86`

## Getting Started
1. Clone the repository
```bash
git clone https://github.com/sinhaparth5/learning-os.git
cd learning-os
```

2. Build the OS:
```bash
make all
```

3. Run in QEMU:
```bash
make run
```

4. Clean build artifacts:
```bash
make clean
```


