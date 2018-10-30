# Terminate and set the exit code,
#
# To view the exit code, type `echo $?` right after running this program.
.section .data

.section .text
.globl _start
_start:

# Syscall for exiting a program.
movl $1, %eax 

# Exit code to be returned.
movl $77, %ebx 


int $0x80
