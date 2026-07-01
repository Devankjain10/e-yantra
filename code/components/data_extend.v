module data_extend(
input [2:0] func3,
input [31:0] rd_data,
output reg [31:0] rd_extend

);


always @(*) begin 
	case(func3)
	3'b000: rd_extend <= {{24{rd_data[7]}},rd_data[7:0]};
	3'b001: rd_extend <= {{16{rd_data[15]}},rd_data[15:0]};
	3'b010: rd_extend <= rd_data;
	3'b100: rd_extend <= {{24{1'b0}},{rd_data[7:0]}};
	3'b101: rd_extend <= {{16{1'b0}},{rd_data[15:0]}};
	default: rd_extend <= 32'bx; // undefined
	endcase

end

endmodule