	;; Reads a string of 5 characters from stdin and displays on stdout
	;; read_string.asm
	;; yasm -f elf -m amd64 read_string.asm
	;; on 64 bit architecture
	;; 
	;; on 32 bit architecture
	;; yasm -f elf -m x86 read_string.asm
	;;
	;; linking
	;; ld -o read_string read_string.o
	;;

section .bss					; uninitialised data

	chars 	resb	6			; reserve space for 6 bytes
	
section .data					; initialise data and constants
	
	cr	equ 	0x0a			; carriage return character
	prmt 	db	'Enter 5 characters: '	; sequence of ASCII characters  - prompt
	len	equ	$ - prmt		; number of characters

	outs	db	'You entered : '	; output string - sequence of ASCII
	len2	equ	$ - outs		; number of characters
	
section .text					; instructions
	global _start

_start:

	mov	edx,len				; 			len)
	mov 	ecx,prmt			; 		&prmt,
	mov	ebx,1				;	stdout,
	mov	eax,4				; write(
	int 	0x80				; make the system call

	mov 	edx,6				; length of string to be read in
	mov	ecx,chars			; &chars - address of data read in
	mov	ebx,0				; stdin
	mov	eax,3				; read system call
	int 	0x80				; make the system call

	mov	edx,len2			; length of outs message
	mov	ecx,outs			; address of outs message - &outs
	mov	ebx,1				; stdout
	mov	eax,4				; write system call
	int 	0x80				; make the system call

	mov	edx,6				; length of chars that was read in
	mov	ecx,chars			; address of chars read in
	mov	ebx,1				; stdout
	mov	eax,4				; write
	int 	0x80				; make the system call
	
	mov	eax,1				; exit()
	int	0x80				; make the system call
	
	