	;; Read a 16 bit unsigned number from stdin into ax
	;; bx is set to 1 on overflow
	;; only digits are pushed onto the stack and accumulated
	;; other characters are ignored

%include "system.inc"
	
section .bss
	iobuf	resb	1	; reserve 1 byte
	
section .data
	cr	db	0x0A			; carriage return
	msg	db	'Overflow occurred'	; overflow message
	len	equ	$ -msg
	
section .text
	global _start

_start:
	call 	readnum		; start reading from stdin

finish:
	mov 	al, [cr]	; load <return> in al 
	call 	putchar		; print <return> to stdout
	mov 	eax,1		; exit()
	int 	0x80
	
readnum:	
	mov 	edi,0		; flag indicating not in a number string
	mov 	rax,0		; set accumulator to zero
	push 	rax		; zero pushed to stack

reading:
	call 	getchar		; get char from stdin
	call 	putchar

	cmp	al,'0'		; test for non digits
	jl	atest
	cmp	al,'9'
	jg	atest

	mov	edi,1		; start of a number string
	sub	al,'0'
	mov	cx,0
	mov	cl,al		; cl has the digit read from stdin
	pop 	rax		; ax gets accumulated number
	mov 	bx,10		; for correct place value
	mul	bx		; dx:ax <- ax*10
	cmp	dx,0		; test for overflow
	jne	over
	add 	ax,cx		; ax <- ax + new digit
	jc	over
	push 	rax		; the new accumulated value saved on the stack
	jmp	reading		; get another digit

atest:
	cmp	edi,0		; haven't got a number string yet
	je	reading
	pop 	rax		; return result in ax
	mov	bx,0
	jmp 	finish
	ret

over:
	mov	bx,1		; overflow flag set

	mov	al,[cr]		; print <return> to stdout
	call 	putchar

	mov	edx,len		;			len)
	mov	ecx,msg		;		&iobuf
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt
	
	jmp 	finish
	
putchar:
	mov 	[iobuf],al	; load al
	mov	edx,1		;			len)
	mov	ecx,iobuf	;		&iobuf
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt
	mov	al,[iobuf]	; restore char in al
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
	