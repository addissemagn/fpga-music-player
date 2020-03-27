module controlPath(
						 input clock,
						 input resetn,
						 
						 input play,
						 input audio_out_allowed,
						 input stop,
						 
						 output reg write_audio_out,
						 output reg increment,
						 output reg ld_address,
						 output reg clear_buffer
						 );
	reg [1:0] current_state, next_state;
	
	localparam 
	S_IDLE = 2'd0,
	S_INCREMENT = 2'd1,
	S_WAIT = 2'd3;
	
	always @ (posedge clock)begin
		if (!resetn) current_state <= S_IDLE;
		else current_state <= next_state;
	end
	
	always @(*) begin
		next_state = current_state;
		write_audio_out = 1'b0;
		increment = 1'b0;
		ld_address = 1'b0;
		clear_buffer = 1'b0;
		
		case(current_state)
			S_IDLE: begin
				clear_buffer = 1'b1;
				
				if(play) begin
					ld_address = 1'b1;
					increment = 1'b0;
					next_state = S_INCREMENT;
				end
			end
			
			S_INCREMENT: begin
				ld_address = 1'b0;
				if(!play) next_state = S_IDLE;
				else if(stop) next_state = S_WAIT;
				else begin
					if(audio_out_allowed) begin
						increment = 1'b1;
						ld_address = 1'b1;
						write_audio_out = 1'b1;
					end
					
					else begin
						increment = 1'b1;
						ld_address = 1'b0;
						write_audio_out = 1'b0;
					end
				end
			end
			
			S_WAIT:begin
			if(!play) next_state = S_IDLE;
			end
		endcase
	end
				
endmodule

module controlPathHoldSound(
						 						 input clock,
						 input resetn,
						 
						 input play,
						 input audio_out_allowed,
						 input stop,
						 
						 output reg write_audio_out,
						 output reg increment,
						 output reg ld_address,
						 output reg clear_buffer
						 );
	reg [1:0] current_state, next_state;
	
	localparam 
	S_IDLE = 2'd0,
	S_INCREMENT = 2'd1,
	S_HOLD = 2'd3;
	
	always @ (posedge clock)begin
		if (!resetn) current_state <= S_IDLE;
		else current_state <= next_state;
	end
	
	always @(*) begin
		next_state = current_state;
		write_audio_out = 1'b0;
		increment = 1'b0;
		ld_address = 1'b0;
		clear_buffer = 1'b0;
		
		case(current_state)
			S_IDLE: begin
				clear_buffer = 1'b1;
				
				if(play) begin
					ld_address = 1'b1;
					increment = 1'b0;
					next_state = S_INCREMENT;
				end
			end
			
			S_INCREMENT: begin
				ld_address = 1'b0;
				if(!play) next_state = S_IDLE;
				else if(stop) next_state = S_HOLD;
				else begin
					if(audio_out_allowed) begin
						increment = 1'b1;
						ld_address = 1'b1;
						write_audio_out = 1'b1;
					end
					
					else begin
						increment = 1'b1;
						ld_address = 1'b0;
						write_audio_out = 1'b0;
					end
				end
			end
			
			S_HOLD:begin
				if(play) begin
					ld_address = 1'b1;
					increment = 1'b0;
					next_state = S_INCREMENT;
				end
				else if (!play) next_state = S_IDLE;
			end
		endcase
	end
				
endmodule 


module dataPath(
					input clock,
					input resetn,
					
					input [9:0] audio_in,
					
					input [19:0] address_max,
					input ld_address,
					input increment,
					
					output stop,
					output reg [9:0] audio_out, // how big
					output reg [19:0] address,
					
					output reg up
	);
	
	reg [9:0] prev_audio;
	always @ (posedge clock) begin
		if(!resetn)
			prev_audio <= 10'b0;
		else
		prev_audio <= audio_out;
	end
	
	
	assign stop = (address == address_max);
	
	always @ (posedge clock) begin
		
		if(ld_address) begin
			if(!increment) address <= 20'd0;
			else address <= address + 20'd1;
		end
		
	end
	
	always @(*) begin
		if(ld_address) audio_out = audio_in;
		else audio_out = 10'b0;
	end
	always @(*) begin
		if(ld_address && prev_audio < audio_out) up = 1'b1;
		else up = 1'b0;
	end
	
endmodule
