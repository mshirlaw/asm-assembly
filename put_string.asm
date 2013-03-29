	;; put_string
	;; put_string.asm
	;; yasm -f elf -m amd64 put_string.asm
	;; on 64 bit architecture
	;; 
	;; on 32 bit architecture
	;; yasm -f elf -m x86 put_string.asm
	;;
	;; linking
	;; ld -o function function.o
	;;

%include "system.inc"
	
section .bss				; uninitialised data
	
section .data				; initialised data and constants
	cr	db	0x0A
	msg	db	'My string' 	; the string
	len	equ	$ - msg	       ; length of string
	
section .text				; instructions
	global _start

_start:
	mov	edx,len			; length of the message to print
	mov	ecx,msg			; the address of the message
	call 	putstr
	
	mov	eax, 1			; the exit call is 1	 
	int 	0x80			; make the inteurupt
	
putstr:
	mov	ebx,1			; print to stdout (1)
	mov	eax,4			; the write system call (4)
	int 	0x80			; make the interupt

	mov	edx,1			; print one byte
	mov	ecx,cr			; the address of <return>
	mov	ebx,1			; print to stdout (1)
	mov	eax,4			; the write system call (4)
	int 	0x80			; make the interupt

	ret

	
