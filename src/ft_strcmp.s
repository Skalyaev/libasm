section .text
        global ft_strcmp

ft_strcmp:
        push rbp
        mov rbp, rsp

        .loop:
                movzx rax, byte [rdi]
                movzx r8, byte [rsi]

                cmp rax, r8
                jne .exit

                test rax, rax
                jz .exit

                inc rdi
                inc rsi
                jmp .loop

        .exit:
                sub rax, r8

                mov rsp, rbp
                pop rbp
                ret
