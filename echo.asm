	;; Reads characters from stdin until <return>
	;; Echos chars to screen 
	;; read_chars.asm
	;; yasm -f elf -m amd64 read_chars.asm
	;; on 64 bit architecture
	;; 
	;; on 32 bit architecture
	;; yasm -f elf -m x86 read_chars.asm
	;;
	;; linking
	;; ld -o read_chars read_chars.o
	;;

section .bss				; uninitialised data

	mychar 	resb	1		; reserve space for 1 bytes
	
section .data				; initialised data and constants
	
	cr	equ 	0x0A		; carriage return character
		
section .text				; instructions
	global _start

_start:
	
reading:	
	mov 	edx, 1			; length is equal to one byte
	mov 	ecx, mychar		; the &char to be read
	mov 	ebx, 0			; read from stdin (0)
	mov 	eax, 3			; 3 is the "read" system call
	int 	0x80			; make the interupt

	mov	edx, 1			; length is equal to one char
	mov	ecx, mychar		; the char to output
	mov	ebx, 1			; write to stdout
	mov	eax, 4			; the write system call is 4
	int	0x80			; make the interupt
	
	mov 	al, [mychar]		; move the character at &mychar to the lower half of ax 
	cmp	al,cr			; compare with the carriage return
	jne	reading			; repeat if not equal to return
	
	mov	eax, 1			; the exit call is 1	 
	int 	0x80			; make the inteuupt