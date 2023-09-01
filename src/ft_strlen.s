section .text
        global ft_strlen

ft_strlen:
        push rbp
        mov rbp, rsp

        xor rax, rax

        .loop:
                cmp byte [rdi], 0
                je .exit

                inc rdi
                inc rax
                jmp .loop

        .exit:
                mov rsp, rbp
                pop rbp
                ret
