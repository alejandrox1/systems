# AT&T syntax

GCC uses AT&T assembly syntax (instruction source, destination).


The general form of a memory address follows the format
```
ADDRESS_OR_OFFSET(%BASE_OR_OFFSET,%INDEX,MULTIPLIER)
```

A `MULTIPLIER` of 1, 2, or 4 will access bytes, double-bytes, or words,
respectively.

So, the resulting address is calculated as
```
ADDRESS = ADDRESS_OR_OFFSET + %BASE_OR_OFFSET + MULTIPLIER * %INDEX
```


### Addressing modes
Addressing modes in AT&T syntax have the following structure.

**Direct addressing mode**

```assembly
movl ADDRESS, %eax
```
This loads the register `eax` with the value at the memory address `ADDRESS`.



**Index addressing mode**

This one uses `ADDRESS_OR_OFFSET` along with `%INDEX`.

Suppose we have a string of bytes as `string_start` and wanted to access the
third entry (index 2), and the register `ecx` held the value 2. 
If we wanted to load the third entry into register `eax` we could do it as such
```assembly
movl string_start(,%ecx,1). %eax
```
Thi starts at `string_start` and adds `1 * %ecx`, and loads the resulting
address into `%eax`.


**Indirect addressing mode**

Indirect addressing mode loads a value from the address indicated by a
register. For example, if register `eax` holds an address, we could move that
value at register `ebx` as follows:
```assembly
movl (%eax), %ebx
```



**Base pointer addressing mode**

Similar to index addressing, except it adds a contant value to the address in
the register.
Suppose we have a record and you want to see the value at an offset of 4 bytes
from the begining of the record. The address of the begining of the record is
in the register `eax`. So, we can retrieve the value into register `ebx` like
this:
```assembly
movl 4(%eax), %ebx
```


**Immediate mode**

In this mode we will load actual values into registers or memory addresses.
To save the number 1 into register `eax`
```assembly
movl $1, %eax
```


**Register addressing mode**

This moves data from a register to another.
```assembly
movl %eax, %ebx
```

### Syntax

* Lines begining with periods are **assembler directives** (i.e., `.file`).
These are commands that instruct the assembler how to do the job.
The way directives work is by creating an entry in the symbol table.

* Lines that begin with text and are followed by a colon are **labels** 
(i.e., `main:`).






### GAS

## Call stack

The call stack is a stack data structure tha stores information about the
active subroutines of a computer program 
[call stack](https://en.wikipedia.org/wiki/Call_stack).

The call stack is composed of stack frames. 
These are machine dependent and ABI dependent stat strcutures containing
subroutine state information 
[call stack structure](https://en.wikipedia.org/wiki/Call_stack#Structure).
This data is sometimes refered to as **CFI** (call frame information).


### CFI directives

One huge reason for cfi directives and call stacks is the ability to do stack
traces. 
Recall the **procedure prolog** and the **procedure epilog** will look
something like this (IA-32)
```assembly
push %ebp
movl %esp, %ebp

/*
instrcutions...
*/

popl %ebp
ret
```

Following the system v abi on an intel x86-64 processor, you may also see something like this
```assembly
pushq   %rbp
movq    %rsp, %rbp

# some instructions

leave
ret
```

With this setup a debugger can unwind the call stack.


If you recall elf (Executable and Linkable Format) is a common standard file
format for executable files, object code, shared libraries, and core dumps.
Related to elf, is the dwarf. Dwarf is a standardized format for debugging
data. Both of these were introduced with the system v abi.

Dwarf defines a `.debug_frame` section where we can use `ebp` as a regular
register but when the stete of the `esp` register is saved then a note must go
along with it in the `.debug_frame` section dictating what instructions it is
saving and where.

For exception handling, modern linux systems use an `.eh_frame` section. 
`.eh_frame` build upon `.debug_frame` but it also includes language-specific
information, it has a more compact encoding, and it is loaded with the proram
upon execution.

A problem shared by both of these is that the most direct way of producing them
is by using a long table. One problem with a table is that the compiler won't
know the exact size of the code, hence making the encoding less efficient.

CFI directives are a step up from both of these approaches.
CFI directives provide the assembler with an overview of whats happening and
let the assembler do the table generation. This is a big step since the
assembler, unlike the compiler, will know the exact sizes of it all.

The compiler uses the `.cfi_sections` directive to tell the assembler whether
it needs a `.debug_frame` or a `.eh_frame`.
If the abi requires the file to handle execptions, or if a function needs this
functionality, then the assembler will generate a `.eh_frame`. 
For debugging, `.debug_frame` may be more useful.

The majority of the content on cfi directives was taken from
[cfi directives](http://web.archive.org/web/20130111101034/http://blog.mozilla.org/respindola/2011/05/12/cfi-directives).


Now that we are familiar with the call stack let's go into details. 
Each frame is identified by an address on the stack, the canonical frame
address, or CFA
[dwarf debugging standards](http://dwarfstd.org/Download.php).


For more information on cfi directives, see the actual documentation
[as](https://sourceware.org/binutils/docs/as/CFI-directives.html).
