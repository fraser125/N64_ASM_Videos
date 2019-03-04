macro pixel8_init16(destination, forecolor, backcolor) {
	li a0, {destination}
	ori a1, r0, {forecolor}
	jal pixel8_init16	
	ori a2, r0, {backcolor}	
	// nop // Returns to here
}