module grayToBinary (
    input logic[7:0] grayValue, 
    output logic[7:0] binaryValue
);
    logic lastXOR;
    always @(posedge grayValue) begin   
        for (integer i = 7; i >= 0; i = i - 1)begin
            if (i == 7) begin
                binaryValue[7] <= grayValue[7];
                lastXOR = grayValue[7];
            end
            else begin
                binaryValue[i] <= grayValue[i] ^ lastXOR;
                lastXOR <= grayValue[i] ^ lastXOR;
            end   
        end 
    end     
endmodule