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

  reg [31:0] value;
  reg [31:0] value_next;

  reg timer_irq_next;

  //Prescaled clk signals
  wire clk16;       // HCLK/16

  //Generate prescaled clk ticks
  prescaler uprescaler16(
    .inclk(HCLK),
    .outclk(clk16)
  );

  always @(posedge HCLK, negedge HRESETn)
    if(!HRESETn)
      begin
        value <= 32'h0000_0000;
	  timer_irq <= 1'b0;
      end
    else
      begin
        timer_irq <= timer_irq_next;
        value <= value_next;
        if (value_next[7:0] == 8'b00000000)
          timer_irq_next = 1; else timer_irq_next = 0;
      end

  always @(posedge clk16)
  begin
   value_next <= value+1;
end
  
  assign HRDATA = value;
  assign HREADYOUT = 1'b1;

endmodule
