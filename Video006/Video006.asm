// N64 Lesson 02 Simple Initialize
arch n64.cpu
endian msb
output "Video006.N64", create
// 1024 KB + 4 KB = 1028 KB
fill $0010'1000 // Set ROM Size

origin $00000000
base $80000000

include "../LIB/N64.INC"
include "../LIB/N64_GFX.INC"
include "../LIB/COLORS16.INC"
include "N64_Header.asm"
insert "../LIB/N64_BOOTCODE.BIN"

Start:	                 // NOTE: base $80001000
	lui t0, PIF_BASE     // t0 = $BFC0 << 16	
	addi t1, zero, 8	         // t1 = 0 + 8
	sw t1, PIF_CTRL(t0)  // 0xBFC007FC = 8	
	
	nop
	nop
	nop

// Video Initialization 320x240x16bit
	lui t0, VI_BASE

	li t1, BPP16
	sw t1, VI_STATUS(t0)

	li t1, $A010'0000
	sw t1, VI_ORIGIN(t0)

	li t1, 320
	sw t1, VI_WIDTH(t0)

	li t1, $200
	sw t1, VI_V_INTR(t0)

	li t1, 0
	sw t1, VI_V_CURRENT_LINE(t0)
	
	li t1, $3E52239 
	sw t1, VI_TIMING(t0)

	li t1, $20D         
	sw t1, VI_V_SYNC(t0)

	li t1, $C15         
	sw t1, VI_H_SYNC(t0)

	li t1, $C150C15
	sw t1, VI_H_SYNC_LEAP(t0)

	li t1, $6C02EC        
	sw t1, VI_H_VIDEO(t0)

	li t1, $2501FF        
	sw t1, VI_V_VIDEO(t0)

	li t1, $E0204        
	sw t1, VI_V_BURST(t0)

	li t1, ($100*(320/160))
	sw t1, VI_X_SCALE(t0)

	li t1, ($100*(240/60))
	sw t1, VI_Y_SCALE(t0)
	nop
	nop
	nop

// Draw a Line (Verticle)
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
	
	
