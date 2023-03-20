
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

  output reg rTIMERIRQ
);

  `define LIMITV_ADDR   32'h5200_0000
  `define CURRENTV_ADDR 32'h5200_0004
  `define CONTROL_ADDR  32'h5200_0008

  reg         rHSEL;
  reg [31:0]  rHADDR;
  reg [31:0]  rHRDATA;
  reg         rHWRITE;
  reg         rHREADYOUT;

  reg [31:0]  rLIMITV;
  reg [31:0]  rCURRENTV;
  reg [3:0]   rCONTROL;

  //Prescaled clk signals (HCLK/256)
  wire CLK256;

  //Generate prescaled clk ticks
  prescaler uprescaler256(
    .inCLK(HCLK),
    .outCLK(CLK256)
  );

    // Reset Logic
/*   always @(posedge HCLK, negedge HRESETn)
    if (HRESETn) begin
      rHADDR    <= `LIMITV_ADDR;
      rHRDATA   <= 32'h0;
      rHSEL     <= 1'b0;
      rHWRITE   <= 1'b0;
      rHREADYOUT<= 1'b1;

      rLIMITV   <= 32'hffffffff;
      rCURRENTV <= 32'h0;
      rCONTROL  <= 4'b0011;
    end */

  // Address Phase: Sample bus
  always @(posedge HCLK)
    if (HREADY) begin
      rHSEL   <= HSEL;
      rHADDR	<= HADDR;
      rHWRITE <= HWRITE;
    end
  
  // Timer logic
  always @(posedge HCLK) begin
    rTIMERIRQ <= 1'b0;
    // If timer is 'on'
    if ((rCONTROL & 4'b0001) == 4'b0001)
      // If using prescaler and prescaler clk high, or if not using prescaler
      if ((((rCONTROL & 4'b1000) == 4'b1000) && CLK256) || ((rCONTROL & 4'b1000) == 4'b0000)) begin
        // If timer counting up
        if ((rCONTROL & 4'b0010) == 4'b0010) begin
          rCURRENTV <= rCURRENTV + 1;
          if ((((rCONTROL & 4'b0100) == 4'b0100) && (rCURRENTV >= rLIMITV)) || (((rCONTROL & 4'b0100) == 4'b0000) && (rCURRENTV >= 32'hffffffff)))
            rCURRENTV <= 32'h0;
        end
        // If timer counting down
        else begin
          rCURRENTV <= rCURRENTV - 1;
          if (rCURRENTV == 32'h0)
            if ((rCONTROL & 4'b0100) == 4'b0100)
              rCURRENTV <= rLIMITV;
            else
              rCURRENTV <= 32'hffffffff;
        end
        if (rCURRENTV[7:0] == 8'h00)
          rTIMERIRQ <= 1'b1;
      end

    // Data Phase: Push/Pull to/from bus
    rHREADYOUT  <= 1'b0;
    if (rHSEL)
      if (rHWRITE) begin
        rHREADYOUT  <= 1'b1;
        rHRDATA     <= 32'h0;
        case (rHADDR)
          `LIMITV_ADDR  : rLIMITV   <= HWDATA;
          `CURRENTV_ADDR: rCURRENTV <= HWDATA;
          `CONTROL_ADDR : rCONTROL  <= HWDATA[3:0];
        endcase
      end
      else begin
        rHREADYOUT <= 1'b1;
        case (rHADDR)
          `LIMITV_ADDR  : rHRDATA <= rLIMITV;
          `CURRENTV_ADDR: rHRDATA <= rCURRENTV;
          `CONTROL_ADDR : rHRDATA <= rCONTROL;
        endcase
      end

  end

  //assign HRDATA = rHRDATA;
  assign HRDATA = rCURRENTV;
  assign HREADYOUT = rHREADYOUT;

endmodule