;
; Simple boot sector that loops forever.
;
loop:
    jmp loop

; A sector is 512 bytes long. We need to place the magic number 0xaa55 at the
; end of the sector. In the BIOS world we work in 16-bit (2 byte) chunks. 
; A little trick to keep in mind is that each digit in hex corresponds to 4 
; bits (2^4 = 16). So our magic number which has four digits will take 16 bits
; (2 bytes).
times 510-($-$$) db 0

dw 0xaa55
