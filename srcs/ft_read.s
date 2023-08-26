    .text
    .intel_syntax noprefix
    .extern __errno_location
    .globl ft_read

ft_read:
    push    r8
    mov     rax, 0
    syscall
    cmp     rax, 0
    jge     .LBB_end
    mov     r8, rax
    neg     r8
    call    __errno_location
    mov     [rax], r8
    mov     rax, -1
.LBB_end:
    pop     r8
    ret
.end:
    .section    ".note.GNU-stack","",@progbits
