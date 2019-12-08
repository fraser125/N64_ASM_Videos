// N64 Lesson 02 Simple Initialize
arch n64.cpu
endian msb
output "Video002.N64", create

fill $0010'1000 // Set ROM Size
// fill 1052672‬ also works because
// 4 KB (4096 B) header reserved for config and publisher data
// 1 MB (1024 KB * 1024 KB = ‭1,048,576‬ B) game code copied to n64 ram on boot
// 4096 + ‭1048576‬ = 1,052,672‬ B roughly a megabyte used for our game

origin $00000000
base $80000000

include "../LIB/N64.INC"
include "../LIB/N64_GFX.INC"
include "N64_Header.asm"
insert "../LIB/N64_BOOTCODE.BIN"

Start:	                 // NOTE: base $80001000
	lui t0, PIF_BASE     // t0 = $BFC0 << 16	
	addi t1, zero, 8	         // t1 = 0 + 8
	sw t1, PIF_CTRL(t0)  // 0xBFC007FC = 8	

Loop:  // while(true);
	j Loop
	nop
	
	
