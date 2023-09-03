    section .text
    global ft_strlen

ft_strlen:
    mov rax, 0
.LBB_loop:
    cmp byte [rdi + rax], 0
    je  .LBB_end
    inc rax
    jmp .LBB_loop
.LBB_end:
    ret

    section .note.GNU-stack noalloc noexec nowrite progbits
