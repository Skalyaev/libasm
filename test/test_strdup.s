section .data
        level6 db NL, 'Level 6 - strdup(<string>): Duplicate <string>', NL, 0
        level6_len equ $ - level6
        level6_input1 db '<string>: ', 0
        level6_input1_len equ $ - level6_input1
        format_strdup db '--> strdup: %s', NL, 0
        format_ft_strdup db '--> ft_strdup: %s', NL, 0

section .text
        global test_strdup
        extern strdup, ft_strdup

test_strdup:
        ENTER_PLS
        WRITE level6, level6_len
        RET_TEST

        .loop:
                WRITE level6_input1, level6_input1_len
                RET_TEST
                READ buffer1, BUFFER_SIZE - 1
                RET_TEST
                mov rbx, rax

                lea rdi, [buffer1]
                call ft_strdup
                mov r12, rax
                PRINTF format_ft_strdup, rax
                RET_TEST

                mov rdi, r12
                call free
                RET_TEST

                lea rdi, [buffer1]
                call strdup
                mov r12, rax
                PRINTF format_strdup, r12
                RET_TEST

                mov rdi, r12
                call free
                RET_TEST

                test rbx, rbx
                jz .exit

                BZERO buffer1, rbx
                TCFLUSH
                jmp .loop

        .exit:
                LEAVE_PLS
                ret