section .data
        level2 db NL, 'Level 2 - list_push_front(<list_begin>, <new_data>): Add <new_data> to the beginning of the linked list', NL, 0
        level2_len equ $ - level2
        level2_input1 db '<new_data>: ', 0
        level2_input1_len equ $ - level2_input1

        level2_msg1 db 'List content:', NL, 0
        level2_msg1_len equ $ - level2_msg1

        test_done_msg db 'Done!', NL, 0
        test_done_msg_len equ $ - test_done_msg

        format_list_push_front db '%s', 0

section .text
        global test_list_push_front

        extern ft_list_push_front

test_list_push_front:
        FT_ENTER

        WRITE level2, level2_len
        RET_TEST

        WRITE null_test_msg, null_test_msg_len
        RET_TEST

        lea rdi, 0x0
        lea rsi, 0x0
        call ft_list_push_front
        WRITE test_done_msg, test_done_msg_len
        RET_TEST

        xor r12, r12
        xor r13, r13

        .loop:
                cmp r12, 0x29
                ja .free_list

                WRITE level2_input1, level2_input1_len
                test rax, rax
                js .free_list

                READ buffer1, BUFFER_SIZE - 1
                test rax, rax
                js .free_list
                jz .free_list
                mov r13, rax
                TCFLUSH

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

                mov rax, [list_begin]
                mov [list_ptr], rax

                WRITE level2_msg1, level2_msg1_len
                test rax, rax
                js .free_list

        .print_list:
                cmp qword [list_ptr], 0x0
                je .loop

                mov rbx, [list_ptr]

                PRINTF format_list_push_front, [rbx]
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
                test r13, r13
                jnz .loop

                WRITE just_nl, 0x1
                test rax, rax
                js .free_list

        .exit:
                FT_LEAVE
                ret