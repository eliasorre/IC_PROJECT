module pixelTop(
    input  logic              clk,
    input  logic              reset,
    output logic[(N*8)-1:0]   pixelDataOut);

    parameter integer H = 4;
    parameter integer W = 4;
    parameter integer N = 16;
    parameter real dv_pixel = 0.5;
    integer i = 0; 
    integer y = 0; 



    //Analog signals
    logic              anaBias1;
    logic              anaRamp;
    logic              anaReset;
   
    //Tie off the unused lines
    assign anaReset = 1;

    //Digital
    wire                erase;
    wire                expose;
    tri[(H-1):0]        readBus;
    wire                convert;
    logic[(8*N)-1:0]    startI;
    // Data-nodes for each pixel
    tri[(8*N)-1:0]      pixData;

    // GrayCounter
    logic[7:0]          grayCounter;
    GRAYCOUNTER graycount(.clk(clk), .grayClk(grayCounter), .reset(reset), .convert(convert));
   
    // Readoutbuses 
   logic[(8*W)-1:0] grayBus;
   logic[(8*W)-1:0] binaryBus;

    pixelSensorFsm #(.c_erase(5),.c_expose(255),.c_convert(255),.c_read(5), .H(H))
    fsm(.clk(clk),.reset(reset),.erase(erase),.expose(expose),.read(readBus),.convert(convert));

    pixelArray #(.H(H), .W(W), .N(N)) pixArr(
        .VBN1(anaBias1), 
        .RAMP(anaRamp), 
        .RESET(anaReset), 
        .ERASE(erase), 
        .EXPOSE(expose),
        .READBUS(readBus), 
        .DATABUS(pixData));



    //------------------------------------------------------------
   // DAC and ADC model
   //------------------------------------------------------------

  
   generate 
      for (genvar j = 0; j < W; j = j +1 ) begin
         GRAYTOBINARY conv(.grayValue(grayBus[(8*j)+:8]), .binaryValue(binaryBus[(8*j)+: 8]), .clk(clk), .reset(reset));
      end
      for (genvar j = 0; j < H; j = j + 1) begin
         for (genvar x = 0; x < W; x = x +1) begin 
            assign pixData[((8*x) + (j*W * 8))+:8] = readBus[j] ? 8'bZ: grayCounter;
         end 
      end
   endgenerate
   // If we are to convert, then provide a clock via anaRamp
   // This does not model the real world behavior, as anaRamp would be a voltage from the ADC
   // however, we cheat
   assign anaRamp = convert ? clk : 0;

   // During expoure, provide a clock via anaBias1.
   // Again, no resemblence to real world, but we cheat.
   assign anaBias1 = expose ? clk : 0;

   //------------------------------------------------------------
   // Readout from databus
   //------------------------------------------------------------
   always @(posedge clk or posedge reset) begin
      if(reset) begin
         pixelDataOut = 0;
      end
      else begin
         // Inserting the values from pixel-adress in Databus into the correct pixel-adress in dataOut
         for (i = 0; i < H; i = i + 1) begin
            if (readBus[i]) begin
               for (y = 0; y < W; y = y +1) begin
                  grayBus[(8*y)+:8] <= pixData[((8*y) + (i*W*8))+:8]; 
                  pixelDataOut[((8*y) + (i*W * 8))+:8] <= binaryBus[(8*y) +: 8];
               end 
            end 
        end
      end
   end
endmodule