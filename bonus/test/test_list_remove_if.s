section .data
        level5 db NL, 'Level 5 - list_remove_if(<list_begin>, <cmp_ref>, <ft_cmp>, <fr_free>): Remove an <element> from the list if ft_cmp(<element>, <cmp_ref>) returns 0', NL, 'No input + ENTER => launch function with the current list', NL, 0
        level5_len equ $ - level5
        level5_input1 db '<new_data>: ', 0
        level5_input1_len equ $ - level5_input1

        level5_msg1 db 'List content:', NL, 0
        level5_msg1_len equ $ - level5_msg1

        format_list_remove_if db '%s', 0

        cmp_ref db '42', 0

section .text
        global test_list_remove_if

        extern ft_list_remove_if
        extern ft_list_push_front

test_list_remove_if:
        FT_ENTER

        WRITE level5, level5_len
        RET_TEST

        xor r12, r12

        .loop:
                xor r13, r13
                cmp r12, 0x29
                ja .prepare_print

                WRITE level5_input1, level5_input1_len
                test rax, rax
                js .free_list

                READ buffer1, BUFFER_SIZE - 1
                test rax, rax
                js .free_list
                jz .free_list
                mov r13, rax
                TCFLUSH

                cmp r13, 0x1
                jne .prepare_push
        
                cmp byte [buffer1], 0xa
                je .prepare_print

        .prepare_push:
                sub rsp, BUFFER_SIZE
                xor rcx, rcx

        .push_buffer:
                mov al, [buffer1 + rcx]
                mov [rsp + rcx], al

                inc rcx
                test al, al
                jnz .push_buffer
                mov byte [rsp + rcx], 0x0

                inc r12
                BZERO buffer1, r13
                xor r13, r13

                lea rdi, [list_begin]
                lea rsi, [rsp]
                call ft_list_push_front
                test rax, rax
                js .free_list

                jmp .loop
        
        .prepare_print:
                lea rdi, [list_begin]
                lea rsi, [cmp_ref]
                lea rdx, [ft_cmp]
                lea rcx, [ft_free]
                call ft_list_remove_if

                mov rax, [list_begin]
                mov [list_ptr], rax

                xor r13, r13
                WRITE level5_msg1, level5_msg1_len
                test rax, rax
                js .free_list

        .print_list:
                inc r13
                cmp qword [list_ptr], 0x0
                je .free_list
                dec r13

                mov rbx, [list_ptr]

                PRINTF format_list_remove_if, [rbx]
                test rax, rax
                js .free_list

                mov rax, [rbx + Node.next]
                mov [list_ptr], rax
                jmp .print_list

        .free_list:
                cmp qword [list_begin], 0x0
                je .list_ended

                mov rax, [list_begin]

                mov rbx, [rax + Node.next]
                mov [list_begin], rbx

                mov rdi, rax
                call free
                jmp .free_list

        .list_ended:
                BZERO buffer1, r13
                test r13, r13
                jnz .loop

                WRITE just_nl, 0x1
                test rax, rax
                js .free_list

        .exit:
                FT_LEAVE
                ret

ft_cmp:
        push rbp
        mov rbp, rsp
        push rdi

        mov rdi, rsi
        call ft_strlen
        mov r10, rax

        mov rax, 0x1
        pop rdi

        .loop:
                movzx r8, byte [rdi]
                movzx r9, byte [rsi]

                test r8, r8
                jz .exit
                test r9, r9
                jz .exit

                cmp r8, r9
                jne .new_loop

                mov rcx, 0x1

        .is_equal:
                mov dl, [rsi + rcx]
                cmp [rdi + rcx], dl
                jne .new_loop

                dec rax
                dec r10
                cmp rcx, r10
                je .exit
                inc r10
                inc rax

                inc rcx
                jmp .is_equal

        .new_loop:
                inc rdi
                jmp .loop

        .exit:
                mov rsp, rbp
                pop rbp
                ret

ft_free:
        push rbp
        mov rbp, rsp

        mov rax, [list_begin]
        xor r8, r8

        .loop:
                cmp qword [rax], rdi
                je .remove_it

                mov r8, rax
                mov rdx, [rax + Node.next]
                mov rax, rdx
                jmp .loop

        .remove_it:
                mov rdx, [rax + Node.next]

                test r8, r8
                jz .update_list_begin

                mov [r8 + Node.next], rdx
                jmp .free_now

        .update_list_begin:
                mov [list_begin],  rdx

        .free_now:
                mov rdi, rax
                call free

        .exit:
                mov rsp, rbp
                pop rbp
                ret

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