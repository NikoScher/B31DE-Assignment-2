
// Insert header comments

module prescaler(
  input wire inCLK,

  output wire outCLK
);

`define PRESCALE 8'hf0

reg [7:0] rCOUNTER;

always @(posedge inCLK)
  rCOUNTER <= rCOUNTER + 1'b1;
  
assign outCLK = rCOUNTER == `PRESCALE;

endmodule
