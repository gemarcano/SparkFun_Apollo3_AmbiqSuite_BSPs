.syntax unified
.arch armv7e-m

.global Reset_Handler, _start

.text
.thumb
.thumb_func
.align 0
.func Reset_Handler
.type Reset_Handler, function
Reset_Handler:
	ldr sp, =_sstack
	b _start
.endfunc
