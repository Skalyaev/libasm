section .data
        level3 db NL, 'Level 3 - list_size(<list_begin>): Return the number of elements in the list', NL, 'No input + ENTER => launch function with the current list', NL, 0
        level3_len equ $ - level3
        level3_input1 db '<new_data>: ', 0
        level3_input1_len equ $ - level3_input1

        format_list_size db '--> list_size: %d', NL, 0

section .text
        global test_list_size

        extern ft_list_size
        extern ft_list_push_front

test_list_size:
        FT_ENTER

        WRITE level3, level3_len
        RET_TEST

        xor r12, r12

        .loop:
                xor r13, r13
                cmp r12, 0x29
                ja .print_size

                WRITE level3_input1, level3_input1_len
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
                je .print_size

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

        .print_size:
                lea rdi, [list_begin]
                call ft_list_size
                PRINTF format_list_size, rax
                test rax, rax
                jns .free_list
                xor r13, r13

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