	;; Read a 16 bit unsigned number from stdin into ax
	;; doubles the number and stores it in &numb
	;; bx is set to 1 on overflow
	;; only digits are pushed onto the stack and accumulated
	;; other characters are ignored

%include "system.inc"

section .bss
	iobuf	resb	1	; reserve 1 byte
	n	resw	1	; reserve 1 word
	
section .data
	cr	db	0x0A		; carriage return
	msg	db	'Overflow' 	; overflow message
	len	equ	$ -msg

	msg1    db      'n : '		; prompt 1
	len1    equ     $ - msg1

	msg2    db      0x0A, 'double ' ; answer msg
	len2    equ     $ - msg2

	msg3    db      ' = '
	len3    equ     $ - msg3

	numb    dw      0x00		; to store the answer

section .text
	global _start

_start:
	mov 	edx,len1	; prompt for n
	mov	ecx,msg1
	call	putstr
	
	call 	readnum		; read a number from stdin
	cmp	bx,1
	je	over_finish		; overflow
	
	mov	[n],ax		; save the number

	mov	rax,[n]		; push arg0
	push 	rax

	mov	rax,numb	; push &arg1
	push 	rax		
	
	call 	double		; call double to double n
	add 	rsp,16		; restore stack pointer

	mov	edx, len2	; display "double" to stdout
	mov	ecx,msg2
	call	putstr

	mov	ax,[n]		; display n on stdout
	call	printnum

	mov	edx,len3	; display "=" on stdout
	mov	ecx,msg3
	call	putstr
	
	mov	ax,[numb]	; print answer on stdout
	call	printnum
	
	mov	al,[cr]		; print <return> on stdout
	call 	putchar

finish:	
	mov	eax,1		; exit()
	int 	0x80

over_finish:	
	mov	al,[cr]		; <return>
	call	putchar

	mov	edx,len		; overflow message
	mov	ecx,msg
	call	putstr

	mov	al,[cr]		; <return>
	call	putchar
	
	mov	eax,1		; exit()
	int 	0x80
	
double:				; doubles the parameter and leaves answer in &numb
	push 	rbp		; save rbp because it is about to be used
	mov	rbp,rsp		; save stack pointer as rbp
	mov	ax,[rbp+24]	; parameter [rbp+24 is n]
	mov	ebx,[rbp+16]	; parameter [rbp+16 is &result]
	add 	ax,ax		; may cause an overflow on addition
	jc	over_finish	; overflow on addition
	mov	[ebx],ax	; store result to &numb
	pop	rbp		; restore rbp
	ret
	
	;;  read a 16 bit unsigned number from stdin into ax
	;;  bx = 1 on overflow. 
readnum:
	mov     edi, 0		; flag indicating not in a number string
	mov     eax, 0
	push    rax		; accumulated number initially 0

reading:
	call    getchar		; read a char into al
	
	cmp     al, '0'
	jl      atest
	cmp     al, '9'
	jg      atest
	
	call    putchar		; write a char from al
	mov     edi, 1		; start of a number string
	sub     al, '0'
	mov     cx, 0
	mov     cl, al		; cl has the digit
	pop     rax		; ax <- numb
	mov     bx, 10
	mul     bx		; dx:ax <- ax * 10
        cmp     dx, 0
	jne     over
	add     ax, cx		; ax <- ax + the digit
	jc      over
	push    rax		; save the result so far
	jmp     reading

atest:	
	cmp     edi, 0		; haven't got a number string yet
	je      reading
	pop     rax		; return result in ax
	mov     bx, 0
	ret

over:
	mov     bx, 1		; set bx to indicate overflow
	ret

getchar:
	rawmode
	mov	edx,1		; 			len)
	mov	ecx,iobuf	; 		&iobuf
	mov 	ebx,0		; 	stdin
	mov 	eax,3		; read(
	int 	0x80		; interrupt
	normalmode
	mov	al,[iobuf]	; load char in al
	ret

putchar:
	mov 	[iobuf],al	; load al
	mov	edx,1		;			len)
	mov	ecx,iobuf	;		&iobuf
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt
	mov	al,[iobuf]	; restore char in al
	ret

putstr:	                   	; ecx has address, edx has length
	mov     ebx, 1
	mov     eax, 4
	int     0x80
	ret

printnum:			; print the number in eax
	mov    edx, 0
        mov    ebx, 10
        div    ebx		; eax <- eax div 10, edx <- remainder
        push   rdx		; rdx for 64 bits, edx otherwise
        cmp    eax, 0
        je     printnum1
        call   printnum

printnum1:
        pop    rdx
        add    dl, '0'
        mov    al, dl
        call   putchar
        ret