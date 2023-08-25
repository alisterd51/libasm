    .text
    .intel_syntax noprefix
    .globl ft_strlen

ft_strlen:
    mov rax, 0
.LBB_loop:
    cmp byte ptr [rdi + rax], 0
    je  .LBB_end
    inc rax
    jmp .LBB_loop
.LBB_end:
    ret
.end:
    .section    ".note.GNU-stack","",@progbits
