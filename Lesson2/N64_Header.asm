// N64 Header

db $80
db 0x37
db $12
db $40

// Clock Rate
dw $0000000F

dw Start
dw $1444
db "CRC1"
db "CRC2"

dd 0

db   "N64 Lesson 2               "
//   "123456789012345678901234567"

db $00 // Dev Id
db $00 // Cart Id
db $0 
db $0
db $0