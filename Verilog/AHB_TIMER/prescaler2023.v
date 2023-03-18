
// Insert header comments

module prescaler(
  input wire inCLK,

  output wire outCLK
);

reg [7:0] rCOUNTER;

always @(posedge inCLK) begin
  rCOUNTER <= rCOUNTER + 1'b1;
  if (rCOUNTER == 8'hff)
    rCOUNTER <= 8'h0;
end
  
assign outCLK = rCOUNTER == 8'hf0;

endmodule
