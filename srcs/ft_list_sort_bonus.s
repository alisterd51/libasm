    section .text
    global ft_list_sort

ft_list_sort:
    push    r15
    push    r14
    push    r13
    push    r12
    push    r11
    push    r10
    push    r9
    push    rax
    mov     r15, rdi
.LBB_1:
    mov     rdi, [r15]
    call    .ft_list_sorted
    cmp     rax, 0
    jne     .LBB_1_end
    mov     r14, 0
    mov     r13, [r15]
.LBB_2:
    cmp     r13, 0
    je      .LBB_2_end
    cmp     qword 8[r13], 0
    je      .LBB_2_end
    mov     r12, rsi
    mov     rdi, 0[r13]
    mov     rsi, 8[r13]
    mov     rsi, 0[rsi]
    call    r12
    mov     rsi, r12
    cmp     eax, 0
    jle     .LBB_3
    mov     r11, 8[r13]
    mov     r11, 8[r11]
    cmp     r14, 0
    jne     .LBB_4
    mov     r10, 8[r13]
    mov     [r15], r10
    jmp     .LBB_5
.LBB_4:
    mov     r9, 8[r13]
    mov     8[r14], r9
.LBB_5:
    mov     r9, 8[r13]
    mov     8[r9], r13
    mov     8[r13], r11
.LBB_3:
    mov     r14, r13
    mov     r13, 8[r13]
    jmp     .LBB_2
.LBB_2_end:
    jmp     .LBB_1
.LBB_1_end:
    mov     rdi, r15
    pop     rax
    pop     r9
    pop     r10
    pop     r11
    pop     r12
    pop     r13
    pop     r14
    pop     r15
    ret

.ft_list_sorted:
    push    r15
    push    r14
    push    r13
    push    r12
    mov     r13, rsi
    mov     r12, rdi
.ft_list_sorted_loop:
    cmp     rdi, 0
    je      .ft_list_sorted_end_true
    cmp     qword [rdi + 8], 0
    je      .ft_list_sorted_end_true
    mov     r15, 0[rdi]
    mov     r14, 8[rdi]
    mov     r14, 0[r14]
    push    rdi
    mov     rdi, r15
    mov     rsi, r14
    call    r13
    pop     rdi
    cmp     eax, 0
    jg      .ft_list_sorted_end_false
    mov     rdi, [rdi + 8]
    jmp     .ft_list_sorted_loop
.ft_list_sorted_end_true:
    mov     rax, 1
    jmp     .ft_list_sorted_end
.ft_list_sorted_end_false:
    mov     rax, 0
.ft_list_sorted_end:
    mov     rdi, r12
    mov     rsi, r13
    pop     r12
    pop     r13
    pop     r14
    pop     r15
    ret

    section .note.GNU-stack noalloc noexec nowrite progbits
