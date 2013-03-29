	;; Outputs every second element of a number array
	;; 
	;;

section .bss
	mynum	resw	1;
	
section .data
	num	dw	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09 ; numbers
	cr	db	0x0A		 ; carriage return
	
global _start

_start:
	mov	esi,0		; counter

loop_top:	
	mov	al, [num+2*esi]	; load next element of num array
	add 	al, '0'		; get ascii value
	mov 	[mynum], al	; load al into mynum

	mov	edx,1		;			len)
	mov	ecx,mynum	;		&mynum
	mov	ebx,1		;	stdout
	mov	eax,4		;	write(
	int	0x80		; make the system call

	mov	edx,1		; 			len)
	mov	ecx,cr		; 		&cr
	mov	ebx,1		; 	stdout
	mov	eax,4		; wrtie(
	int 	0x80		; make the system call
	
	inc 	esi		;increment esi twice
	inc 	esi
	
	cmp	esi,10		; compare to 10
	jl	loop_top	; loop again if more numbers to output
	
	mov	eax,1		; exit()
	int 	0x80		; make the system call



