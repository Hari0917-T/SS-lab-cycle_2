section .data
    msg1 db "Enter string: ",0
    msg2 db "Enter substring: ",0
    msgS db "FOUND",0xA,0
    msgF db "NOT FOUND",0xA,0

section .bss
    str1 resb 100
    sub1 resb 100

section .text
    global _start

_start:
    ; Prompt for main string
    mov eax,4
    mov ebx,1
    mov ecx,msg1
    mov edx,14
    int 0x80

    mov eax,3
    mov ebx,0
    mov ecx,str1
    mov edx,100
    int 0x80
    mov byte [str1 + eax - 1], 0

    ; Prompt for substring
    mov eax,4
    mov ebx,1
    mov ecx,msg2
    mov edx,17
    int 0x80

    mov eax,3
    mov ebx,0
    mov ecx,sub1
    mov edx,100
    int 0x80
    mov byte [sub1 + eax - 1], 0

    ; Substring search
    mov esi, str1         ; ESI → main string
next_char:
    cmp byte [esi], 0
    je not_found          ; End of main string, not found

    mov edi, sub1         ; EDI → substring
    mov ebx, esi          ; EBX → current position in main

compare_loop:
    mov al, [ebx]
    mov dl, [edi]
    cmp dl, 0
    je found              ; Reached end of substring → match
    cmp al, 0
    je not_found          ; End of main string
    cmp al, dl
    jne no_match
    inc ebx
    inc edi
    jmp compare_loop

no_match:
    inc esi
    jmp next_char

found:
    mov eax,4
    mov ebx,1
    mov ecx,msgS
    mov edx,6
    int 0x80
    jmp exit

not_found:
    mov eax,4
    mov ebx,1
    mov ecx,msgF
    mov edx,11
    int 0x80

exit:
    mov eax,1
    mov ebx,0
    int 0x80
