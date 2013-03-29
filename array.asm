	;; Reads 10 chars into an array
	;; outputs the chars in reverse order
	;;

section .bss
	buf 	resb 	10 	; reserve space for 10 chars
	iobuf	resb	1	; reserve space for one byte

section .data
	cr 	db	0x0A	; initialise cr to the <return> char
	
global _start

_start:
	mov 	esi,10		; initialise esi to 10 - the array length
	call 	getarray	; get the array from the user

loop_top:
	mov	al,[buf+1*esi]	; load the correct element into al
	call 	putchar		; print the element to stdout
	dec 	esi		; decrement esi
	cmp	esi,0		; loop if there are more chars
	jge	loop_top

	mov	edx,1		; 	 len)
	mov	ecx,cr		; &cr,
	call 	putcr		; display cr on stdout
	
	mov	eax,1		; exit()
	int 	0x80		; make the system call

getarray:
	mov 	edx,10		; 			len)
	mov	ecx,buf		; 		&buf
	mov	ebx,0		; 	stdin,
	mov	eax,3		; read(
	int	0x80		; make the system call

	mov 	ax,[buf]	; load buf in ax
	ret
	
putchar:
	mov 	[iobuf],al	; load al in iobuf
	mov	edx,1		; 			len)
	mov	ecx,iobuf	; 		&iobuf,
	mov	ebx,1		; 	stdout,
	mov	eax,4		;write(
	int 	0x80		; make the system call
	mov	ax,[iobuf]
	ret
	
putcr:
	mov	ebx,1		; 	stdout
	mov	eax,4		; write(
	int 	0x80		; make the system call
	ret


