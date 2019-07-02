.text
#define SEG_ASM(type,base,lim)      \
    .word (((lim) >> 12) & 0xffff), ((base) &0xffff);                             \
    .byte (((base) >> 16) & 0xff), (0x90|(type)), (0xC0 | (((lim) >> 28) & 0xf)), (((base) >> 24) & 0xff)

#define STA_X       0x8     /* Executable segment */
#define STA_E       0x4     /* Expand down (non-executable segments) */
#define STA_C       0x4     /* Conforming code segment (executable only) */
#define STA_W       0x2     /* Writeable (non-executable segments) */
#define STA_R       0x2     /* Readable (executable segments) */
#define STA_A       0x1     /* Accessed */

.global _start
_start:
    .code16
    cli

    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss

    /* Enter protected mode */
    /* Enable Fast A20 */
setupA20:
    /* get the value of I/O port 0x92 */
    movb $0x2, %al
    outb %al, $0x92

setupFirstGDT:
    lgdt GDTR
    movl %cr0, %eax
    orl $0x1, %eax
    movl %eax, %cr0
    
    /* selector*/
    /* 15-3 bit: index */
    /* 2 bit: TI 0 for GDT, 1 for LDT */
    /* 1-0 bit: RPL, requested privilige level */
    /* 0x1 << 3 == 0x8 */
    ljmp $0x8, $protc

.code32
protc:
    /* 0x2 << 3 == 0x10 */
    movw $0x10, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %fs
    movw %ax, %gs
    movw %ax, %ss
l:
    call bootmain 

 
GDT:
    /* First GDT: NULL GDT */
    .word 0, 0
    .byte 0, 0, 0, 0

    /* code seg for bootloader and kernel */
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)

    /* data seg for bootloader and kernel */
    SEG_ASM(STA_W, 0x0, 0xffffffff)
    

GDTR:
    /* limit of gdt */
    /* 3 GDT, 3 * 8 = 24. index from 0. so that limit equals 23 == 0x17*/
    .word 0x17
    /* address of GDT */
    .long GDT
/* .org 512 */
