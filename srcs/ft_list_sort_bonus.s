    .text
    .intel_syntax noprefix
    .globl ft_list_sort

ft_list_sort:
    push    rax
    mov     r15, rdi # r15 est **begin_list
    mov     r14, [rdi] # r14 est *begin_list
.LBB_loop:
    mov     rdi, r14
    call    .ft_list_sorted
    cmp     rax, 1
    je      .LBB_end
.LBB_loop_loop:
    
 

.LBB_end:
    mov     [r15], r14 # r15 est **begin_list et r14 est debut chaine
    pop     rax
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
    cmp     qword ptr [rdi + 8], 0
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

.end:
    .section    ".note.GNU-stack","",@progbits
