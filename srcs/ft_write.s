    section .text
    extern __errno_location
    global ft_write

ft_write:
    push    r8
    mov     rax, 1
    syscall
    cmp     rax, 0
    jge     .LBB_end
    mov     r8, rax
    neg     r8
    call    __errno_location wrt ..plt
    mov     [rax], r8
    mov     rax, -1
.LBB_end:
    pop     r8
    ret

    section .note.GNU-stack noalloc noexec nowrite progbits
