module GRAYTOBINARY (
    input logic[7:0] grayValue, 
    output logic[7:0] binaryValue,
    input logic clk,
    input logic reset
);
    logic lastXOR;
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            binaryValue <= 0; 
            lastXOR <= 0;
        end
        binaryValue[7] <= grayValue[7];
        lastXOR <= grayValue[7];
        for (integer i = 0; i < 6; i = i + 1) begin
            binaryValue[(i-6)] <= grayValue[(6-i)] ^ lastXOR;
        end 
    end         
endmodule