pixel8_init16:
	// a0 = font_destination
	// a1 = forecolor
	// a2 = backcolor	
	beq a0, r0, _pixel8_init16_exit
	nop
	li t0, PIXEL8_START	
	addi t3, r0, 94
_pixel8_init16_newChar:
	ld t1, 0x0(t0) // Loaded Font Character
	
	addi t2, r0, 63
_pixel8_init16_do_pixel:
	bltzl t1, _pixel8_init16_continue
	sh a1, 0x0(a0)	
	sh a2, 0x0(a0)
_pixel8_init16_continue:
	sll t1, t1, 1
	addi a0, a0, 2
	bne t2, r0, _pixel8_init16_do_pixel
	addi t2, t2, -1
	
	addi t0, t0, 8
	bne t3, r0, _pixel8_init16_newChar
	addi t3, t3, -1
_pixel8_init16_exit:
	jr ra
	ori v0, 0x2F80 // 95 * 64 * 2 = 12,160 = 0x2F80

PIXEL8_START:
insert "../LIB/PIXEL8.FNT"
PIXEL8_END: