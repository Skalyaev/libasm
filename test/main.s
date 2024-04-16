%include "test/macro.inc"
%define BUFFER_SIZE 16

%include "test/test_strlen.s"
%include "test/test_strcpy.s"
%include "test/test_strcmp.s"
%include "test/test_write.s"
%include "test/test_read.s"
%include "test/test_strdup.s"

section .bss
        buffer1 resb BUFFER_SIZE
        buffer2 resb BUFFER_SIZE
        buffer3 resb BUFFER_SIZE

section .data
        welcome db "[ LIBASM TESTER ]", NL, "no input + CTRL-d => next level", NL, 0
        welcome_len equ $ - welcome
        goodbye db NL, "[ LIBASM TESTER ] Goodbye!", NL, 0
        goodbye_len equ $ - goodbye
        perror_msg db "[ LIBASM TESTER ] Error", 0
        null_test_msg db NL, "Testing giving NULL as argument...", NL, 0
        null_test_msg_len equ $ - null_test_msg

section .text
        global _start

        extern tcflush
        extern printf
        extern atoi
        extern free
        extern perror
        extern __errno_location

_start:
        and rsp, 0xFFFFFFFFFFFFFFF0

        WRITE welcome, welcome_len
        test rax, rax
        js .exit_failure

        call test_strlen
        test rax, rax
        js .exit_failure

        call test_strcpy
        test rax, rax
        js .exit_failure

        call test_strcmp
        test rax, rax
        js .exit_failure

        call test_write
        test rax, rax
        js .exit_failure

        call test_read
        test rax, rax
        js .exit_failure

        call test_strdup
        test rax, rax
        js .exit_failure

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
