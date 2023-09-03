    section .text
    extern free
    global ft_list_remove_if

ft_list_remove_if:
    push    rax
    push    rbx
    push    r15
    push    r14
    push    r13
    push    r12
    push    r11
    push    r10
    push    r9
    mov     r15, 0
    mov     r14, [rdi]
.LBB_1:
    cmp     r14, 0
    je      .LBB_1_end
    mov     r13, 8[r14]
.LBB_2:
    mov     r12, rdx
    push    rdi
    push    rsi
    push    rdx
    push    rcx
    mov     rdi, 0[r14]
    call    r12
    pop     rcx
    pop     rdx
    pop     rsi
    pop     rdi
    cmp     eax, 0
    jne     .LBB_5
    push    rdi
    mov     rdi, 0[r14]
    mov     r12, rcx
    push    rsi
    push    rdx
    push    rcx
    call    r12
    pop     rcx
    pop     rdx
    pop     rsi
    mov     rdi, r14
    push    rsi
    push    rdx
    push    rcx
    call    free wrt ..plt
    pop     rcx
    pop     rdx
    pop     rsi
    pop     rdi
.LBB_3:
    cmp     r15, 0
    je      .LBB_4
    mov     8[r15], r13
.LBB_3_end:
    jmp     .LBB_4_end
.LBB_4:
    mov     0[rdi], r13
.LBB_4_end:
.LBB_2_end:
    jmp     .LBB_5_end
.LBB_5:
    mov     r15, r14
.LBB_5_end:
    mov     r14, r13
    jmp     .LBB_1
.LBB_1_end:
    pop     r9
    pop     r10
    pop     r11
    pop     r12
    pop     r13
    pop     r14
    pop     r15
    pop     rbx
    pop     rax
    ret

    section .note.GNU-stack noalloc noexec nowrite progbits
