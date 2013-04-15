	;; Read chars from stdin and push them onto the stack
	;; Echo chars to stdout
	;; Use a counter to pop all chars from the stack in reverse order
	
section .bss
	iobuf	resb	1	; reserve 1 byte
	
section .data
	cr	db	0x0A	; carriage return
	
section .text
	global _start

_start:
	mov 	esi,0		; initialise counter

reading:
	call 	getchar		; get char from stdin
	push 	rax		; push onto stack
	inc	esi		; increment counter
	cmp	al,0x0A
	jne	reading

	pop 	rax		; discard the <return> char
	dec 	esi		; adjust counter
	
popping:
	pop	rax		; pop from top of stack
	call  	putchar		; display on stdout
	dec	esi		; decrement counter
	cmp	esi,0		; test loop condition
	jne	popping

	mov 	al,[cr]		; print <return> char
	call	putchar

exit:
	mov	eax,1		; exit()
	int 	0x80
	
putchar:
	mov 	[iobuf],al
	mov	edx,1		;			len)
	mov	ecx,iobuf	;		&iobuf
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt
	mov	al,[iobuf]
	ret

getchar:
	mov	edx,1		; 			len)
	mov	ecx,iobuf	; 		&iobuf
	mov 	ebx,0		; 	stdin
	mov 	eax,3		; read(
	int 	0x80		; interrupt
	mov	al,[iobuf]	; store char in al
	ret
	