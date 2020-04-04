// N64 Exception Test
arch n64.cpu
endian msb
output "ExceptionTest.N64", create
// 1024 KB + 4 KB = 1028 KB
fill $0010'1000 // Set ROM Size

origin $00000000
base $80000000

include "../LIB/N64.INC"
include "../LIB/A64.INC"
include "N64_Header.asm"
insert "../LIB/N64_BOOTCODE.BIN"

constant fb1($A010'0000)

Start:	                 // NOTE: base $80001000
	init()
	nop	
	nop

	ScreenNTSC(320,240, BPP16, fb1) // 153,600 = 0x2'5800

	nop	
	nop
	nop
	la t0, eret_inst
	lw t0, 0(t0)	
	lui t1, 0x8000
	sw t0, 0(t1)	
	addi t1, t1, 0x0180
	sw t0, 0(t1)
	nop
	nop
	//la t0, 0x7000'0000
	//sw r0, 0(t0)
	nop
	nop
	mfc0 t0, Count
	li t1, 0x100000 
	add t0, t1, t0
	mtc0 t0, Compare
	nop	
	nop	
	mfc0 t0, Status
	ori t1, r0, 0xFF01
	or t0, t0, t1
	mtc0 t0, Status
	nop
	nop
	nop
	
	
	nop	
Loop:  // while(true);
	j Loop
	nop
	nop
	nop
eret_inst:
	eret