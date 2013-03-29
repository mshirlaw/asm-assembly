	;; Uses a function to output hello world
	;; function.asm
	;; yasm -f elf -m amd64 function.asm
	;; on 64 bit architecture
	;; 
	;; on 32 bit architecture
	;; yasm -f elf -m x86 fucntion.asm
	;;
	;; linking
	;; ld -o function function.o
	;;

%include "system.inc"
	
section .bss				; uninitialised data
	
section .data				; initialised data and constants
	
	count 	dw	0x07		; hard code the number of iterations
	cr 	equ	0x0A		; return char
	msg	db	"Hello world!",cr 	; the message to print
	len	equ	$ - msg		  ; length of the message
	
section .text				; instructions
	global _start

_start:
	
while:	
	call 	my_func			; call the function
	mov	al,[count]		; store count in al 
	sub	al,1			; subtract 1 from the counter
	mov	[count],al		; store the reduced counter back in count variable
	cmp	al,0			; compare the count variable with 0
	jg	while			; start the loop again
endwhile:	

	mov	eax, 1			; the exit call is 1	 
	int 	0x80			; make the inteurupt

my_func:
	mov	edx,len			; length of the message to print
	mov	ecx,msg			; the address of the message
	mov	ebx,1			; print to stdout (1)
	mov	eax,4			; the write system call (4)
	int 	0x80			; make the interupt
	ret

