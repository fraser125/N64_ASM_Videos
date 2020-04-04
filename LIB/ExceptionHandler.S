arch n64.cpu
endian msb
output "ExceptionHandler.bin", create

define DEBUG_SHOW_STATIC_VALUE(yes)

origin $00000000
base $80000000

include "../LIB/N64.INC"

base $80000000
exc_handler_p1: // 0x80000000
	eret
	
FIXED_GAP(exc_handler_p1, 0x180)
	// Save ra value
	mtc0 ra, ErrorEPC
	// Disable Interrupts
	mfc0 ra, Status
	andi ra, ra, -2
	mtc0 ra, Status
	la ra, SaveRegisterLocation
	sw at, at<<2 (ra)
	mfc0 at, ErrorEPC	
	sw k0, k0<<2 (ra)
	sw k1, k1<<2 (ra)
	sw at, ra<<2 (ra)
	// 4 Registers available ra, at, k0, k1
	mfc0 k0, Status
	mfc0 k1, Cause
	and k0, k0, k1
	andi k0, k0, 0xFF00
	// k0 contains Interrupt(s) that were triggered
	andi k1, k1, 0x00FF
	bnez k1, readJumpTable
	nop
	// k0 = bit flags of Triggered Interrupts
	// k0 = 0xFF00 aka 0b1111'1111'0000'0000
	// k1 = garbage
	// Parse Interrupts
	
	// ??? Handle k0 == 0 ??
	
	// Int Software 7, Timer
	// Int Hardware 6, 4 -
	// Int Hardware 5, 3 -
	// Int Hardware 4, 2 RCP
	// Int Hardware 3, 1 -
	// Int Hardware 2, 0 NMI
	// Int Software 1
	// Int Software 0	
	
	// k1 MUST = Jump Table Index
readJumpTable:
	// k0 = garbage
	// k1 Jump Table Index
	la k0, JumpTableHandler
	add k0, k0, k1
	lw k0, 0(k0)
	beqz k0, _exit
	nop
	
	// ?? Execute Handler ??
_exit:
	la ra, SaveRegisterLocation		
	lw at, at<<2 (ra)	
	lw k0, k0<<2 (ra)
	lw k1, k1<<2 (ra)	
	// If the developer changed the value of ra in RAM, 
	// should we move that value back?
	
	// Enable Interrupts
	mfc0 ra, Status
	ori ra, ra, 0x0001
	mtc0 ra, Status		
	mfc0 ra, ErrorEPC
	eret
	
FIXED_GAP(exc_handler_p1, 0x300)

dd 0
dd 0
dd 0
dd 0

FIXED_GAP(exc_handler_p1, 0x320)

base $80000320
exc_handler_p2: // 0x80000320
	// Code can go here
FIXED_GAP(exc_handler_p2, 0x060)
JumpTableHandler:
SaveRegisterLocation:
dw 0

FIXED_GAP(JumpTableHandler, 0x80)
FIXED_GAP(exc_handler_p2, 0xE0)