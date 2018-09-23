# [Smash the stack](https://insecure.org/stf/smashstack.html)

## The stack region

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


After this we allocate space for local variables by subtracting their size from
the stack pointer (stack grows downward)
```assembly
subq $48, %rsp
```

The 48 comes from the fact that memory can only be addressed in multiples of a
word (in our case 4 bytes). 
So `char buffer2[10]` which holds 10 bytes will be allocaed in a space space of
12 bytes.
`char buffer[5]`, which holds 5 bytes will be allocated 8 bytes.
This thus far makes 20 bytes.

Now recall the cfa offsets declared at the prologe: we saved the frame pointer
(`pushq %rbp` - 8 bytes), and then we have the return address (the `call` 
insruction saves the address of the next instruction) which is another 8 bytes.

Finally, we have 3 arguments, `a`, `b`, and `c` which are each allocated 4
bytes.

This all totalling to 48 bytes.


<!-- --------------------------------------------------------------------- -->
## Buffer overflows

Running `example2.c` will give you this output
```
$ ./a.out
*** stack smashing detected ***: <unknown> terminated
Aborted (core dumped)
```


If you notice, in he assembly version of `example-2`, when we call `function`,
we have:
```assembly
movq    %rax, %rdi
call    function
```

So, for starters, when whe pass `char *str`, we make use of the 64-bit version
of the register instead of the 32-bit version as before, `rdi` versus `edi`
respectively.

Hence, the stack lay out will constitute of 16 bytes at the bottom for
`buffer[]`, 8 bytes for `sfp`, 8 bytes for `ret`.
This comes to a total of 40 bytes. 
However, if we see the actual assembly for `function` we see something like the
follwoing:
```assembly
function:                                                                       
    pushq   %rbp                                                                
    movq    %rsp, %rbp                                                          
    subq    $48, %rsp                                                           
    movq    %rdi, -40(%rbp)                                                     
    movq    %fs:40, %rax                                                        
    movq    %rax, -8(%rbp)                                                      
    xorl    %eax, %eax                                                          
    movq    -40(%rbp), %rdx                                                     
    leaq    -32(%rbp), %rax                                                     
    movq    %rdx, %rsi                                                          
    movq    %rax, %rdi                                                          
    call    strcpy@PLT                                                          
    nop                                                                         
    movq    -8(%rbp), %rax                                                      
    xorq    %fs:40, %rax                                                        
    je  .L2                                                                     
    call    __stack_chk_fail@PLT                                                
.L2:                                                                            
    leave                                                                       
    ret                                                                         
```

We see the function prologe followed by the instruction `subq $48, %rsp`.
ThThere are 48 bytes being given to the stack when we expected to use only 40!
But, if you notice how we prepare the stack for the call to `strcpy@PLT` you'll
see that we need the extra 8 bytes to 

We save the argument being passed to `function` into the stack, `movq rdi,
-40(%rbp)`. 
After this, we pass the reference to the argument from the stack to `rdx` and
then we pass the next 8 bytes from the stack as the first argument to
`strcpy@PLT`.
We need those 8 bytes extra to call another function.

Also, notice how the compiler seems to place a stack guard in `%fs:40`. This is
what allows the system to know when the stack is overflowing
(`__stack_ch_fail@PLT`).

Back to the core dump.
`strcpy` will try to copy the contents from `large_string` to `buffer[]`.
This will cause 250 past `buffer[]` to be overwritten with the contents of
`large_string`, this includes `sfp`, `ret`, and `large_string` itself.
Since all the entries in `large_string` were the character A (`0x41` or `65`).
This will make the return address `0x41414141` which will be outside of the
processes' address space.

By changing the return address in this way we can conntrol the execution flow.


```
Dump of assembler code for function function:
   0x0000051d <+0>:	push   ebp
   0x0000051e <+1>:	mov    ebp,esp
   0x00000520 <+3>:	sub    esp,0x20
   0x00000523 <+6>:	call   0x59f <__x86.get_pc_thunk.ax>
   0x00000528 <+11>:	add    eax,0x1ab0
   0x0000052d <+16>:	lea    eax,[ebp-0xc]
   0x00000530 <+19>:	add    eax,0x10
   0x00000533 <+22>:	mov    DWORD PTR [ebp-0x4],eax
   0x00000536 <+25>:	mov    eax,DWORD PTR [ebp-0x4]
   0x00000539 <+28>:	mov    eax,DWORD PTR [eax]
   0x0000053b <+30>:	lea    edx,[eax+0x8]
   0x0000053e <+33>:	mov    eax,DWORD PTR [ebp-0x4]
   0x00000541 <+36>:	mov    DWORD PTR [eax],edx
   0x00000543 <+38>:	nop
   0x00000544 <+39>:	leave
   0x00000545 <+40>:	ret
```

`0x0000052d` tells us that `buffer1` is at `ebp-0xc`, and `0x00000533` tells us
`ret` is at `ebp-0x4`
