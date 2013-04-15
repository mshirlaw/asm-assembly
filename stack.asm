	;; The Stack
	;; Pushes 1, 2 and 3 onto the stack
	;; Pops 3, 2 and 1 from the stack and prints each
	;; on stdout

section .bss
	iobuf	resb	1	; reserve 1 byte
	
section .data
	cr	db	0x0A	; carriage return
	
section .text
	global _start

_start:

	mov	al,'1'
	push	rax		; push '1' onto stack
	mov	al,'2'
	push 	rax		; push '2' onto stack
	mov	al,'3'	
	push 	rax		; push '3' onto stack

	pop	rax		; pop '3'
	call 	putchar

	pop	rax		; pop '2'
	call 	putchar

	pop	rax		; pop '1'
	call 	putchar

	mov 	al,[cr]		; print <return> char
	call	putchar
	
	mov	eax,1		; exit()
	int 	0x80
	
putchar:
	mov 	[iobuf],al
	mov	edx,1		;			len)
	mov	ecx,iobuf		;		&cr
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt
	mov	al,[iobuf]
	ret