section .data
    message db "Hello World!", 0xA
    message_len equ $ - message

section .text
    global setup_brk
    global dismiss_brk
    global memory_alloc
    global memory_free

setup_brk:
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, message_len
    syscall

dismiss_brk:
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, message_len
    syscall

memory_alloc:
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, message_len
    syscall

memory_free:
    mov rax, 1
    mov rdi, 1
    mov rsi, message
    mov rdx, message_len
    syscall

