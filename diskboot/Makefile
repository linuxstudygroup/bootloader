DISKBOOT_DIR=diskboot

diskboot.bin: diskboot.elf
	$(OBJCOPY) -R .pdr -R .comment -R.note -S -O binary diskboot.elf diskboot.bin

diskboot.elf: diskboot.o
	$(LD) diskboot.o -o diskboot.elf -e c -T $(DISKBOOT_DIR)/solrex_x86.ld

diskboot.o: $(DISKBOOT_DIR)/diskboot.S
	$(CC) -c $(DISKBOOT_DIR)/diskboot.S

