    MODULE Uart
UART_RxD  equ #143B       ; Also used to set the baudrate
UART_TxD  equ #133B       ; Also reads status
UART_SetBaud equ UART_RxD ; Sets baudrate
UART_GetStatus equ UART_TxD 

UART_TX_BUSY       equ %00000010
UART_RX_DATA_READY equ %00000001
UART_FIFO_FULL     equ %00000100

init:
    ld bc, #703B, a, 5 : out (c), a
    inc b
    ld a, 1 : out (c), a
    ret

read:
    ld bc, UART_GetStatus
.wait
    in a, (c)
    rrca : jr nc, .wait
    ld bc, UART_RxD
    in a, (c)
    ret

; Write single byte to UART
; A - byte to write
; BC will be wasted
write:    
    ld d, a
    ld bc, UART_GetStatus
.wait   
    in a, (c) : and UART_TX_BUSY : jr nz, .wait
    out (c), d
    ret

    ENDMODULE