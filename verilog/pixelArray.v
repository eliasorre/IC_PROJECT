module pixelArray (
        input VBN1,
        input RAMP,
        input RESET,
        input ERASE,
        input EXPOSE,
        input [(H-1):0] READBUS,
        inout [(N*8 - 1):0] DATABUS
    );
    parameter integer N=4;
    parameter real    dv_pixel = 0.5;
    parameter integer W=4;
    parameter integer H=4;

    genvar i;
    genvar j;
    generate 
        for (i = 0; i < H; i = i + 1) begin
            for (j = 0; j < W; j = j +1) begin 
                PIXEL_SENSOR s(
                .VBN1(VBN1), 
                .RAMP(RAMP), 
                .RESET(RESET), 
                .ERASE(ERASE),
                .EXPOSE(EXPOSE), 
                .READ(READBUS[i]), 
                .DATA(DATABUS[(8*W*i)+ (j*8)+: 8]));
            end 
        end
    endgenerate
endmodule