#include "boot.h"

/* 
 * BIOS中断INT 0x13中，

 * ah=0x02,即为读磁盘扇区到内存，利用这二号服务即可读入setup模块。
 *
 * 调用此功能将从磁盘上把一个或更多的扇区内容读进存贮器。因为这是一个
 * 低级功能，在一个操作中读取的全部扇区必须在同一条磁道上（磁头号和磁道号
 * 相同）。BIOS不能自动地从一条磁道末尾切换到另一条磁道开始，因此用户必须
 * 把跨多条磁道的读操作分为若干条单磁道读操作。
 * 
 * 入口参数：
 * AH=02H 指明调用读扇区功能。
 * AL 置要读的扇区数目，不允许使用读磁道末端以外的数值，也不允许使该寄存器为0。
 * 
 * CH 磁道号的低8位数。
 * 
 * CL 低5位放入所读起始扇区号，位7-6表示磁道号的高2位。cl=开始扇区（位0—5），磁道号高二位（位6—7）
 * 
 * DL 需要进行读操作的驱动器号。dl=驱动器号（若是硬盘则要置位7）
 * DH 所读磁盘的磁头号。dh=磁头号

 * es:Bx—>指向数据缓冲区   ES:BX 读出数据的缓冲区地址。
 * 
 * 若出错则CF示志置位
 * 
 * 返回参数：
 * 如果CF=1，AX中存放出错状态。读出后的数据在ES:BX区域依次排列
 * 
 * BOOTSEG equ 0x07c0 ;boot.bin 被bios加载到0x7c00内存处
 * SYSSEG equ 0x1000 ;kernel先被加载到0x10000,再移动到0x0处
 * SYSLEN equ 17 ;内核最多占用17个扇区 17*512字节
 * KERNEL_CS equ 0x08 ;内核代码段选择符
 * start:
 *      jmp 0x07c0:go ;这条指令将cs寄存器设为0x07c0,便于寻址
 * go:
 *      mov ax,cs
 *      mov ds,ax
 *      mov es,ax
 *      mov ss,ax
 *      mov sp,0x400 ;开辟栈空间逻辑地址0x400-0x200用作栈空间,0x200-0x00用于存放boot.bin
 * 上面的代码先用一个jmp跳转指令将cs寄存器的内容置为0x07c0,并同步给ds,es,ss.这是为了便于后面寻址,这样后面用label(比如load_kernel作为偏移地址时就是实际的物理地址,因为这段程序被加载到0x7c00处,就相当于cs*16 + label = 0x7c00 + label偏移).然后sp赋值为0x400,由于这段程序本身占一个扇区0x200,所以栈空间可用为0x200.
 * load_kernel:
 *      mov dx,0x0000 ;DH is head,DL is driver  
 *      mov cx,0x0002; CL 6,7位是磁道号高２位.位5~0是起始扇区号(从１开始)
 *      mov ax,SYSSEG
 *      mov es,ax ;读入缓冲区基址0x1000
 *  
 *      xor bx,bx
 *      mov ax,0x200 + SYSLEN ;AH-读扇区功能号(2);AL-需要读的扇区数(17,即第一柱面除去第１个扇区(是boot.s),剩余的17个扇区是kernel.bin)
 *      int 0x13
 *      jnc load_ok; 如果有错误, CF位会被置位
 * load_fail: jmp load_fail ;死循环
 * --------------------- 
 * 作者：Farmwang 
 * 来源：CSDN 
 * 原文：https://blog.csdn.net/farmwang/article/details/49963967 
 * 版权声明：本文为博主原创文章，转载请附上博文链接！
 *
 */

.file "boot.S"
.text
.code16

.global _start
_start:
    jmp load_diskboot

diskboot_address:
    .word BOOT_KERNEL_ADDR

load_diskboot:
    /* disable interrupt */
    cli         
    
    /* setup %ds and %ss */
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %ss
    
    /* enable interrupt */
    sti        

    /* pre-set the paramter for load the second sector */
    /* by calling the INT 13h */

    /* function number 2 read sector */
    movb $0x02, %ah   
    /* read 1 sector */
    movb $0x1, %al    
    /* cylinder_start=0 */
    movb $0x0, %ch  
    /* sector_start=2 */
    movb $0x2, %cl     
    /* floppy */
    movb $0x0, %dl    
    /* header_start=0 */  
    movb $0x0, %dh    
    movw $BOOT_KERNEL_SEG, %bx 
    movw %bx, %es
    xorw %bx, %bx

    int $0x13
    jnc jmp_to_diskboot
load_fail:
    jmp load_fail


jmp_to_diskboot:
    jmp *(diskboot_address)

.org MBR_BOOT_LOADER_END
.org MBR_END
.word MBR_SIGNATURE
