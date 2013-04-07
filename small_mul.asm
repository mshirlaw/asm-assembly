	;; Multiplies two small numbers 
	;; converts the result to ascii and 
	;; outputs the result on stdout

section .bss
	iobuf	resb	1	; reserve one byte for iobuffer 
	
section .data
	cr	db	0x0A	; carriage return
	snum1	db	2	; operand one
	snum2	db	4	; operand two
	
section .text
	global _start

_start:
	mov	al,[snum1]	; first operand + result
	mov	bl,[snum2]	; multiply by bl
	mul	bl		; al <- al * bl

	add 	al, '0'		; convert to ascii
	call	putchar

	mov	eax,1		; exit()
	int 	0x80

	
putchar:
	mov 	[iobuf],al	; load result in iobuf
	mov	edx,1		;			len)
	mov	ecx,iobuf	;		&msg
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt

	mov	edx,1		;			len)
	mov	ecx,cr		;		&cr
	mov	ebx,1		;	stdout
	mov	eax,4		; write(
	int 	0x80		; interrupt
	ret