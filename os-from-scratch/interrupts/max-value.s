# Find the maximum value of an "array."
#
# Registers are being used as follows:
#   %edi - Holds the index of the data item being looked at.
#   %eax - Current data item.
#   %ebx - Is the largest data item found so far.
#
# data_items - Memory address of data. Null byte (0) is used to signal end of
#              collection.
.section .data

data_items:
.long 3, 67, 34, 223, 45, 75, 54, 34, 0

.section .text
.globl _start
_start:

# Iterate through data, begining with first position.
movl $0, %edi
movl data_items(, %edi, 4), %eax    # Each long is 4 bytes.
movl %eax, %ebx

start_loop:
    cmpl $0, %eax                   # Check if we reached.
    je loop_exit

    incl %edi
    movl data_items(, %edi, 4), %eax

    cmpl %ebx, %eax
    jle start_loop

    movl %eax, %ebx
    jmp start_loop

loop_exit:
    movl $1, %eax                   # exit syscall (exit value goes on %ebx).
    int $0x80
