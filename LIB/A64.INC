// constant BPP0($0000)  // VI Status/Control: Color Depth Blank (No Data Or Sync) (Bit 0..1)
//*RESERVED*($0001)   // VI Status/Control: Color Depth Reserved (Bit 0..1)
constant BPP16($0002) // VI Status/Control: Color Depth 16BPP R5/G5/B5/A1 (Bit 0..1)
// constant BPP32($0003) // VI Status/Control: Color Depth 32BPP R8/G8/B8/A8 (Bit 0..1)

//macro init() {
//	lui t0, PIF_BASE     // t0 = $BFC0 << 16	
//	addi t1, zero, 8	         // t1 = 0 + 8
//	sw t1, PIF_CTRL(t0)  // 0xBFC007FC = 8	
	
//	la t0, 0x80000318
//	lw t0, 0(t0)	 // 40'0000 or 800000	
//	lui t1, 0x8000
//	or t0, t0, t1
//	addi sp, t0, -4
//}

macro ScreenNTSC(width,height, status, origin) {
// Video Initialization 320x240x16bit
	lui t0, VI_BASE

	li t1, {status}
	sw t1, VI_STATUS(t0)

	la t1, {origin}
	sw t1, VI_ORIGIN(t0)

	li t1, {width}
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

	li t1, ($100*({width}/160))
	sw t1, VI_X_SCALE(t0)

	li t1, ($100*({height}/60))
	sw t1, VI_Y_SCALE(t0)
}