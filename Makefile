CC=gcc
LD=ld
LDFILE=solrex_x86.ld
OBJCOPY=objcopy

all: boot.img

boot.img: boot.bin diskboot.bin
	dd if=/dev/zero of=emptydisk.img bs=512 count=2880
	cat boot.bin diskboot.bin > merge.bin
	dd if=merge.bin of=boot.img bs=512 count=2
	dd if=emptydisk.img of=boot.img skip=2 seek=2 bs=512 count=2878

include boot/Makefile

include diskboot/Makefile

clean:
	rm -rf boot.o boot.elf boot.bin boot.img emptydisk.img diskboot.o diskboot.elf diskboot.bin
