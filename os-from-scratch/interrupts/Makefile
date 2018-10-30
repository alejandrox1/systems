.PHONY: boot_sector exit-code maximum-value run clean

run: boot_sector
	qemu-system-i386 boot_sector.bin

boot_sector: hello-boot_sect.asm
	nasm hello-boot_sect.asm -f bin -o boot_sector.bin

exit-code: exit-code.s
	as exit-code.s -o exit-code.o
	ld exit-code.o -o exit

maximum-value: max-value.s
	as max-value.s -o max-value.o
	ld max-value.o -o maximum

clean:
	rm -f exit-code.o exit
	rm -f max-value.o maximum
	rm -f boot_sector.bin
