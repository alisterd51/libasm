    .text
    .intel_syntax noprefix
    .globl ft_strcpy

ft_strcpy:
    push    rcx
    mov     rcx, 0
.LBB_loop:
    mov     al, [rsi + rcx]
    cmp     al, 0
    je      .LBB_end
    mov     [rdi + rcx], al
    inc     rcx
    jmp     .LBB_loop
.LBB_end:
    mov     byte ptr [rdi + rcx], 0
    mov     rax, rdi
    pop     rcx
    ret
.end:
    .section    ".note.GNU-stack","",@progbits
