// N64 Lesson 02 Simple Initialize
arch n64.cpu
endian msb
output "Video008.N64", create
// 1024 KB + 4 KB = 1028 KB
fill $0010'1000 // Set ROM Size

origin $00000000
base $80000000

include "../LIB/N64.INC"
include "../LIB/A64.INC"
include "../LIB/PIXEL8_UTIL.INC"
include "../LIB/COLORS16.INC"
include "N64_Header.asm"
insert "../LIB/N64_BOOTCODE.BIN"

Start:	                 // NOTE: base $80001000
	init()

	ScreenNTSC(320,200, BPP16, $A010'0000)

	nop
	nop
	nop
	
	pixel8_init16($A010'0000, PAPAYA_WHIP16, LIGHT_STEEL_BLUE16) // yellow foreground, blue background
	pixel8_init16($A011'0000, CRIMSON16, SILVER16) // yellow foreground, blue background

// Draw a Line (Horizontal)
	// 20 rows from the top
	// 100 Columns (110 + 100 + 110 = 320) 
	// 200 Pixels tall
	// 

	lui t0, LIGHT_BLUE16
	// ori t0, LIGHT_BLUE16
	la t1, $A010'0000
	
	// 320 Pixels Wide		
	addi t1, t1, ((320 * 20)  + 100) * 2	
	addi t2, r0, 200
do_Store2Pixels:
	sw t0, 0x0(t1)
	addi t2, t2, -1	
	bne t2, r0, do_Store2Pixels
	addi t1, t1, 320 * 2
	
Loop:  // while(true);
	j Loop
	nop
	
ALIGN(8)
include "../LIB/PIXEL8_UTIL.S"