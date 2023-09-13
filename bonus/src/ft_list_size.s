section .text
        global ft_list_size

ft_list_size:
        push rbp
        mov rbp, rsp

        mov r8, [rdi]
        xor rax, rax

        .loop:
                test r8, r8
                jz .exit

                mov r9, [r8 + 0x8]
                mov r8, r9
                inc rax
                jmp .loop

        .exit:
                mov rsp, rbp
                pop rbp
                ret