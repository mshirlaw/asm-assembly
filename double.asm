	;; Read a 16 bit unsigned number from stdin into ax
	;; bx is set to 1 on overflow
	;; only digits are pushed onto the stack and accumulated
	;; other characters are ignored

%include "system.inc"

section .bss
	iobuf	resb	1	; reserve 1 byte
	ans	resw	1	; reserve 1 word
	
section .data
	cr	db	0x0A	; carriage return
	msg	db	'Overflow' ; overflow message
	len	equ	$ -msg

section .text
	global _start

_start:	
	call 	readnum		; read a number from stdin

	cmp 	bx,1		; check overflow
	je	exit_over_read	; exit if there was an overflow during read

	mov	[ans],rax	; store number to double in ans
	
	mov	al,[cr]		; load <return> in al
	call 	putchar		; print <return> to stdout

	mov	rax,[ans]	; load ans in rax

	push 	rax		; push rax onto stack
	call 	double		; call double to double ans

	jc	exit_over	; exit if there was an overflow on addition
	
	call 	printnum	; print the number recursively

	mov	al,[cr]		; print <return> on stdout
	call 	putchar

	mov	eax,1		; exit()
	int 	0x80

exit_over_read:
	mov 	al,[cr]		; used if there was an overflow dueing read
	call 	putchar
		
exit_over:
	mov	edx,len		;			len)
	mov	ecx,msg		;		&iobuf
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt

	mov	al,[cr]
	call 	putchar
	
	mov	eax,1		; exit()
	int 	0x80
	
	
double:				; doubles the parameter and leaves anser in ax
	push 	rbp		; save rbp because it is about to be used
	mov	rbp,rsp		; save stack pointer as rbp
	mov	ax,[rbp+16]	; parameter [rbp+8 is return address]
	add 	ax,ax		; may cause an overflow on addition
	pop	rbp		; restore rbp
	ret
	
printnum:		; print the unsigned 16 bit number in eax
	mov    edx, 0
	mov    ebx, 10
	div    ebx	; eax <- eax div 10, edx <- remainder
	push   rdx	; rdx for 64 bits, edx otherwise
	cmp    eax, 0
	je     printnum1
	call   printnum

printnum1:
	pop    rdx
	add    dl, '0'
	mov    al, dl
	call   putchar
	ret

	;;  read a 16 bit unsigned number from stdin into ax
	;;  bx = 1 on overflow. 
readnum:
	mov     edi, 0	; flag indicating not in a number string
	mov     eax, 0
	push    rax	; accumulated number initially 0

reading:
	call    getchar	; read a char into al
	
	cmp     al, '0'
	jl      atest
	cmp     al, '9'
	jg      atest
	
	call    putchar	; write a char from al
	mov     edi, 1	; start of a number string
	sub     al, '0'
	mov     cx, 0
	mov     cl, al	; cl has the digit
	pop     rax	; ax <- numb
	mov     bx, 10
	mul     bx	; dx:ax <- ax * 10
        cmp     dx, 0
	jne     over
	add     ax, cx	; ax <- ax + the digit
	jc      over
	push    rax	; save the result so far
	jmp     reading

atest:	
	cmp     edi, 0	; haven't got a number string yet
	je      reading
	pop     rax	; return result in ax
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