
// Insert header comments

module AHBGPIO(
  input wire HCLK,
  input wire HRESETn,
  input wire [31:0] HADDR,
  input wire [31:0] HWDATA,
  input wire [1:0] HTRANS,
  input wire HWRITE,
  input wire HSEL,
  input wire HREADY,
  input wire [15:0] GPIOIN,
  
	// Output
  output wire HREADYOUT,
  output wire [31:0] HRDATA,
  output wire [15:0] GPIOOUT
  );

  `define DATAREG_ADDR = 8'h5300_0000;
  
  reg [15:0] rOUT;
  reg [15:0] rIN;

  reg [31:0]  rHADDR;
  reg [31:0]  rHWDATA;
  reg [31:0]  rHRDATA;
  reg         rHWRITE;
  reg         rHREADYOUT;

  always @(posedge HCLK or negedge HRESETn) begin
    if(!HRESETn) begin
      rHADDR    <= DATAREG_ADDR;
      rHWDATA   <= 32'h0;
      rHRDATA   <= 32'h0;
      rHWRITE   <= 1'b0;
      rHREADYOUT<= 1'b1;

      rOUT      <= 16'h0;
      rIN       <= 16'h0;
    end

    if (HSEL) begin
      rHADDR	<= HADDR;
      rHWDATA	<= HWDATA;
      rHWRITE <= HWRITE;
    end
  end

  always @(posedge HCLK) begin
    rIN <= GPIOIN;
    if (HSEL) begin
      // If reading
      if ((rHWRITE == 1'b0) && HREADY) begin
        rHREADYOUT <= 1'b1;
        if (rHADDR == DATAREG_ADDR)
          rHRDATA[15:0] <= rIN;
      end
      // If writing
      if (rHWRITE == 1'b1) begin
        rHREADYOUT <= 1'b0;
        if (rHADDR == DATAREG_ADDR)
          rOUT <= rHWDATA[15:0];
      end
    end
  end

  assign GPIOOUT = rOUT;
  assign HRDATA = rHRDATA;
  assign HREADYOUT = rHREADYOUT;

endmodule
