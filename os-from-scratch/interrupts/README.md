```
/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\  
|                               | 0x100000
|                               |
|        BIOS (256 kb)          |
|                               |
--------------------------------- 0xC0000
|                               |
|     Video Memory (128 Kb)     |
|                               |
--------------------------------- 0xA0000
|                               |
|    Extended BIOS Data Area    |
|         (639 Kb)              |
|                               |
+-------------------------------+ 0x9fc00
|                               |
|        Free (638 Kb)          |
|                               |
--------------------------------- 0x7e00
|                               |
| Load boot sector (512 bytes)  |
|                               |
--------------------------------- 0x7c00
|                               |
|                               |
|                               |
--------------------------------- 0x0500
|                               |
|   BIOS Data Area (256 bytes)  |
|                               |
--------------------------------- 0x0400
|                               |
| Interrupt Vector Table (1 Kb) |
|                               |
+-------------------------------+ 0x0000
```


## Interrupt descriptor table

> The IDT is used by the processor to determine the correct response to
> interrupts and exceptions.
> [wikipedia](https://en.wikipedia.org/wiki/Interrupt_descriptor_table)

Interrupts are used to respond to signals.
Two sources of interrupts are recognized by IA32: maskable interrupts, for
which vectors are determined by the hardware, and non-maskable interrupts.

Exceptions are either processor-detected of thrown by software.

Interrupts can be fired by Interrupt reuests (IRQs) or by the `int`
instruction.
Each interrupt or exception is associated to a number or vector.
The interrupt descriptor table structure will then tell the processor what
vector corresonds to what interrupt handler to take care of the interrupt
signal.

## Interrupt vector table
In real mode, the interrupt table is termed the interrupt vector table (IVT).
The IVT resides in memory in the location between `0x0000` and `0x03ff` 
(1023 in decimenal).
This range of memory consists of 256 4-byte real mode far pointers (256 * 4 = 1024).

The first 32 vectors are reserved for the processor's internal exceptions.
Hardware interrupts may be mapped to any of the vectors.

## References
* [Programming from the ground up](https://www.amazon.com/Programming-Ground-Up-Jonathan-Bartlett/dp/1616100648)

* [Linux system calls](https://www.linuxjournal.com/article/4048)

* `man 2 syscall`

* [Linux system call reference](https://syscalls.kernelgrok.com/)

* [int 0x10](https://en.wikipedia.org/wiki/INT_10H)
