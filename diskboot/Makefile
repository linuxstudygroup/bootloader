DISKBOOT_DIR=diskboot
GCC_ARCH=-m32
LD_ARCH=elf_i386
diskboot.bin: diskboot.elf
	$(OBJCOPY) -R .pdr -R .comment -R.note -S -O binary diskboot.elf diskboot.bin

diskboot.elf: diskboot.o boot_c.o
	$(LD) -m $(LD_ARCH) diskboot.o boot_c.o -o diskboot.elf -T $(DISKBOOT_DIR)/solrex_x86.ld

diskboot.o: $(DISKBOOT_DIR)/diskboot.S
	$(CC) $(GCC_ARCH) -c $(DISKBOOT_DIR)/diskboot.S

boot_c.o: $(DISKBOOT_DIR)/diskboot.c
	$(CC) -g $(GCC_ARCH)  -c $(DISKBOOT_DIR)/diskboot.c -o boot_c.o -fno-stack-protector

