	;; Detects an overflow from a mul operation
	;; and outputs an error message on stdout

section .bss

section .data
	cr	db	0x0A		       	; carriage return
	msg	db	'Overflow occurred' 	; message to print
	len	equ	$ -msg			; length of the message
	bignum1	dw	1000			; operand one
	bignum2	dw	70			; operand two
	
section .text
	global _start

_start:
	mov	ax,[bignum1]	; first operand
	mov	cx,[bignum2]	; second operand
	mul	cx		; mul generates an overflow
	cmp	dx,0		; dx:ax <- ax * cx, dx positive if overflow
	jne	overflow

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