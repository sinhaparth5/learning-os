#ifndef KERNEL_H
#define KERNEL_H

/* Type definitions */
typedef unsigned char uint8_t;
typedef unsigned short uint16_t;
typedef unsigned int uint32_t;
typedef int bool;
#define true 1
#define false 0
#define NULL ((void*)0)

/* Hardware communication */
static inline uint8_t inb(uint16_t port) {
    uint8_t result;
    __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
    return result;
}

static inline void outb(uint16_t port, uint8_t data) {
    __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

/* Memory operations */
void* memcpy(void* dest, const void* src, uint32_t count);
void* memset(void* dest, char val, uint32_t count);

/** Screen functions (defined in screen.h) */
void clear_screen();
void kprint(const char* str);