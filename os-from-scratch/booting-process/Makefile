BINARY:=boot_sect.bin

.PHONY: assemble run clean


$(BINARY):
	nasm boot_sect.asm -f bin -o $@


run: $(BINARY)
	qemu-system-i386 $<

clean:
	rm $(BINARY)
