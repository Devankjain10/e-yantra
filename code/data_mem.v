
// data_mem.v - data memory

module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
    input       clk, wr_en,
	 input [2:0]     func3,
    input       [ADDR_WIDTH-1:0] wr_addr, wr_data,
    output      [DATA_WIDTH-1:0] rd_data_mem
);

// array of 64 32-bit words or data
reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];

// combinational read logic
// word-aligned memory access
assign rd_data_mem = data_ram[wr_addr[DATA_WIDTH-1:2]];

// synchronous write logic
always @(posedge clk) begin
    if (wr_en) begin        
	            case(func3)
					3'b000: data_ram[wr_addr[DATA_WIDTH-1:2] ][7:0] <= wr_data[7:0];
					3'b001: data_ram[wr_addr[DATA_WIDTH-1:2] ][15:0] <= wr_data[15:0];
					3'b010: data_ram[wr_addr[DATA_WIDTH-1:2] ] <= wr_data;		
					endcase
					end
end

endmodule

