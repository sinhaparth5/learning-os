# Makefile for SimpleOS

# Compiler/Assembler settings
CC = gcc
AS = nasm
LD = ld

# Compiler flags
CFLAGS = -m32 -nostdlib -nostdinc -fno-builtin -fno-stack-protector -nostartfiles -nodefaultlibs -Wall -Wextra -Werror -c

# Assembler flags
ASFLAGS = -f elf32

# Output files
KERNEL_BIN = kernel.bin
OS_IMAGE = simpleos.img

# Source files
BOOT_SRC = boot/boot.asm
KERNEL_SOURCES = kernel/kernel.c kernel/screen.c kernel/scheduler.c

# Object files
KERNEL_OBJECTS = $(KERNEL_SOURCES:.c=.o)

# Default target
all: $(OS_IMAGE)

# Compile C sources
%.o: %.c
	$(CC) $(CFLAGS) -o $@ $<

# Assemble boot loader
boot/boot.bin: $(BOOT_SRC)
	$(AS) -f bin -o $@ $<

# Link kernel
$(KERNEL_BIN): $(KERNEL_OBJECTS)
	$(LD) -m elf_i386 -T linker.ld -o $@ $^

# Create disk image
$(OS_IMAGE): boot/boot.bin $(KERNEL_BIN)
	# Create empty disk image
	dd if=/dev/zero of=$(OS_IMAGE) bs=512 count=2880
	
	# Write boot sector
	dd if=boot/boot.bin of=$(OS_IMAGE) conv=notrunc
	
	# Write kernel (starting at sector 2)
	dd if=$(KERNEL_BIN) of=$(OS_IMAGE) bs=512 seek=1 conv=notrunc

# Run in QEMU
run: $(OS_IMAGE)
	qemu-system-i386 -drive format=raw,file=$(OS_IMAGE)

# Clean up
clean:
	rm -f $(KERNEL_OBJECTS) $(KERNEL_BIN) boot/boot.bin $(OS_IMAGE)

.PHONY: all run clean