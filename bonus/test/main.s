%include "bonus/test/macro.inc"

%define BUFFER_SIZE 32
%include "bonus/test/test_atoi_base.s"
%include "bonus/test/test_list_push_front.s"
%include "bonus/test/test_list_size.s"
%include "bonus/test/test_list_sort.s"
%include "bonus/test/test_list_remove_if.s"

section .bss
        buffer1 resb BUFFER_SIZE
        buffer2 resb BUFFER_SIZE
        buffer3 resb BUFFER_SIZE

        struc Node
                struc Node
                .data resq 1
                .next resq 1
        endstruc

        list_begin resq 1
        list_ptr resq 1

section .data
        welcome db "[ LIBASM BONUS TESTER ]", NL, "no input + CTRL-d => next level", NL, 0
        welcome_len equ $ - welcome
        goodbye db NL, "[ LIBASM BONUS TESTER ] Goodbye! What an outstanding project isn't it ? :3", NL, 0
        goodbye_len equ $ - goodbye
        perror_msg db "[ LIBASM BONUS TESTER ] Error", 0
        just_nl db NL, 0
        null_test_msg db NL, 'Testing giving NULL as argument...', NL, 0
        null_test_msg_len equ $ - null_test_msg

section .text
        global _start

        extern tcflush
        extern printf
        extern perror
        extern __errno_location
        extern free

_start:
        and rsp, 0xFFFFFFFFFFFFFFF0

        WRITE welcome, welcome_len
        test rax, rax
        js .exit_failure

        ;call test_atoi_base
        ;test rax, rax
        ;js .exit_failure

        ;call test_list_push_front
        ;test rax, rax
        ;js .exit_failure

        call test_list_size
        test rax, rax
        js .exit_failure

        ;call test_list_sort
        ;test rax, rax
        ;js .exit_failure

        ;call test_list_remove_if
        ;test rax, rax
        ;js .exit_failure

        .exit:
                WRITE goodbye, goodbye_len
                test rax, rax
                js .exit_failure

                EXIT_SUCCESS

        .exit_failure:
                neg rax
                mov rbx, rax
                call __errno_location
                mov [rax], rbx

                mov rdi, perror_msg
                call perror
                WRITE goodbye, goodbye_len

                EXIT_FAILURE -1
