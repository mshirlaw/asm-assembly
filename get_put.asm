	;; getchar and putchar
	;; get_put.asm
	;; yasm -f elf -m amd64 get_put.asm
	;; on 64 bit architecture
	;; 
	;; on 32 bit architecture
	;; yasm -f elf -m x86 get_put.asm
	;;
	;; linking
	;; ld -o get_put get_put.o
	;;

%include "system.inc"
	
section .bss				; uninitialised data
	iobuf	db	1		; global character buffer
	
section .data				; initialised data and constants
	cr	db	0x0A
	
section .text				; instructions
	global _start

_start:
	mov	[iobuf],al		; but al in the address of the iobuffer
	call 	get_char		; call the get_char function
	mov	al,[iobuf]		; store value in al in iobuf
	call 	put_char		; call putchar
	
	mov	eax, 1			; the exit call is 1	 
	int 	0x80			; make the inteurupt

get_char:
	rawmode
	mov	edx,1			; length of chars entered
	mov	ecx,iobuf		; &iobuf
	mov	ebx,0			; read from stdin
	mov	eax,3			; read system call
	int	0x80			; make the interupt
	normalmode
	ret
	
put_char:
	mov	edx,1			; length of the message to print
	mov	ecx,iobuf			; the address of the message
	mov	ebx,1			; print to stdout (1)
	mov	eax,4			; the write system call (4)
	int 	0x80			; make the interupt

	mov	edx,1			; print one byte
	mov	ecx,cr			; the address of <return>
	mov	ebx,1			; print to stdout (1)
	mov	eax,4			; the write system call (4)
	int 	0x80			; make the interupt

	ret

	
