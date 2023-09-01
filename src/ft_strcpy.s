section .text
        global ft_strcpy

ft_strcpy:
        push rbp
        mov rbp, rsp

        mov rax, rdi

        .loop:
                cmp byte [rsi], 0
                je .exit

                mov r8b, [rsi]
                mov [rdi], r8b

                inc rsi
                inc rdi
                jmp .loop

        .exit:
                mov byte [rdi], 0

                mov rsp, rbp
                pop rbp
                ret