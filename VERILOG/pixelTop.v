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
    tri[(8*W)-1:0]      GrayBus; //  We need this to be a wire, because we're tristating it
    tri[(8*W)-1:0]      BinBus;
    logic[7:0]          grayCounter;
    logic[7:0] data;

   // GrayCounter
    grayCounter graycount(.clk(data), .grayClk(grayCounter), .reset(reset));
   // GrayConverters
    generate 
      for (genvar k = 0; k < W; k = k +1) begin
         grayToBinary conv (.grayValue(GrayBus[(k*8)+:8]), .binaryValue(BinBus[(k*8)+:8]));
      end
   endgenerate
    

    pixelSensorFsm #(.c_erase(5),.c_expose(255),.c_convert(255),.c_read(5), .H(H))
    fsm(.clk(clk),.reset(reset),.erase(erase),.expose(expose),.read(readBus),.convert(convert));

    pixelArray #(.H(H), .W(W), .N(N)) pixArr(
        .VBN1(anaBias1), 
        .RAMP(anaRamp), 
        .RESET(anaReset), 
        .ERASE(erase), 
        .EXPOSE(expose),
        .READBUS(readBus), 
        .DATABUS(GrayBus));



    //------------------------------------------------------------
   // DAC and ADC model
   //------------------------------------------------------------
  

   // If we are to convert, then provide a clock via anaRamp
   // This does not model the real world behavior, as anaRamp would be a voltage from the ADC
   // however, we cheat
   assign anaRamp = convert ? clk : 0;

   // During expoure, provide a clock via anaBias1.
   // Again, no resemblence to real world, but we cheat.
   assign anaBias1 = expose ? clk : 0;

   // If we're not reading the pixData, then we should drive the bus
   generate
      for (genvar x = 0; x < H; x = x + 1) begin 
         for (genvar j = 0; j < W; j = j +1) begin
            assign GrayBus[((8*j) + (x*W * 8))+:8] = readBus[x] ? 8'bZ: grayCounter;
         end  
      end
   endgenerate

   // When convert, then run a analog ramp (via anaRamp clock) and digtal ramp via
   // data bus.
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         data =0;
      end
      if(convert) begin
         data +=  1;
      end
      else begin
         data = 0;
      end
   end // always @ (posedge clk or reset)

   //------------------------------------------------------------
   // Readout from databus
   //------------------------------------------------------------
   always_ff @(posedge clk or posedge reset) begin
      if(reset) begin
         pixelDataOut = 0;
      end
      else begin
         // Inserting the values from pixel-adress in Databus into the correct pixel-adress in dataOut
         for (i = 0; i < H; i = i + 1) begin
            if (readBus[i]) begin
               for (y = 0; y < W; y = y +1) begin
                  pixelDataOut[((8*y) + (i*W * 8))+:8] <= BinBus[(8*y)+:8];
               end 
            end 
        end
      end
   end
endmodule