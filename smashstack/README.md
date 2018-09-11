# [Smash the stack](insecure.org/stf/smashstack.html)


By looking at the assembly of example1, `make example-1`, we see the call to
`function()` is translated to:
```assembly
movl    $3, %edx
movl    $2, %esi
movl    $1, %edi
call    function
```

Keep in mind that GCC will use AT&T assembly syntax (instruction source, 
destination).

The general form of a memory address follows the format
```
ADDRESS_OR_OFFSET(%BASE_OR_OFFSET,%INDEX,MULTIPLIER)
```

A `MULTIPLIER` of 1, 2, or 4 will access bytes, double-bytes, or words,
respectively.



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
