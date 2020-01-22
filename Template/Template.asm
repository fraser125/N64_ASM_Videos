arch n64.cpu
endian msb
output "Template.N64", create

fill $0010'1000 // Set ROM Size
// fill 1052672‬ also works because
// 4 KB (4096 B) header reserved for config and publisher data
// 1 MB (1024 KB * 1024 KB = ‭1,048,576‬ B) game code copied to n64 ram on boot
// 4096 + ‭1048576‬ = 1,052,672‬ B roughly a megabyte used for our game
// 1052672‬ Bytes is represented as $00101000‬ in hex

origin $00000000
base $80000000

include "../LIB/N64.INC"
include "../LIB/N64_GFX.INC"
include "N64_Header.asm"
insert "../LIB/N64_BOOTCODE.BIN"

Start:	                 // NOTE: base $80001000
	init()

Loop:  // while(true);
	j Loop
	nop
	
	
