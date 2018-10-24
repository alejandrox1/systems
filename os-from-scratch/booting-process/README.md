# The booting process

We start looking at the isue of operating systems from the very beginning:
machine start up.

At this point, the only thing that exists in the machine is the
[BIOS](https://en.wikipedia.org/wiki/BIOS) (Basic Input/Output System).

> BIOS is non-volatile firmware used to perform hardware initialization during
> the booting process (power-on startup), and to provide runtime services for
> operating systems and programs.
> [pcguide](http://www.pcguide.com/ref/mbsys/bios/index.htm)

The BIOS will automatically detect some essential devces such as the screen,
keyboard, and hard disks.

When we turn on our machine, the os has to come to be loaded from some
permanent storage device.
We cannot search for "files" as file systems are built on top of operating
systems and we have yet to build one.
So what the BIOS does is that it goes through the hard disk, sector by sector
(see [cylinder-head-sector](https://en.wikipedia.org/wiki/Cylinder-head-sector))
- sectors are 512  bytes long.
One question to ask is then how does the BIOS know when it has found an
entrypoint for the os since data and instructions are indistinguishable at
first sight? 
The solution: magic numbers!

The BIOS reads in sectors until it finds the one with the magic number
`0xaa55`. 
This number defines the boot sector.

## [Endianness](https://en.wikipedia.org/wiki/Endianness)
The x86 architecture uses little-endian format. In litle-endian format the 
least significant byte is stored first (has the lowest memory address).
So `0xaa55` is stored as `0x55` `0xaa`.

## Writing a boot sector
So let's write a boot sector!

### Approach 1

Create a 512 byte long file. 
```
$ dd if=/dev/zero of=boot_sect.bin bs=512 count=1
1+0 records in
1+0 records out
512 bytes copied, 0.000597349 s, 857 kB/s
```

We will use `ghex` to open up our boot sector.
```
$ ghex boot_sect.bin
```

Go all the way to the end of the file and add the magic number - `0x55` `0xAA`.


### Approach 2

Write a program that will loop forever so that we can see that it was indeed
loaded in by the BIOS.
```assembly
loop:
    jmp loop
```

The only other requirement is to make the program 512 bytes long and place the
magic number `0xaa55` at the end of the sector.
```assembly
time 510-($-$$) db 0

dw 0xaa55
```

You can find the above program [here](./boot_sect.asm).

In nasm, the token `$` corresponds to the address of the current position
before emitting any bytes for the line it appears.
`$$` is the address if the beginning of the current section.
So, `$-$$` gives the legnth of the section so far.


For more context on what we mean by "section" or "segment" visit the references
addressing object files.


To assemble the program do
```
$ nasm boot_sect.asm -f bin -o boot_sect.bin
```


## Try it out!

### Qemu
```
$ qemu-system-i386 boot_sect.bin
```

### Bochs
You can use [this sample bochs config file](./bochsrc.txt).

```
$ bochs
```


You should compare the resulting binary from approach 1 and 2.
To display the contents on the boot sectors we have created you can use `od`.
```
$ od boot_sect.bin -t x1 -A n boot_sect.bin
```


## References

- [Writing a Simple Operating System - from Scratch](https://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf)

- [pseudo-instruction `db`](https://www.nasm.us/doc/nasmdoc3.html#section-3.2)

- [`$` and `$$` tokens](https://www.nasm.us/doc/nasmdoc3.html#section-3.5)

- [Use of `$` and `$$`](https://www.nasm.us/doc/nasmdo12.html#section-12.1.3)

- [Object and executable files](http://web.cecs.pdx.edu/~harry/Blitz/BlitzDoc/ObjectFileFormat.htm)

- [Object file](https://en.wikipedia.org/wiki/Object_file)

- [data segment](https://en.wikipedia.org/wiki/Data_segment)

- [Linux Foundation Referenced Specifications](http://refspecs.linuxbase.org/)
