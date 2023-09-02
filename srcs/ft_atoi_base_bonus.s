    .text
    .intel_syntax noprefix
    .extern ft_strlen
    .globl ft_atoi_base

ft_atoi_base:
    push    r15
    push    r14
    push    r13
    push    r12
    push    r11
    push    r10
    push    r9
    push    r8
    push    rdx
    push    rcx
.LBB_invalid_strlen:
    push    rdi
    mov     rdi, rsi
    call    ft_strlen
    pop     rdi
    cmp     rax, 1
    jle     .LBB_error_base
.LBB_invalid_duplicate_char:
# pour chaque char de base, on regarde la suite de la base
    mov     rcx, 0
.LBB_invalid_duplicate_char_loop:
    cmp     byte ptr [rsi + rcx], 0
    je      .LBB_invalid_duplicate_char_loop_end
    #
    mov     r14, rcx
.LBB_invalid_duplicate_char_loop_loop:
    cmp     byte ptr [rsi + r14 + 1], 0
    je      .LBB_invalid_duplicate_char_loop_loop_end

    # test si doublon
    mov     al, byte ptr [rsi + rcx]
    cmp     byte ptr [rsi + r14 + 1], al
    je      .LBB_error_base

    inc     r14
    jmp     .LBB_invalid_duplicate_char_loop_loop
.LBB_invalid_duplicate_char_loop_loop_end:
    #
    inc     rcx
    jmp     .LBB_invalid_duplicate_char_loop
.LBB_invalid_duplicate_char_loop_end:
.LBB_invalid_char:
    mov     rcx, 0
.LBB_invalid_char_loop:
    cmp     byte ptr [rsi + rcx], 0
    je      .LBB_invalid_char_loop_end
    cmp     byte ptr [rsi + rcx], 32
    je      .LBB_error_base
    cmp     byte ptr [rsi + rcx], 12
    je      .LBB_error_base
    cmp     byte ptr [rsi + rcx], 10
    je      .LBB_error_base
    cmp     byte ptr [rsi + rcx], 13
    je      .LBB_error_base
    cmp     byte ptr [rsi + rcx], 9
    je      .LBB_error_base
    cmp     byte ptr [rsi + rcx], 11
    je      .LBB_error_base
    cmp     byte ptr [rsi + rcx], 45
    je      .LBB_error_base
    cmp     byte ptr [rsi + rcx], 43
    je      .LBB_error_base
    inc     rcx
    jmp     .LBB_invalid_char_loop
.LBB_invalid_char_loop_end:
.LBB_skip_space:
    cmp     byte ptr [rdi], 32
    je      .LBB_skip_one_space
    cmp     byte ptr [rdi], 12
    je      .LBB_skip_one_space
    cmp     byte ptr [rdi], 10
    je      .LBB_skip_one_space
    cmp     byte ptr [rdi], 13
    je      .LBB_skip_one_space
    cmp     byte ptr [rdi], 9
    je      .LBB_skip_one_space
    cmp     byte ptr [rdi], 11
    je      .LBB_skip_one_space
    jmp     .LBB_skip_sign
.LBB_skip_one_space:
    inc     rdi
    jmp     .LBB_skip_space
.LBB_skip_sign:
    mov     r14, 1 # ici r14 represente le signe
.LBB_skip_sign_loop:
    cmp     byte ptr [rdi], 43
    je      .LBB_skip_sign_loop_continue
    cmp     byte ptr [rdi], 45
    je      .LBB_skip_sign_loop_neg
    jmp     .LBB_loop_atoi
.LBB_skip_sign_loop_neg:
    neg     r14
.LBB_skip_sign_loop_continue:
    inc     rdi
    jmp     .LBB_skip_sign_loop
.LBB_loop_atoi:
    mov     r12, 0  # r12 est le resulat en cours du atoi
.LBB_loop_atoi_loop:
    # str[i] != '\0'
    cmp     byte ptr [rdi], 0
    je      .LBB_end_succes

    mov     r11, rdi # r11 devient str
    mov     r10, rsi # r10 devient base
    mov     rdi, r10
    mov     dl, byte ptr [r11]
    mov     rsi, rdx
    call    .ft_strchr

    mov     rdi, r11
    mov     rsi, r10

    # strchr(base, str[i]) != NULL
    cmp     rax, 0
    je      .LBB_end_succes

    # strchr(base, str[i]) != base + strlen(base)
    mov     r9, rax # r9 devient le retour de strchr

    mov     rdi, rsi
    call    ft_strlen
    mov     r8, rax # r8 devient une sauvegarde du strlen(base)
    add     rax, rdi
    cmp     rax, r9

    mov     rdi, r11
    mov     rsi, r10

    je      .LBB_end_succes

    # if LONG_MAX / strlen(base) + (int)(strchr(base, str[i]) - base) < ret_value
    mov     rax, 9223372036854775807
    mov     rdx, 0
    idiv    r8
    sub     r9, r10 # r9 devient strchr(base, str[i]) - base
    add     rax, r9
    cmp     rax, r12
    jl      .LBB_error_overflow

    # ret_value = ret_value * strlen(base) + (int)(strchr(base, str[i]) - base)
    imul    r12, r8
    add     r12, r9

    inc     rdi
    jmp     .LBB_loop_atoi_loop

.LBB_end_succes:
    mov     rax, r12

    # apply sign
    cmp     r14, 1
    je      .LBB_end
    neg     rax
    jmp     .LBB_end
.LBB_error_overflow:
.LBB_error_base:
    mov     rax, 0
.LBB_end:
    pop     rcx
    pop     rdx
    pop     r8
    pop     r9
    pop     r10
    pop     r11
    pop     r12
    pop     r13
    pop     r14
    pop     r15
    ret

.ft_strchr:
    mov     dl, byte ptr [rdi]
    cmp     dl, 0
    je      .LBB_ft_strchr_end
    cmp     rdx, rsi
    je      .LBB_ft_strchr_end
    inc     rdi
    jmp     .ft_strchr
.LBB_ft_strchr_end:
    mov     rax, rdi
    ret

    .section    ".note.GNU-stack","",@progbits
