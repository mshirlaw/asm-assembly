	;; Detects an overflow from an add
	;; operation and outputs a suitable
	;; message on stdout

section .bss

section .data
	cr	db	0x0A		       	; carriage return
	msg	db	'Overflow occurred' 	; message to print
	len	equ	$ -msg			; length of the message
	bignum1	dw	65000			; a big number in 16 bits
	bignum2	dw	65000
	
section .text
	global _start

_start:
	mov	ebx,[bignum1]	; first operand
	mov	eax,[bignum2]	; second operand
	add	eax,ebx		; add
	jc	overflow	; jump if carry flag (cf) set

	mov	eax,1		; exit()
	int 	0x80

	
overflow:
	mov	edx,len		;			len)
	mov	ecx,msg		;		&msg
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt

	mov	edx,1		;			len)
	mov	ecx,cr		;		&cr
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt
	
	mov	eax,1		; exit()
	int 	0x80


	
