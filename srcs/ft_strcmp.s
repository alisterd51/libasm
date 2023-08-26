    .text
    .intel_syntax noprefix
    .globl ft_strcmp

ft_strcmp:
    push    rcx
    mov     rcx, 0

.LBB_loop:
    mov     al, byte ptr [rsi + rcx]
    cmp     al, byte ptr [rdi + rcx]
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
.end:
    .section    ".note.GNU-stack","",@progbits
