	;; Divides two small numbers 
	;; Outputs the quotient and remainder  
	;; on stdout in that order

section .bss
	iobuf1	resb	1	; reserve one byte for iobuffer1 
	iobuf2 	resb	1	; reserve one byte for iobuffer2
	
section .data
	cr	db	0x0A	; carriage return
	num1	db	21	; denominator 
	num2	db	6	; numerator
	
section .text
	global _start

_start:
	mov	al,[num1]	; al = denominator
	mov	bl,[num2]	; bl = numerator
	div	bl		; al <- (al / bl) and ah <- remainder

	add 	al, '0'		; quotient 
	add	ah, '0'		; remainder
	call	putchar

	mov	eax,1		; exit()
	int 	0x80

	
putchar:
	mov 	[iobuf1],al	; quotient in iobuf1
	mov	[iobuf2],ah	; remainder in iobuf2
	mov	edx,1		;			len)
	mov	ecx,iobuf1	;		&msg
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt

	mov	edx,1		;			len)
	mov	ecx,cr		;		&cr
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt

	mov	edx,1		;			len)
	mov	ecx,iobuf2	;		&msg
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt

	mov	edx,1		;			len)
	mov	ecx,cr		;		&cr
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt
	
	ret