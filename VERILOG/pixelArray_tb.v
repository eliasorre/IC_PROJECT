module testArray;
    parameter numberOfPS = 8;
    inout logic[N-1:0] DataBus;
    logic VBN1 = 1m;
    logic RAMP = 0;
    logic rst = 0;
    logic ers = 0;
    logic exps = 0;
    logic[(N*8)-1: 0] read;

    pixelArray #(N.(4)) pix_array (.VBN1(VBN1), 
            .RAMP(RAMP), 
            .RESET(rst), 
            .ERASE(ers), 
            .READBUS(read), 
            .DATABUS(DataBus));
endmodule
