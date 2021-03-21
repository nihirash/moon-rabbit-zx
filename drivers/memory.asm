    module Memory
BANKM = #5b5c
MEM_PORT = #7ffd

init:
    di
    res 4, (iy + 1)
    
    xor a : call setPage 
    ret

; a - page
setPage:
    or #18 : ld (BANKM), a 
    ld bc, MEM_PORT : out (c), a
    ret

    endmodule