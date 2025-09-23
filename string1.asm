section .data
 msg1 db "string :" ,0xa
 msg2 db "character :",0xa
  msg3 db 0xa
  
section .bss
  str1 resb 100
  chr1 resb 1
 count resb 1
 
 section .text
 global _start
 
 _start:
 
 ;print "string"
 mov eax,4
 mov ebx,1
 mov ecx,msg1
 mov edx,9
 int 0x80
 
 ;read "string"
 mov eax,3
 mov ebx,0
 mov ecx,str1
 mov edx,100
 int 0x80
 mov byte[str1 + eax-1],0
 
 ; print " character"
  mov eax,4
 mov ebx,1
 mov ecx,msg2
 mov edx,12
 int 0x80
 
  ;read "character"
 mov eax,3
 mov ebx,0
 mov ecx,chr1
 mov edx,1
 int 0x80
 
 ;initialise
 mov esi,str1
 mov dl,[chr1]
 mov ecx,0
 
.loop1 :
mov al,[esi]
cmp al,0
je .done
cmp al,dl
jne .skip
inc ecx

.skip :
inc esi
jmp .loop1

.done :
 mov eax,ecx 
 add eax,'0'
 mov [count],al
 
 ;print count
 
 mov eax,4
 mov ebx,0
 mov ecx,count
 mov edx,1
 int 0x80
 
  ;print newline
 mov eax,4
 mov ebx,1
 mov ecx,msg3
 mov edx,1
 int 0x80
 
 ;exit
 mov eax,1
 mov ebx,0
 int 0x80
