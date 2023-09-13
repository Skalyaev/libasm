section .text
        global ft_list_remove_if

ft_list_remove_if:
        push rbp
        mov rbp, rsp
        sub rsp, 0x8
        push rbx
        push r12
        push r13
        push r14
        push r15

        mov rbx, rdi
        mov r12, [rdi]
        mov r13, rsi
        mov r14, rdx
        mov r15, rcx

        .loop:
                test r12, r12
                jz .exit

                mov rdi, [r12]
                mov rsi, r13
                call r14
                test rax, rax
                jnz .new_loop

                mov rdi, [r12]
                call r15
                mov r12, [rbx]
                jmp .loop

        .new_loop:
                mov rax, [r12 + 0x8]
                mov r12, rax
                jmp .loop

        .exit:
                pop rbx
                pop r15
                pop r14
                pop r13
                pop r12
                mov rsp, rbp
                pop rbp
                ret