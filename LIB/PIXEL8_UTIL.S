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

pixel8_static16:
	// a0 {font_name}
	// a1 {framebuffer}
	// a2-upper {top} // 16 bit value
	// a2-lower {left} // 16 bit value
	// a3 {string_label}	
	// v1 {length} // 64 KB Max Length
	beq a0, zero, _pixel8_static16_exit
	nop
	beq a1, zero, _pixel8_static16_exit
	nop
	beq a3, zero, _pixel8_static16_exit
	nop	
	blez v1, _pixel8_static16_exit
	nop
	
_pixel8_static16_next_char:
	// t0 = ascii - 32, pixel8 index of current character
	lb t0, 0x0(a3)
	addi t0, t0, -32
	// 1 pixel = 2 bytes
	// 1 character = 64 pixels
	// 64 * 2 = 128 bytes per character
	// 8x8 = 1 row = 8 pixels aka 16 bytes
	addi t1, zero, 128
	mult t0, t1
	// t2 = screen row 
	srl t2, a2, 16   //  t2 = a2 >> 16
	andi a2, a2, 0xFFFF
	// t1 = character index in Font Memory
	mflo t1
	add t1, t1, a0
	andi t3, zero, 640
	
	mult t2, t3
	sll a2, a2, 1
	add t4, a1, a2
	// t3 = row location index in framebuffer
	mflo t3
	add t4, t4, t3
	addi t7, zero, 8
_pixel8_static16_next_char_line:
	// t4 = write location index in framebuffer
	ld t5, 0x0(t1)
	ld t6, 0x8(t1)
	sd t5, 0x0(t4)
	sd t6, 0x8(t4)
	addi t1, t1, 16
	addi t4, t4, 640
	bne t7, zero, _pixel8_static16_next_char_line
	addi t7, t7, -1
	
_pixel8_static16_exit:
	jr ra
	nop

PIXEL8_START:
insert "../LIB/PIXEL8.FNT"
PIXEL8_END: