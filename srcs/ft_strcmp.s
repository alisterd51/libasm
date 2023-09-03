    section .text
    global ft_strcmp

ft_strcmp:
    push    rcx
    mov     rcx, 0

.LBB_loop:
    mov     al, byte [rsi + rcx]
    cmp     al, byte [rdi + rcx]
    jne     .LBB_choice
    cmp     al, 0
    je     .LBB_choice
    inc     rcx
    jmp     .LBB_loop
.LBB_choice:
    jg      .LBB_inf
    jl      .LBB_sup
    mov     rax, 0
    jmp     .LBB_end
.LBB_inf:
    mov     rax, -1
    jmp     .LBB_end
.LBB_sup:
    mov     rax, 1
.LBB_end:
    pop     rcx
    ret

    section .note.GNU-stack noalloc noexec nowrite progbits
