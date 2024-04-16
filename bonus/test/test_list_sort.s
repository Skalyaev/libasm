section .data
        level4 db NL, "Level 4 - list_sort(<list_begin>, <ft_cmp>): Sort the elements of a list based on the <ft_cmp> function", NL, "No input + ENTER => launch function with the current list", NL, 0
        level4_len equ $ - level4
        level4_input1 db "<new_data>: ", 0
        level4_input1_len equ $ - level4_input1

        level4_msg1 db "List content:", NL, 0
        level4_msg1_len equ $ - level4_msg1

        format_list_sort db "%s", 0

section .text
        global test_list_sort

        extern ft_list_sort
        extern ft_list_push_front

test_list_sort:
        FT_ENTER

        WRITE level4, level4_len
        RET_TEST

        xor r12, r12

        .loop:
                xor r13, r13
                cmp r12, 0x29
                ja .prepare_print

                WRITE level4_input1, level4_input1_len
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
                lea rsi, [ft_strcmp]
                call ft_list_sort

                mov rax, [list_begin]
                mov [list_ptr], rax

                xor r13, r13
                WRITE level4_msg1, level4_msg1_len
                test rax, rax
                js .free_list

        .print_list:
                inc r13
                cmp qword [list_ptr], 0x0
                je .free_list
                dec r13

                mov rbx, [list_ptr]

                PRINTF format_list_sort, [rbx]
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
