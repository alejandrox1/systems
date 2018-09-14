# [Smash the stack](https://insecure.org/stf/smashstack.html)

Keep in mind that GCC will use AT&T assembly syntax (instruction source,
destination). If you need a refresher on assembly see
[assembly](../assembly/README.md).

By looking at the assembly of example1, `make example-1`, we see the call to
`function()` is translated to:
```assembly
movl    $3, %edx
movl    $2, %esi
movl    $1, %edi
call    function
```

A thing I should mention here is that this whole thing is being done on Debian.
Debian has a Linux kernel. Furthermore, now a days mostcomputers have a core iX
or a Xeon processor which uses x86-64 instruction set. 
All this, indicates that I am most likely in the use of the [system v
abi](https://wiki.osdev.org/System_V_ABI#Calling_Convention).

The calling convention for the system v abi is to put function parameters in
registers rdi, rsi, rdx, and rcx. In IA-32 you may recognize these registers as
edi, esi, edx, and ecx.
For more info, see 
[x86 calling conventions](https://en.wikipedia.org/wiki/X86_calling_conventions).


### Preamble
`.file "example1.c"` creates an entry in the symbol table specifying that
example1.c is associated with the object file.

The `.text` directive declares the begining of the `.text` section (the place
where instruction go, usually read-only).

The directive `.globl` defines the function `function` as a global symbol. 
A global symbol definition in one file satisfies an undefined reference to the
same global symbol in another file.

`.type function, @function` declares the the symbol `function` as a `@function`
type.



