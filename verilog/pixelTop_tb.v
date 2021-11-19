
`timescale 1 ns / 1 ps
module pixelTop_tb;
    // Width of pixel array
    parameter W = 3;
    // Height of pixel array
    parameter H = 2;
    // Total size of pixel array
    parameter N = (H*W);
    
    //Set the expected photodiode current (0-1)
    parameter real  dv_pixel = 0.5;  
    
    // Data from the pixel-array
    logic[(8*N)-1:0] DataOut; 
    
    //pixelTop Module
    pixelTop #(.N(N), .dv_pixel(dv_pixel), .H(H), .W(W)) pixtop (.pixelDataOut(DataOut), .clk(clk), .reset(reset)); 
    
    
    // Testbench clock
    logic clk =0;
    logic reset =0;
    parameter integer clk_period = 500;
    parameter integer sim_end = clk_period*2400;
    always #clk_period clk=~clk;

    
    // For easier visualization
    // logic[7:0] pixel1Data;
    // logic[7:0] pixel2Data;
    // logic[7:0] pixel3Data;
    // logic[7:0] pixel4Data;

    
   //------------------------------------------------------------
   // Testbench stuff
   //------------------------------------------------------------
   initial
     begin
        reset = 1;

        #clk_period  reset=0;
        $monitor("Hello bitch");
        $dumpfile("pixelTop.vcd");
        $dumpvars(0, pixelTop_tb);

        #sim_end
          $stop;

     end

endmodule
