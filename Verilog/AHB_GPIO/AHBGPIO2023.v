// Very simple GPIO subordinate February 2023.
// Comprises 16-bit output port that may be written 
// to at address 0x53xxxxx4, and 16-bit input port 
// that may be read frintended to be read from at address 
// 0x53xxxxxx.
// These addresses are set in, and consistency must be 
// maintained between, files AHBDCD.v and AHBLITE_SYS.v 

module AHBGPIO(
  input wire HCLK,
  input wire HRESETn,
  input wire [31:0] HADDR,
  input wire [1:0] HTRANS,
  input wire [31:0] HWDATA,
  input wire HWRITE,
  input wire HSEL,
  input wire HREADY,
  input wire [15:0] GPIOIN,
  
	
	//Output
  output wire HREADYOUT,
  output wire [31:0] HRDATA,
  output wire [15:0] GPIOOUT
  );
  
  localparam [7:0] gpio_dataout_addr = 8'h04;
  
  reg [15:0] gpio_dataout;
  reg [15:0] gpio_datain;
  reg [31:0] last_HADDR;
  reg [1:0] last_HTRANS;
  reg last_HWRITE;
  reg last_HSEL;
    
  assign HREADYOUT = 1'b1;
  
// Set Registers from address phase  
  always @(posedge HCLK)
  begin
    if(HREADY)
    begin
      last_HADDR <= HADDR;
      last_HTRANS <= HTRANS;
      last_HWRITE <= HWRITE;
      last_HSEL <= HSEL;
    end
  end
  
  // Update output value
  always @(posedge HCLK, negedge HRESETn)
  begin
    if(!HRESETn)
    begin
      gpio_dataout <= 16'h0000;
    end
    else if ((last_HADDR[7:0] == gpio_dataout_addr) & last_HSEL & last_HWRITE & last_HTRANS[1])
      gpio_dataout <= HWDATA[15:0];
  end
  
  // Update input value
  always @(posedge HCLK, negedge HRESETn)
  begin
    if(!HRESETn)
    begin
      gpio_datain <= 16'h0000;
    end
    else 
    begin
      gpio_datain <= GPIOIN;
    end
      
  end
         
  assign HRDATA[15:0] = gpio_datain;
  assign GPIOOUT = gpio_dataout;

endmodule
