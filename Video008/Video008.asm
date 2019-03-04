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

	ScreenNTSC(320,240, BPP16, $A010'0000) // 153,600 = 0x2'5800

	nop
	nop
	nop
	
	pixel8_init16($A010'1000, PAPAYA_WHIP16, LIGHT_STEEL_BLUE16) // 12,160 = 0x2F80 yellow foreground, blue background
	pixel8_init16($A010'5000, CRIMSON16, SILVER16) // yellow foreground, blue background

	nop
	nop
	nop
	
Loop:  // while(true);
	j Loop
	nop
	
ALIGN(8)
include "../LIB/PIXEL8_UTIL.S"