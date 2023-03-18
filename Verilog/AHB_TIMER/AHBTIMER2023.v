// Very simple timer (counter) February 2023
//
// 32-bit register increments at rate of prescaled HCLK.
// value of register is assigned to HRDATA.
// Any address 0x52xxxxxx will switch the HRDATA output of this
// subordinate to the AHBLITE bus multiplexer output.
// These address range is set in, and consistency must be 
// maintained between, files AHBDCD.v and AHBLITE_SYS.v 
// AHBLITE bus address, control signals, and HSEL are ignored by
// this module which is a sloppy means of implementation.
// HRESETn will zero counter.

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

  //`define LIMITV_ADDR   32'h5200_0000
  //`define CURRENTV_ADDR 32'h5200_0004
  //`define CONTROL_ADDR  32'h5200_0008

  reg [31:0]  rHADDR;
  reg [31:0]  rHWDATA;
  reg [31:0]  rHRDATA;

  reg [31:0]  rLIMITV;
  reg [31:0]  rCURRENTV;
  reg [3:0]   rCONTROL;

  reg timer_irq_next;

  //Prescaled clk signals (HCLK/16)
  wire clk16;

  //Generate prescaled clk ticks
  prescaler uprescaler16(
    .inclk(HCLK),
    .outclk(clk16)
  );

  always @(posedge HCLK || negedge HRESETn) begin
    if(!HRESETn) begin
      rHADDR	  <= 32'h0;
      rHWDATA	  <= 32'h0;
      rHRDATA   <= 32'h0;

      rLIMITV   <= 32'h0;
      rCURRENTV <= 32'h0;
      rCONTROL  <= 4'b0001;
    end

    if (HSEL) begin
      rHADDR	<= HADDR;
      rHWDATA	<= HWDATA;
      if (HWRITE) begin
        if (rHADDR == 32'h5200_0000) begin
          rLIMITV <= rHWDATA;
        end
        if (rHADDR == 32'h5200_0008) begin
          rCONTROL <= rHWDATA[3:0];
        end
      end
    end
  end
  
  always @(posedge HCLK) begin
    if (HSEL && HREADY) begin
      rHRDATA <= rCURRENTV
    end

    if ((rCONTROL & 4'b1000) == 4'b0000) begin
      if ((rCONTROL & 4'b0001) == 4'b0001) begin
        if ((rCONTROL & 4'b0010) == 4'b0010) begin
          rCURRENTV <= rCURRENTV + 1;
          if (((rCONTROL & 4'b0100) == 4'b0100) && (rCURRENTV == rLIMITV)) begin
            //Interupt
            rCURRENTV <= 32'h0;
          end
          if (((rCONTROL & 4'b0100) == 4'b0000) && (rCURRENTV == 32'hffffffff)) begin
            //Interupt
            rCURRENTV <= 32'h0;
          end
        end
        else begin
          rCURRENTV <= rCURRENTV - 1;
          if (rCURRENTV == 32'h0) begin
            //Interupt
            if ((rCONTROL & 4'b0100) == 4'b0100) begin
              rCURRENTV <= rLIMITV;
            end
            else begin
              rCURRENTV <= 32'hffffffff;
            end
          end
        end
      end
    end
  end

  always @(posedge clk16) begin
    if ((rCONTROL & 4'b1000) == 4'b1000) begin
      if ((rCONTROL & 4'b0001) == 4'b0001) begin
        if ((rCONTROL & 4'b0010) == 4'b0010) begin
          rCURRENTV <= rCURRENTV + 1;
          if (((rCONTROL & 4'b0100) == 4'b0100) && (rCURRENTV == rLIMITV)) begin
            //Interupt
            rCURRENTV <= 32'h0;
          end
          if (((rCONTROL & 4'b0100) == 4'b0000) && (rCURRENTV == 32'hffffffff)) begin
            //Interupt
            rCURRENTV <= 32'h0;
          end
        end
        else begin
          rCURRENTV <= rCURRENTV - 1;
          if (rCURRENTV == 32'h0) begin
            //Interupt
            if ((rCONTROL & 4'b0100) == 4'b0100) begin
              rCURRENTV <= rLIMITV;
            end
            else begin
              rCURRENTV <= 32'hffffffff;
            end
          end
        end
      end
    end
  end

  assign HRDATA = rHRDATA;
  assign HREADYOUT = 1'b1;

endmodule
