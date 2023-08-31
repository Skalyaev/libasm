section .text
    global ft_strcmp

ft_strcmp:
    push rbp
    mov rbp, rsp
    push rbx

    .loop:
        movzx rax, byte [rdi]
        movzx rbx, byte [rsi]

        cmp rax, rbx
        jne .exit

        test rax, rax
        jz .exit

        inc rdi
        inc rsi
        jmp .loop

    .exit:
        sub rax, rbx
        pop rbx
        mov rsp, rbp
        pop rbp
        ret
