module grayCounter (
    input logic[7:0] clk,
    output logic[7:0] grayClk, 
    input logic reset
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            grayClk <= 0;
        end         
        else begin 
            for (integer i = 0; i < 8; i = i + 1)begin
                if (i == 7) begin
                    grayClk[7] <= clk[7];
                end
                else begin
                    grayClk[i] <= clk[i] ^ clk[i +1];
                end   
            end 
        end
    end     
endmodule