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
    sub %si, %si
    # enter copy loop
    movb BootMessage(%si), %dl

copyloop:
    # copy ascii byte
    movb %dl, %es:(%di)
    inc %di
    movb Color, %dl
    movb %dl, %es:(%di)
    inc %di
    inc %si
    movb BootMessage(%si), %dl
    cmpb $0x00, %dl
    jne copyloop

    ret

Color: .byte 0x01
BootMessage: .ascii "Hello, OS world!"
             .byte 0x00
.org 510
.word 0xaa55
