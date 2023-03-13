.syntax unified
.arch armv7e-m

.global Reset_Handler, Reset_Handler2

.text
.thumb
.thumb_func
.align 0
.func Reset_Handler
.type Reset_Handler, function
Reset_Handler:
	ldr sp, =_sstack
	blx Reset_Handler2
Reset_Handler_hang:
	bkpt
	b Reset_Handler_hang
.endfunc
