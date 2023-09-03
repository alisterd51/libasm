    section .text
    extern malloc
    extern ft_strlen
    extern ft_strcpy
    global ft_strdup

ft_strdup:
    call    ft_strlen
    push    rdi
    mov     rdi, rax
    inc     rdi
    call    malloc wrt ..plt
    cmp     rax, 0
    je      .LBB_end
    pop     rsi
    mov     rdi, rax
    call    ft_strcpy
.LBB_end:
    ret

    section .note.GNU-stack noalloc noexec nowrite progbits
