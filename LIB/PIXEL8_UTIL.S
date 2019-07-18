scope pixel8_init16: {	
	constant font_mem_size(0x2F80)
	constant font_char_cnt(94)
	constant font_char_bits(63)

	variable font_addr(a0)   // a0 = font_destination	
	constant forecolor(a1)   // a1 = forecolor	
	constant backcolor(a2)   // a2 = backcolor
		
	beq font_addr, r0, _exit
	nop
	li t0, PIXEL8_FNT_START	
	addi t3, r0, font_char_cnt
_newChar:
	ld t1, 0x0(t0) // Loaded Font Character	
	addi t2, r0, font_char_bits
_do_pixel:
	bltzl t1, _continue
	sh forecolor, 0x0(font_addr)	
	sh backcolor, 0x0(font_addr)
_continue:
	dsll t1, t1, 1
	addi font_addr, font_addr, 2
	bne t2, r0, _do_pixel
	addi t2, t2, -1
	
	addi t0, t0, 8
	bne t3, r0, _newChar
	addi t3, t3, -1
_exit:
	jr ra
	ori v0, font_mem_size // 95 * 64 * 2 = 12,160 = 0x2F80
}

scope pixel8_static16: {	
	constant font_addr(a0)     // a0 {font_name}	
	constant fb(a1)            // a1 {framebuffer}
	constant position(a2)      // a2-upper {top} // 16 bit value // a2-lower {left} // 16 bit value	
	constant string_length(v1) // v1 {length} // 64 KB Max Length

	variable string_label(a3)  // a3 {string_label}	
	
	// Parameter Validation
	beq font_addr, zero, _exit
	nop
	beq fb, zero, _exit
	nop
	beq string_label, zero, _exit
	nop	
	blez string_length, _exit
	nop
	
_pixel8_static16_next_char:
	constant first_printable_ascii(32)
	constant bytes_per_char(128) 

	variable current_char(t0)            // t0 = ascii - 32, pixel8 index of current character
	variable remaining_bytes_for_char(t1)
	variable top(t2)
	variable left(a2)
	
	srl top, position, 16         //  top = position >> 16
	andi left, position, 0xFFFF   //  left = position & 0xFFFF

	lb current_char, 0x0(string_label)	
	addi current_char, current_char, -first_printable_ascii
	
	// 1 pixel = 2 bytes
	// 1 character = 64 pixels
	// 64 * 2 = 128 bytes per character
	// 8x8 = 1 row = 8 pixels aka 16 bytes
	
	addi remaining_bytes_for_char, zero, bytes_per_char
	
	// Calculate Top Memory Address
	// Calculate Left Memory Address
	
	
	mult current_char, remaining_bytes_for_char
	// t2 = screen row 
		
	// remaining_bytes_for_char = character index in Font Memory
	mflo remaining_bytes_for_char
	add remaining_bytes_for_char, remaining_bytes_for_char, a0
	andi t3, zero, 640
	
	mult t2, t3
	sll a2, a2, 1
	add t4, a1, a2
	// t3 = row location index in framebuffer
	mflo t3
	add t4, t4, t3
	addi t7, zero, 7
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
	
_exit:
	jr ra
	nop
}

PIXEL8_FNT_START:
insert "../LIB/PIXEL8.FNT"
PIXEL8_FNT_END: