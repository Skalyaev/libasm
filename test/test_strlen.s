section .data
        level1 db NL, "Level 1 - strlen(<string>): Calculates the length of <string>", NL, 0
        level1_len equ $ - level1
        level1_input1 db "<string>: ", 0
        level1_input1_len equ $ - level1_input1

        format_strlen db "--> strlen: %d", NL, 0
        format_ft_strlen db "--> ft_strlen: %d", NL, 0

section .text
        global test_strlen
        extern strlen, ft_strlen

test_strlen:
        FT_ENTER

        WRITE level1, level1_len
        RET_TEST

        ;---> strlen() actually SEGVs when passed NULL 
        ;WRITE null_test_msg, null_test_msg_len
        ;RET_TEST

        ;mov rdi, 0x0
        ;call ft_strlen
        ;PRINTF format_ft_strlen, rax
        ;RET_TEST

        ;mov rdi, 0x0
        ;call strlen
        ;PRINTF format_strlen, rax
        ;RET_TEST

        .loop:
                WRITE level1_input1, level1_input1_len
                RET_TEST

                READ buffer1, BUFFER_SIZE - 1
                RET_TEST
                mov rbx, rax
                TCFLUSH

                lea rdi, [buffer1]
                call ft_strlen

                PRINTF format_ft_strlen, rax
                RET_TEST

                lea rdi, [buffer1]
                call strlen

                PRINTF format_strlen, rax
                RET_TEST

                test rbx, rbx
                jz .exit

                BZERO buffer1, rbx
                jmp .loop

        .exit:
                FT_LEAVE
                ret
