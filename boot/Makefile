CC=gcc
LD=ld
LDFILE=solrex_x86.ld
OBJCOPY=objcopy
BOOT_DIR=boot

boot.bin: boot.elf
	$(OBJCOPY) -R .pdr -R .comment -R.note -S -O binary boot.elf boot.bin

boot.elf: boot.o
	$(LD) boot.o -o boot.elf -e c -T $(BOOT_DIR)/solrex_x86.ld

boot.o: $(BOOT_DIR)/boot.S
	$(CC) -c $(BOOT_DIR)/boot.S

