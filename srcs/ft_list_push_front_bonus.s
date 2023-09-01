    .text
    .intel_syntax noprefix
    .extern malloc
    .globl ft_list_push_front

ft_list_push_front:
    push    r15
    push    rdi
    mov     rdi, rsi
    call    .ft_list_new
    pop     rdi
    cmp     rax, 0
    je      .LBB_end
    mov     r15, [rdi]
    mov     [rax + 8], r15
    mov     [rdi], rax
.LBB_end:
    pop     r15
    ret

.ft_list_new:
    push    rdi
    mov     rdi, 16
    call    malloc
    pop     rdi
    cmp     rax, 0
    je      .ft_list_new_end
    mov     [rax], rdi
    mov     qword ptr [rax + 8], 0
.ft_list_new_end:
    ret

.end:
    .section    ".note.GNU-stack","",@progbits