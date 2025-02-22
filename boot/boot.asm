[BITS 16]       ; Start in 16-bit Real Mode
[ORG 0x7C00]    ; BIOS loads bootsector to 0x7C00

start:
    cli             ; Disable interrupts
    mov ax, 0x0000  ; Set up segments
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7C00  ; Set up stack
    sti             ; Enable interrupts

    ; Print boot message
    mov si, boot_msg
    call print_string

    ; Load kernel from disk (sector 2+) to memory at 0x1000
    mov ah, 0x02    ; BIOS read sector function
    mov al, 15      ; Number of sectors to read
    mov ch, 0       ; Cylinder number
    mov cl, 2       ; Sector number (1-based, sector 1 is the boot sector)
    mov dh, 0       ; Head number
    mov dl, 0x80    ; Drive number (0x80 = first hard disk)
    mov bx, 0x1000  ; Load address (ES:BX)
    int 0x13        ; Call BIOS disk service
    jc disk_error   ; Jump if carry flag set (error)

    ; Switch to 32-bit protected mode
    cli             ; Disable interrupts
    lgdt [gdt_descriptor] ; Load GDT
    
    ; Enable A20 line (fast method, may not work on all systems)
    in al, 0x92
    or al, 2
    out 0x92, al
    
    ; Set PE bit in CR0 to enable protected mode
    mov eax, cr0
    or eax, 1
    mov cr0, eax
    
    ; Jump to 32-bit code
    jmp 0x08:protected_mode

disk_error:
    mov si, disk_error_msg
    call print_string
    jmp $           ; Hang

; Print a null-terminated string
print_string:
    lodsb           ; Load next character
    or al, al       ; Check if it's 0 (end of string)
    jz .done
    mov ah, 0x0E    ; BIOS teletype function
    int 0x10        ; Call BIOS interrupt
    jmp print_string
.done:
    ret

[BITS 32]
protected_mode:
    ; Set up segment registers for protected mode
    mov ax, 0x10    ; Data segment selector
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    
    ; Set up stack
    mov esp, 0x90000
    
    ; Jump to kernel
    jmp 0x1000

; Global Descriptor Table (GDT)
gdt_start:
    ; Null descriptor
    dd 0            ; 4 bytes of zeros
    dd 0
    
    ; Code segment descriptor
    dw 0xFFFF       ; Limit (bits 0-15)
    dw 0            ; Base (bits 0-15)
    db 0            ; Base (bits 16-23)
    db 10011010b    ; Access byte
    db 11001111b    ; Flags + Limit (bits 16-19)
    db 0            ; Base (bits 24-31)
    
    ; Data segment descriptor
    dw 0xFFFF       ; Limit (bits 0-15)
    dw 0            ; Base (bits 0-15)
    db 0            ; Base (bits 16-23)
    db 10010010b    ; Access byte
    db 11001111b    ; Flags + Limit (bits 16-19)
    db 0            ; Base (bits 24-31)
gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1  ; Size of GDT
    dd gdt_start                ; Address of GDT

; Messages
boot_msg db 'Booting SimpleOS...', 13, 10, 0
disk_error_msg db 'Error loading kernel!', 13, 10, 0

; Padding and boot signature
times 510-($-$$) db 0
dw 0xAA55