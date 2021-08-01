arch n64.cpu
endian msb
output "DoubleBuffer.N64", create

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

constant fb1($A010'0000)
constant fb2($A020'0000)

macro EnableInterrupts() {
	lui t0, MI_BASE
	ori t0, MI_INTR_MASK
	//ori t1, zero, 0x0AAA // 0x0AAA = All RCP Interrupts
	ori t1, zero, 0x0080 // 0x0080 = RCP-VI Interrupts
	sw t1, 0(t0)
	mfc0 t0, Status
	lui t1, 0xFFFF
	and t0, t0, t1
	ori t0, 0x0401 // Enable RCP Interrupts
	mtc0 t0, Status
}

macro DisableInterrupts() {
	mfc0 t0, Status
	lui t1, 0xFFFF
	and t0, t0, t1	
	mtc0 t0, Status
}

Start:	                 // NOTE: base $80001000
	init()
	ScreenNTSC(320,240, BPP32, fb1)
	nop
	nop
	nop
	la t0, Handler
	la t1, EndHandler
	li t2, $8000'0180
	// Copy Exception Handler to proper address
CopyDouble:
	lw t3, 0(t0)
	lw t4, 4(t0)
	sw t3, 0(t2)
	sw t4, 4(t2)
	addi t0, t0, 8
	bne t0, t1, CopyDouble
	addi t2, t2, 8
	nop
	nop
	nop
	DPC(RDP_INIT, RDP_INIT_END)
	nop
	// Draw Rectangle on Frame Buffer 1
	DPC(RDPFB_1, RDPFB_1_END)
	nop
	// Draw Rectangle on Frame Buffer 2
	DPC(RDPFB_2, RDPFB_2_END)
	nop
	DPC(RDPFB_DONE, RDPFB_DONE_END)	
	nop
	nop
	nop
	EnableInterrupts()
Loop:  // while(true);
	j Loop
	nop
	nop
	nop
	nop

scope SetFB: {
	la t0, CURRENT_FB		
	jr ra
	sw a0, 0(t0)
}
	nop
	nop
	nop

ALIGN(8)
RDP_INIT:
arch n64.rdp
	Set_Scissor 0<<2,0<<2, 0,0, 320<<2,240<<2
	Set_Other_Modes CYCLE_TYPE_FILL	
	Sync_Pipe 
RDP_INIT_END:

RDPFB_1:
arch n64.rdp
	Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,320-1, $00100000
	Set_Fill_Color $FF00FFFF  // 000000FF
	Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2	
	Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,320-1, $00100000
	Set_Fill_Color $FFFF00FF
	Fill_Rectangle 179<<2,139<<2, 16<<2,8<<2
	Sync_Pipe
RDPFB_1_END:

RDPFB_2:
arch n64.rdp
	Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,320-1, $00200000
	Set_Fill_Color $FF00FFFF // 000000FF
	Fill_Rectangle 319<<2,239<<2, 0<<2,0<<2	
	Set_Color_Image IMAGE_DATA_FORMAT_RGBA,SIZE_OF_PIXEL_32B,320-1, $00200000
	Set_Fill_Color $00FFFFFF
	Fill_Rectangle 309<<2,229<<2, 159<<2,129<<2
	Sync_Pipe
RDPFB_2_END:

RDPFB_DONE:
	Sync_Full 
RDPFB_DONE_END:

arch n64.cpu	
	nop
	nop
	nop

ALIGN(4)
CURRENT_FB:
	dw fb1
ALIGN(16)
scope Handler: {
base $80000180
	la t0, CURRENT_FB
	li t1, fb1
	li t2, fb2
	lw t3, 0(t0)
	
	bne t1, t3, AssignFB
	lui t4,VI_BASE
	add t1, t2, zero
AssignFB:
	sw t1,VI_ORIGIN(t4)
	sw t1, 0(t0)
	eret
FIXED_GAP(Handler, 128)
}
EndHandler:
