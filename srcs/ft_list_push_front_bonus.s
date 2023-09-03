    section .text
    extern malloc
    global ft_list_push_front

ft_list_push_front:
    push    rax
    push    r15
    push    rdi
    mov     rdi, rsi
    call    .ft_list_new
    pop     rdi
    cmp     rax, 0
    je      .LBB_end
    mov     r15, qword [rdi]
    mov     qword [rax + 8], r15
    mov     qword [rdi], rax
.LBB_end:
    pop     r15
    pop     rax
    ret

.ft_list_new:
    push    rdi
    mov     rdi, 16
    call    malloc wrt ..plt
    pop     rdi
    cmp     rax, 0
    je      .ft_list_new_end
    mov     qword [rax], rdi
    mov     qword [rax + 8], 0
.ft_list_new_end:
    ret

    section .note.GNU-stack noalloc noexec nowrite progbits
