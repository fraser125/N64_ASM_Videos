## Registers  
|Name|Description|Number|
|---|---|---|
| $zero | always zero | r0 |
| $at | Reserved for Pseudo Instructions | r1 |
| $a0 - $a3 | Function Arguments | r4 - r7 |
| $v0 - $v1 | Function Return Value | r2 - r3 |
| $t0 - $t9 | Temporary - Local Function Variable | r8 - r15, r24, r25 |
| $s0 - $s8 | Saved - Global Variables | r16 - r23, r30 |
| $k0 - $k1 | Reserved Kernel / Exception Handler | r26, r27 |
| $gp | Global Pointer| r28 |
| $sp | Stack Pointer | r29 |
| $ra | Return Address | r31 |

## Delay Slot (Video 005)
N64 has a 5 cycle Pipeline, some instructions use all of their cycles and other instruction use more.  
**nop instruction is always a safe choice**  
Think of it this way (not perfect, but feel free to read the pipeline chapter in the datasheet.  

|Pipeline Cycles | Instruction Type |
|---|---|
|6 |Branch and Jump Instructions|
|5 | Load and Store Instructions|
|4 | Register to Register |

The Branch and Jump Instructions take up 6 cycles so to take advantage of the extra 4 cycles left over use a Register to Register instruction.  
Load and Store instructions are OK on N64 because they will block until they are complete, but will technically take an extra clock cycle. 

Jump + R2R = 10 pipeline cycles aka 2 Clock cycles 
Jump + L&S = 11 pipeline cycles aka 3 Clock cycles   
Jump + Jump = 12 pipeline cycles and unpredictable behavior, just don't do it.  

## Instructions  
| Inst. | Description | Asm Example | C Example |  Psuedo | Exception? | Video |  
|-------|-------------|-------------|-----------|---------|------------|-------|
| ADDI | Add Immediate | addi t0, r0, 0x0180 | uint32_t t0 = 0 + 0x0180 |||003|  
| BEQ | Branch If Equal | beq t0, r0, lbl_Else | if (t0 == 0) goto lbl_Else | | | 005 |  
| BNE | Branch If Not Equal | bne t0, r0, lbl_Else | if (t0 != 0) goto lbl_Else | | | 005 |  
| LA | Load Address | la t0, 0x1FC0007FC | uint32_t t0 = 0x1FC007FC | YES | | 005 |  
| LI | Load Immediate | li t0, 0x1FC0007FC | uint32_t t0 = 0x1FC007FC | YES | | 004 |  
| LUI | Load Upper Immediate | lui t0, 0x8000 | uint32_t t0 = 0x8000 << 16 | | | 003 |  
| NOP | No Operation | nop |  | | |  003 |  
| ORI | OR Immediate | ori t0, r0, 0xA00A | uint32_t t0 = 0xA00A | | | 003 |  
| SW | Store Word | sw t1, 0x07FC9(t0) | *(volatile uint32_t *) 0x000007FC = 8;| | | 003 |  
| J | Jump | j Loop | goto Loop | | | 003 |  
