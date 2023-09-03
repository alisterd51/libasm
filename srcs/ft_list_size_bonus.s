    section .text
    global ft_list_size

ft_list_size:
    mov     rax, 0
.LBB_loop:
    cmp     rdi, 0
    je      .LBB_end
    mov     rdi, [rdi + 8]
    inc     rax
    jmp     .LBB_loop
.LBB_end:
    ret

    section .note.GNU-stack noalloc noexec nowrite progbits
