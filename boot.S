.code16
.text
    mov %cs, %ax
    mov %ax,%ds
    mov %ax,%es
    call CpToDispMem
    INF: jmp INF

CpToDispMem:
    # set base address of display memory
    mov $0xb800, %ax
    mov %ax, %es
    # set source base address to bp registor 
    mov $BootMessage, %ax
    mov %ax, %bp
    # set index registor
    sub %di, %di
    # set end condition
    mov $EndBootMsg, %cx
    sub $BootMessage, %cx
    # enter copy loop
copyloop:
    # copy ascii byte
    movw 0x0(%bp,%di), %dx
    movw %dx, %es:(%di)

    inc %di
    // if (%cx < %dx)
    // jmp to copyloop
    cmp %di, %cx
    jg copyloop
    // else
    // return

    ret

BootMessage:
.byte 'H'
.byte 0x01
.byte 'e'
.byte 0x02
.byte 'l'
.byte 0x03
.byte 'l'
.byte 0x04
.byte 'o'
.byte 0x05
.byte ','
.byte 0x06
.byte ' '
.byte 0x07
.byte 'O'
.byte 0x07
.byte 'S'
.byte 0x17
.byte ' '
.byte 0x27
.byte 'w'
.byte 0x37
.byte 'o'
.byte 0x47
.byte 'r'
.byte 0x57
.byte 'l'
.byte 0x67
.byte 'd'
.byte 0x01
.byte '!'
.byte 0x02

EndBootMsg:
.org 510
.word 0xaa55
