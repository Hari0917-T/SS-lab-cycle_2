section .data
    msg db "Enter number: ",0
    msgO db "ODD",0xa
    msgE db "EVEN",0xa
    

section .bss
    num1 resb 10      ; buffer to store up to 10-digit number
    len resb 1        ; length of input

section .text
    global _start

_start:
    ; Print prompt
    mov eax,4
    mov ebx,1
    mov ecx,msg
    mov edx,14
    int 0x80

    ; Read input
    mov eax,3
    mov ebx,0
    mov ecx,num1
    mov edx,10
    int 0x80
    mov [len],eax      ; store length of input

    ; Convert string to integer
    mov ecx,0          ; index
    mov eax,0          ; result
convert_loop:
    mov bl,[num1+ecx]  ; get next character
    cmp bl,0xA         ; newline check
    je check_even
    sub bl,'0'         ; convert ASCII to digit
    imul eax, eax, 10  ; multiply result by 10
    add eax, ebx       ; add current digit
    inc ecx
    jmp convert_loop

check_even:
    ; Check even or odd
    test eax,1
    jz even

odd:
    mov eax,4
    mov ebx,1
    mov ecx,msgO
    mov edx,4
    int 0x80
    jmp exit
    
    

even:
    mov eax,4
    mov ebx,1
    mov ecx,msgE
    mov edx,5
    int 0x80
    jmp exit

exit:
    mov eax,1
    mov ebx,0
    int 0x80
