CC=gcc
LD=ld
LDFILE=solrex_x86.ld
OBJCOPY=objcopy

all: boot.img

boot.img: boot.bin
	dd if=/dev/zero of=emptydisk.img bs=512 count=2880
	dd if=boot.bin of=boot.img bs=512 count=1
	dd if=emptydisk.img of=boot.img skip=1 seek=1 bs=512 count=2879

boot.bin: boot.elf
	$(OBJCOPY) -R .pdr -R .comment -R.note -S -O binary boot.elf boot.bin

boot.elf: boot.o
	$(LD) boot.o -o boot.elf -e c -Tsolrex_x86.ld

boot.o: boot.S
	$(CC) -c boot.S

clean:
	rm -rf boot.o boot.elf boot.bin boot.img
