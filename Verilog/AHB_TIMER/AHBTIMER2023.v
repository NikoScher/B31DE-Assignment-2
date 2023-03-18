
// Insert header comments

module AHBTIMER(
  input wire HCLK,
  input wire HRESETn,
  input wire [31:0] HADDR,
  input wire [31:0] HWDATA,
  input wire [1:0] HTRANS,
  input wire HWRITE,
  input wire HSEL,
  input wire HREADY,
  
  output wire [31:0] HRDATA,
  output wire HREADYOUT,

  output reg timer_irq
);

  `define LIMITV_ADDR   32'h5200_0000
  `define CURRENTV_ADDR 32'h5200_0004
  `define CONTROL_ADDR  32'h5200_0008

  reg timer_irq_next;

  reg [31:0]  rHADDR;
  reg [31:0]  rHWDATA;
  reg [31:0]  rHRDATA;

  reg [31:0]  rLIMITV;
  reg [31:0]  rCURRENTV;
  reg [3:0]   rCONTROL;

  //Prescaled clk signals (HCLK/16)
  wire CLK16;
  reg rCLK16;

  //Generate prescaled clk ticks
  prescaler uprescaler16(
    .inclk(HCLK),
    .outclk(CLK16)
  );

  always @(posedge CLK16)
    rCLK16 = 1'b1;

  always @(negedge CLK16)
    rCLK16 = 1'b0;

  always @(posedge HCLK or negedge HRESETn) begin
    if(!HRESETn) begin
      rHADDR    <= 32'h0;
      rHWDATA   <= 32'h0;
      rHRDATA   <= 32'h0;

      rLIMITV   <= 32'hffffffff;
      rCURRENTV <= 32'h0;
      rCONTROL  <= 4'b0101;
    end

    if (HSEL) begin
      rHADDR	<= HADDR;
      rHWDATA	<= HWDATA;
      if (HWRITE) begin
        if (rHADDR == LIMITV_ADDR)
          rLIMITV <= rHWDATA;
        if (rHADDR == CONTROL_ADDR)
          rCONTROL <= rHWDATA[3:0];
      end
    end
  end
  
  always @(posedge HCLK) begin
    if (HSEL && HREADY)
      rHRDATA <= rCURRENTV;

    if ((rCONTROL & 4'b0001) == 4'b0001) begin
      if ((((rCONTROL & 4'b1000) == 4'b1000) && (rCLK16 == 1'b1)) || (((rCONTROL & 4'b1000) == 4'b0000) && (rCLK16 == 1'b0))) begin
        if ((rCONTROL & 4'b0010) == 4'b0010) begin
          rCURRENTV <= rCURRENTV + 1;
          if ((((rCONTROL & 4'b0100) == 4'b0100) && (rCURRENTV == rLIMITV)) && (((rCONTROL & 4'b0100) == 4'b0000) && (rCURRENTV == 32'hffffffff))) begin
            //Interupt cause hit limit
            rCURRENTV <= 32'h0;
          end
        end
        else begin
          rCURRENTV <= rCURRENTV - 1;
          if (rCURRENTV == 32'h0) begin
            //Interupt cause hit limit
            if ((rCONTROL & 4'b0100) == 4'b0100)
              rCURRENTV <= rLIMITV;
            else
              rCURRENTV <= 32'hffffffff;
          end
        end
        // Interupt cause value changed
      end
    end
  end

  assign HRDATA = rHRDATA;
  assign HREADYOUT = 1'b1;

endmodule