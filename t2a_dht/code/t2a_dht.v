
module t2a_dht(
    input clk_50M,
    input reset,
    inout sensor,
    output reg [7:0] T_integral,
    output reg [7:0] RH_integral,
    output reg [7:0] T_decimal,
    output reg [7:0] RH_decimal,
    output reg [7:0] Checksum,
    output reg data_valid
);

    initial begin
        T_integral = 0;
        RH_integral = 0;
        T_decimal = 0;
        RH_decimal = 0;
        Checksum = 0;
        data_valid = 0;
    end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////

reg [19:0] count;
reg [5:0] bit_count;
reg [39:0] message;
reg [1:0] state;
reg data_in;
reg enable;

assign sensor = (enable) ? data_in : 1'bz;

always @(posedge clk_50M) begin
	if(~reset) begin
		count<=20'b0;
		state<=2'b00;
		bit_count<=6'b0;
		data_in<=1'b0;
		enable<= 1'b0;
	end
	else begin
	case (state)
	2'b00: begin
				data_valid <= 1'b0;
				enable <= 1'b1;
				if(count<900000-1)
					begin
						count <= count+1'b1;
						data_in <= 1'b0;
					end
				else if(count<902000-1)
					begin
						count <= count+1'b1;
						data_in <= 1'b1;
					end
				else
					begin
						state <= 2'b01;
						count <= 1'b0;
						enable <= 1'b0;
					end
				end
					
					
	2'b01: begin
				if(count < 8000-1)
					begin
						count <= count + 1'b1;
					end
				
				else 
					begin
						state <=	2'b10;
						count <= 20'b0;
					end
					
			end
			
			
			
	2'b10: begin
				if (bit_count < 40)
					begin
						if (count < 3800-1) count <= count + 1'b1;
						else if (sensor==1'b0 || sensor === 1'bz) 
							begin
								count <= 20'b1;
								bit_count <= bit_count+1'b1;
								message[39-bit_count] <= 1'b0;
							end
						else if(count<6000-1) count <= count + 1'b1;
						else
							begin
								count <= 20'b0;
								bit_count <= bit_count + 1'b1;
								message[39-bit_count] <= 1'b1;
							end			
					end
				else state <= 2'b11;
			end
					
	2'b11: begin	
					if(count < 2) begin
					count <= count + 1'b1;
					end
					else begin
						RH_integral <= message[39:32];
						RH_decimal <= message[31:24];
						T_integral <= message[23:16];
						T_decimal <= message[15:8];
						Checksum <= message[7:0];
						data_valid <= (message[7:0] == ((message[15:8] + message[23:16] + message[31:24] + message[39:32]) & 8'hFF));
						bit_count <= 1'b0;
						count <= 1'b0;
						state <= 2'b00;
						end
			end
	
	
	endcase	
	end
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////
  
endmodule
