    .text
    .intel_syntax noprefix
    .extern malloc
    .extern ft_strlen
    .extern ft_strcpy
    .globl ft_strdup

ft_strdup:
    call    ft_strlen
    push    rdi
    mov     rdi, rax
    inc     rdi
    call    malloc
    cmp     rax, 0
    je      .LBB_end
    pop     rsi
    mov     rdi, rax
    call    ft_strcpy
.LBB_end:
    ret
.end:
    .section    ".note.GNU-stack","",@progbits
