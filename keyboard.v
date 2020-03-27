module keyboard_top(input clock,
						  input resetn,
						  
						  input received_data_en,
						  input [7:0] last_data_received,
						  
						  input [7:0] make,
						  
						  output [2:0] play);
	
	
	wire [2:0]kit_select;
	wire play0, play1, play2;
	
	
	kitSelecter select(.clock(clock), .resetn(resetn), .last_data_received(last_data_received), .kit_select(kit_select));
	
	keyboard_control sound0(.clock(clock), .resetn(resetn), .received_data_en(received_data_en), .last_data_received(last_data_received),
									.make(make), .play(play0));
	keyboard_control sound1(.clock(clock), .resetn(resetn), .received_data_en(received_data_en), .last_data_received(last_data_received),
									.make(make), .play(play1));
	keyboard_control sound2(.clock(clock), .resetn(resetn), .received_data_en(received_data_en), .last_data_received(last_data_received),
									.make(make), .play(play2));
									
	assign play = kit_select & {play2, play1, play0};
//	always@(*) begin
//		if(kit_select == 3'b001)
//			play = {0, 0, play0};
//		else if(kit_select == 3'b010)
//			play = {0, play1, 0};
//		else if(kit_select == 3'b100)
//			play = {play2, 0, 0};
//	end

endmodule

module kitSelecter(input clock,
						 input resetn,
						 
						 input [7:0] last_data_received,
						 
						 output reg [2:0] kit_select
						 );
	
	reg [1:0] current_state, next_state;
	
	localparam
	S_KIT_0 = 2'd0,
	S_KIT_1 = 2'd1,
	S_KIT_2 = 2'd2;
	
	always @ (posedge clock)begin
		if (!resetn) current_state <= S_KIT_0;
		else current_state <= next_state;
	end
	
	always@(*) begin
		next_state = current_state;
		kit_select = 3'b0;
		
		case(current_state)
			S_KIT_0: begin
				if(last_data_received == 7'h1E) begin
					kit_select = 3'b010;
					next_state = S_KIT_1;
				end
//				else if(last_data_received == 7'h26) begin
//					kit_select = 3'b100;
//					next_state = S_KIT_2;
//				end
				else
					kit_select = 3'b001;
			end
		
			S_KIT_1: begin
				if(last_data_received == 7'h16) begin
					kit_select = 3'b001;
					next_state = S_KIT_0;
				end
//				else if(last_data_received == 7'h26) begin
//					kit_select = 3'b100;
//					next_state = S_KIT_2;
//				end
				else
					kit_select = 3'b010;
			end
			
//			S_KIT_2: begin
//				if(last_data_received == 7'h16) begin
//					kit_select = 3'b001;
//					next_state = S_KIT_0;
//				end
//				else if(last_data_received == 7'h1E) begin
//						kit_select = 3'b010;
//						next_state = S_KIT_1;
//				end
//				else
//					kit_select = 3'b100;
//			end
		endcase
	end
endmodule

						 

module keyboard_control(input clock,
					  input resetn,
					  
					  input received_data_en,
					  input [7:0] last_data_received,
					  
					  input [7:0] make,
					  
					  output reg play
					  );
	reg [1:0] current_state, next_state;
	
	localparam 
	S_IDLE = 2'd0,
	S_PLAY = 2'd1,
	S_BREAK_CHECK = 2'd2;
	
	always @ (posedge clock)begin
		if (!resetn) current_state <= S_IDLE;
		else current_state <= next_state;
	end
	
	always @(posedge received_data_en) begin
		next_state = current_state;
		
		case(current_state)
			S_IDLE: begin
				if(last_data_received == make) begin
					next_state = S_PLAY;
					play = 1'b1;
				end
			end
			
			S_PLAY: begin
				if(last_data_received == 8'hF0)
					next_state = S_BREAK_CHECK;
			end
			
			S_BREAK_CHECK: begin
				play = 1'b1;
				if(last_data_received == 8'hF0)
					next_state = current_state;
				else if(last_data_received == make) begin
					next_state = S_IDLE;
					play = 1'b0;
				end
				else
					next_state = S_PLAY;
			end

			
		endcase
	end
endmodule
