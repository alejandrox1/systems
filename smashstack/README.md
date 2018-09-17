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


### function
If you notice, we start the function declaration using cfi directive
`.cfi_startproc`.
This directive is used at the begining of each function that is to have an
entry in `.eh_frame`.
The directive initializes internal data structures.

Any function that starts with a `.cf_startproc` must end with a `.cfi_endproc`.


Since a `call` insructions saves the addess of the instruction to be executed
after a call onto the stack, we need to save this value by pushing a quad
(64 bits) onto the stack (assuming an x86-64 arch)
```assembly
pushq %rbp
```

> Here we will refer to registers by numbers: 1. rax(eax), 2. rcx(ecx), 3.
> rdx(edx), 4. rbx (ebx), 5. rsp (esp), 6. rbp (ebp), 7. rsi (esi), and 8. rdi
> (edi).

After this we see 
```assembly
.cfi_def_cfa_offset 16
```
This indicates that we need to use the new offset of 16 to compute the cfa. 
This is due to the fact that we have just stored another 8 bytes from the
return address already stored in the stack - hence the offset of 8 + 8 = 16
bytes.

```assembly
.cfi_offset 6, -16
```
Will save the value of register 6, `rbp`, at offset -16 from cfa.

Finally,
```assembly
movq %rsp, %rbp
```
Moves the value of the stack pointer to the stack base pointer, collapsing the
stack for the callee and
```assembly
.cfi_def_cfa_register 6
```
tells the system that the call frame address is at register 6, `rbp`.
