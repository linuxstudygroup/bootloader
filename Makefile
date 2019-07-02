CC=gcc
LD=ld
LDFILE=solrex_x86.ld
OBJCOPY=objcopy

all: boot.img

boot.img: boot.bin diskboot.bin
	dd if=/dev/zero of=$@ bs=512 count=2880
	dd if=boot.bin of=$@ bs=512 conv=notrunc
	dd if=diskboot.bin of=$@ bs=512 seek=1 conv=notrunc

include boot/Makefile

include diskboot/Makefile

clean:
	rm -rf boot.o boot.elf boot.bin boot.img diskboot.o diskboot.elf diskboot.bin boot_c.o
