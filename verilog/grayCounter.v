module GRAYCOUNTER (
    input clk,
    output logic[7:0] grayClk, 
    input logic reset,
    input logic convert
);
    logic[7:0] qunt;    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            qunt <= 0; 
            grayClk <= 0;
        end
        if (convert) begin
            qunt += 1;
        end
        else begin
            qunt <= 0;
        end
        for (integer i = 0; i < 7; i = i + 1) begin
            grayClk[i] <= qunt[i] ^ qunt[i +1];
        end 
        grayClk[7] <= qunt[7];
    end       
endmodule