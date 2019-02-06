// N64 Lesson 02 Simple Initialize
arch n64.cpu
endian msb
output "Lesson02.N64", create
// 4 KB 
// 1024 KB 
fill 1052672 // Set ROM Size

origin $00000000
base $80000000

include "../LIB/N64.INC"
include "N64_Header.asm"
insert "../LIB/N64_BOOTCODE.BIN"

// base $80001000

Start:
	// a0 =	$00000000
	lui a0, PIF_BASE
	// a0 =	$BFC00000	
	
	addi t0, 8
	// 7C0 + 3C = 7FC
	sw t0, PIF_RAM+$3C(a0)
	// 0xBFC007FC = 8;
	
// while(true);
Loop:
	j Loop
	nop