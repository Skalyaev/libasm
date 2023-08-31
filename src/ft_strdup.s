section .text
    global ft_strdup

ft_strdup:
    push rbp
    mov rbp, rsp
    xor rax, rax

    .loop:
        cmp byte [rdi], 0
        je .exit

        inc rax
        inc rdi
        jmp .loop

    .exit:
        mov rsp, rbp
        pop rbp
        ret
