BIN=`pwd`/libs/cross-compiler/compiler/bin/
TARGET=i686-elf
GCC=$(BIN)/$(TARGET)-gcc
AS=$(BIN)/$(TARGET)-as
NASM=$(BIN)/$(TARGET)-nasm

#Install all requirements
install:
	sudo apt install build-essential bison flex libgmp3-dev libmpc-dev libmpfr-dev texinfo qemu-kvm qemu-system-i386 xorriso curl
#Building all drivers in src/drivers
drivers:
	echo "Building drivers..."
#Are we making the cross compiler?
cross-compiler:
	cd libs/cross-compiler && make all
hydrogen:
	echo "Building TINAOS bootstrap..."
	mkdir -p "output"
	$(AS) src/boot/boot.s -o output/boot.o
	make drivers
	$(GCC) -c src/kernel/kernel.c -Isrc/include -Isrc/include/newlib/include -Isrc/include/newlib/lib -o output/kernel.o -std=gnu99 -ffreestanding -O2 -Wall -Wextra
	$(GCC) -T src/boot/linker.ld -o output/HydrogenOS.bin -ffreestanding -O2 -nostdlib output/boot.o output/kernel.o  -lgcc
	mkdir -p output/isodir/boot/grub
	cp src/boot/grub.cfg output/isodir/boot/grub/grub.cfg
	cp output/HydrogenOS.bin output/isodir/boot/TINAOS.bin
	grub-mkrescue -o output/HydrogenOS.iso output/isodir
usb:
	make hydrogen
	sudo dd if=output/HydrogenOS.iso of=$(USB) && sync
qemu:
	make hydrogen
	qemu-system-i386  -cdrom output/HydrogenOS.iso -device gus
