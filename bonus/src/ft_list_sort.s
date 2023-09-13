section .text
        global ft_list_sort

ft_list_sort:
        push rbp
        mov rbp, rsp
        sub rsp, 0x8
        push rbx
        push r12
        push r13

        mov r12, [rdi]
        mov rbx, rsi

        .loop:
                test r12, r12
                jz .exit

                mov r13, r12
                call cmp_elements

                mov rax, [r12 + 0x8]
                mov r12, rax
                jmp .loop

        .exit:
                pop r13
                pop r12
                pop rbx
                mov rsp, rbp
                pop rbp
                ret

cmp_elements:
        .loop:
                mov rax, [r13 + 0x8]
                mov r13, rax

                test r13, r13
                jz .exit

                mov qword rdi, [r13]
                mov qword rsi, [r12]
                call rbx

                test rax, rax
                jns .loop

        .is_lower:
                mov qword r8, [r12]
                mov qword r9, [r13]
                mov [r12], r9
                mov [r13], r8
                jmp .loop

        .exit:
                ret
