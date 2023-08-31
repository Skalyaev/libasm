section .text
        global ft_strcpy

ft_strcpy:
        push rbp
        mov rbp, rsp
        push rbx
        mov rax, rdi

        .loop:
                cmp byte [rsi], 0
                je .fill

                mov bl, [rsi]
                mov [rdi], bl

                inc rdi
                inc rsi
                jmp .loop

        .fill:
                cmp byte [rdi], 0
                je .exit

                mov byte [rdi], 0
                inc rdi
                jmp .fill

        .exit:
                pop rbx
                mov rsp, rbp
                pop rbp
                ret