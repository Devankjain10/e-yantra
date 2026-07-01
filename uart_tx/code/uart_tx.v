// MazeSolver Bot: Task 2B - UART Transmitter
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.

This file is used to generate UART Tx data packet to transmit the messages based on the input data.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

/*
Module UART Transmitter

Input:  clk_3125 - 3125 KHz clock
        parity_type - even(0)/odd(1) parity type
        tx_start - signal to start the communication.
        data    - 8-bit data line to transmit

Output: tx      - UART Transmission Line
        tx_done - message transmitted flag


        Baudrate : 115200 bps
*/

// module declaration
module uart_tx(
    input clk_3125,
    input parity_type,tx_start,
    input [7:0] data,
    output reg tx, tx_done
);

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE//////////////////


reg  [4:0] counter;
reg  [3:0] bit_counter;
reg        parity_calc; 

initial 
	begin
		counter =   0;
		bit_counter = 0;
		parity_calc = 0;
		tx = 1'b1;
		tx_done = 0;
	end
	
always @(posedge clk_3125) 
	begin
		if(tx_start) 
			 begin
				counter <= counter + 1'b1;
				bit_counter <= bit_counter + 1'b1;
				parity_calc <= parity_type;
				tx_done <= 1'b0;
				tx <= 1'b0;
			 end
		if(bit_counter)
			begin
				if(counter < 27 - 1)
					begin
						counter <= counter + 1'b1;
					end
				else
					begin
					counter <= 1'b0;
					if(bit_counter == 1'b1)
						begin
							bit_counter <= bit_counter + 1'b1;
							tx <= data[7-bit_counter];
						end
					if(bit_counter < 4'b1000)
						begin
							bit_counter <= bit_counter + 1'b1;
							tx <= data[7-bit_counter];
							parity_calc <= parity_calc ^ data[7-bit_counter];
						end
					if(bit_counter == 4'b1001)
						begin
							tx <= parity_calc;
							bit_counter <= bit_counter + 1'b1;
						end
					if(bit_counter == 4'b1010)
						begin
							tx <= 1'b1;
							bit_counter <= 1'b0;
							tx_done <= 1'b1;
						end
					end
	
			end
		
		
	end


//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE//////////////////

endmodule