macro pixel8_init16(destination, forecolor, backcolor) {
	li a0, {destination}
	ori a1, r0, {forecolor}
	jal pixel8_init16	
	ori a2, r0, {backcolor}		
}

// pixel8_static16(red_silver, fb1, 32, 16, hello_world_text, 12)
macro pixel8_static16(font_name, framebuffer, top, left, string_label, length) {
	la a0, {font_name}
	la a1, {framebuffer}
	lui a2, {top} // 16 bit value
	ori a2, {left} // 16 bit value
	la a3, {string_label}
	jal pixel8_static16
	ori v1, zero, {length} // 64 KB Max Length
}