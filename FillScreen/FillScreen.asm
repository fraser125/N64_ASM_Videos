// N64 Fill Screen
arch n64.cpu
endian msb
output "FillScreen.N64", create
origin $00000000
base $80000000 // Set this to the range you are inserting your blob

include "../LIB/N64.INC"
include "../LIB/COLORS16.INC"

	lui at, VI_BASE
	lw at, VI_ORIGIN(at)
	lui a0, LIME_GREEN16
	ori a0, LIME_GREEN16
	la a1, 320 * 240 * 2
	add a1, a1, at
UntilFilled:
	sw a0, 0x0(a1)
	sw a0, 0x4(a1)
	sw a0, 0x8(a1)
	sw a0, 0xC(a1)
	blt at, a1, UntilFilled
	subi a1, a1, 16