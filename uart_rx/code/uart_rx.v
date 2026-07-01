
module uart_rx(
    input clk_3125,
    input rx,
    output reg [7:0] rx_msg,
    output reg rx_parity,
    output reg rx_complete
    );

initial begin
    rx_msg = 8'b0;
    rx_parity = 1'b0;
    rx_complete = 1'b0;
end
//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////
reg            state;
reg [8:0]    message;
reg [4:0]    counter;
reg [3:0]   data_bit;
reg 			  parity;


initial begin
	state <= 1'b0;
	counter <= 1'b0;
	data_bit <= 0;
	parity <= 0;
end

always @(posedge clk_3125) begin
	case(state)
	
	1'b0: begin
				rx_complete <= 1'b0;
				if(rx==1'b1)
					begin
						state <=   1'b0;
						counter <= 0;
					end
				else 
					begin
						if(counter<27-1) counter <= counter + 1'b1;
						else
							begin
								counter = 1'b0;
								state <= 1'b1;
								parity <= 1'b0;
//								$display("entering state 2");
							end
				   end	
			end
			
	1'b1: begin
            rx_complete <= 0;
				if(counter<27-1)
					begin
						counter <= counter+1'b1;
					end
				else
					begin
						counter <= 1'b0;
						data_bit <= data_bit + 1'b1;
//						$display("data_bit",data_bit);
						if(data_bit<9) message[8-data_bit] <= rx;
						if(data_bit<8) parity <= parity ^ rx;
						if(data_bit == 9) rx_complete <= 1'b1;
//						if(data_bit==9) $display("rx: ",rx);
						if(data_bit == 4'b1001 && rx == 1'b1)
							begin
//							   $display("going back to state 1");
								state <= 1'b0;
								data_bit <= 0;
								rx_parity <= parity ;
								rx_msg <= message [8:1];
							end
					end

			end
	
	endcase
	
	
end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule
