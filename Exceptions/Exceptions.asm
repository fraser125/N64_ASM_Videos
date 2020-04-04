arch n64.cpu
endian msb
output "Exceptions.N64", create

define DEBUG_SHOW_STATIC_VALUE(yes)

fill $0010'1000 // Set ROM Size
// fill 1052672‬ also works because
// 4 KB (4096 B) header reserved for config and publisher data
// 1 MB (1024 KB * 1024 KB = ‭1,048,576‬ B) game code copied to n64 ram on boot
// 4096 + ‭1048576‬ = 1,052,672‬ B roughly a megabyte used for our game
// 1052672‬ Bytes is represented as $00101000‬ in hex

origin $00000000
base $80000000

include "../LIB/N64.INC"
include "N64_Header.asm"
insert "../LIB/N64_BOOTCODE.BIN"

constant exc_user_reg_Location(0x80000380)

macro exception_init(registerLocation) {
	DMA(Handler1, Handler1+Handler1.size, 0x0000)
	DMA(Handler2, Handler2+Handler2.size, 0x0320)
	DMAWait()
	li t0, 0x1400FF00
	mtc0 t0, Status
	
	addi t1, r0, 0x3F
	lui t2, MI_BASE	
	lw t1, MI_INTR_MASK(t2)
	
	la t0, {registerLocation}
	la t1, exc_user_reg_Location
	sw t0, 0(t1)
}

macro int_en() {
	mfc0 t0, Status
	ori t0, t0, 0x0001
	mtc0 t0, Status
}

macro int_dis() {
	mfc0 t0, Status
	andi t0, t0, -2
	mtc0 t0, Status
}

macro int_timer_test() {
	mfc0 t0, Count
	li t1, 0x100000 
	add t0, t1, t0
	mtc0 t0, Compare
}

Start:	                 // NOTE: base $80001000
	init()
	nop
	nop
	exception_init(exc_registers)
	nop
	nop
	int_en()
	nop
	nop
	break
	nop
	nop
Loop:  // while(true);
	j Loop
	nop
	nop
	nop
	

exc_registers:
exc_scalars:
	FIXED_GAP(exc_scalars, 256) // Scalar Registers 32 @ 8 bytes each

exc_floats:
	FIXED_GAP(exc_floats, 280) // Floating Point Registers 35 @ 8 bytes each

origin $100000

ALIGN(16)
insert Handler1,"../LIB/ExceptionHandler.BIN",0, 0x300
ALIGN(16)
insert Handler2,"../LIB/ExceptionHandler.BIN",0x320, 0x0E0
