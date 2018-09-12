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
destination). If you need a refresher on assembly see
[assembly](../assembly/README.md).
