.code16
.text
    mov %cs, %ax
    mov %ax,%ds
    mov %ax,%es
    call CpToDispMem
INF: 
    jmp INF

CpToDispMem:
    # set base address of display memory
    mov $0xb800, %ax
    mov %ax, %es
    # set index registor
    sub %di, %di
    # enter copy loop
    movw BootMessage(%di), %dx

copyloop:
    # copy ascii byte
    movw %dx, %es:(%di)
    inc %di
    inc %di
    movw BootMessage(%di), %dx
    cmp $0x00, %dx
    jne copyloop

    ret

BootMessage:
.byte 'H', 0x01, 'e', 0x02, 'l', 0x03, 'l', 0x04
.byte 'o', 0x05, ',', 0x06, ' ', 0x07, 'O', 0x06
.byte 0x53, 0x05, ' ', 0x04, 'w', 0x03, 'o', 0x02
.byte 'r', 0x01, 'l', 0x02, 'd', 0x03, '.', 0x04
.word 0x00

.org 510
.word 0xaa55
