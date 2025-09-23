section .data
    msg1 db 10,13,"ENTER THE NUMBER: ",0
    msg2 db 10,13,"THE FACTORIAL IS: ",0
    newline db 10      ; newline character

section .bss
    number resb 2       ; store input number as string
    result resd 1       ; store factorial result

section .text
    global _start

_start:
    ; Print prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 20
    int 0x80

    ; Read input
    mov eax, 3
    mov ebx, 0
    mov ecx, number
    mov edx, 2
    int 0x80

    ; Convert ASCII to integer
    movzx eax, byte [number]
    sub eax, '0'          ; convert ASCII to number
    mov ebx, eax          ; store in ebx for factorial calculation
    mov eax, 1            ; result = 1

factorial_loop:
    mul ebx               ; eax = eax * ebx
    dec ebx
    cmp ebx, 1
    jg factorial_loop

    ; Store result
    mov [result], eax

    ; Print message
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 23
    int 0x80

    ; Print factorial
    mov eax, [result]
    call print_number

    ; Exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

;--------------------------------------------
; Print number in EAX with newline
;--------------------------------------------
print_number:
    mov ecx, 10
    xor edx, edx
    mov esi, esp
    sub esp, 16           ; reserve space for digits
    mov edi, esp          ; edi points to buffer

convert_loop:
    xor edx, edx
    div ecx               ; eax / 10, remainder in edx
    add dl, '0'
    dec edi
    mov [edi], dl
    test eax, eax
    jnz convert_loop

    ; Print number
    mov eax, 4
    mov ebx, 1
    mov ecx, edi
    mov edx, esp
    sub edx, edi
    int 0x80

    ; Print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    add esp, 16           ; restore stack
    ret
