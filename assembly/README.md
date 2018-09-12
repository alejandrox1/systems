## AT&T syntax

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
