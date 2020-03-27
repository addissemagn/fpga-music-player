// features to add? : gradient colour, blocks instead of constant stream

module animation(
					input Clock, 
					input Resetn, 
					input play, 
					input key_pressed, 
					input done,
					
					output [7:0] X_out, 
					output [6:0] Y_out, 
					output reg dy
	);
	wire delay60;
	wire frame15;
	wire frameFASTER;
	
	reg stop_incrementing;
	reg y_erase;
	
	always @(posedge Clock)
	begin
		stop_incrementing <= 1'b0;
		y_erase <= 1'b0;
		
		if(key_pressed == 1'b0) begin // done is actually inverted signal
																		y_erase <= 1'b1;
																		dy <= 1; 							// bar goes down
			if(Y_out == 7'd73)									stop_incrementing <= 1'b1;
		end
		else if(Y_out == 7'd73 && play == 1'b0) 			stop_incrementing <= 1'b1;		// lower limit of bar
		else if (play == 1'b0) 									dy <= 1; 							// bar goes down
		else if(Y_out == 7'd21 && play == 1'b1) 			stop_incrementing <= 1'b1;		// WHEN U CHANGE THIS LIMIT, ALSO CHANGE IN YCOUNTER
		else if (play == 1'b1 && key_pressed == 1'b1) 	dy <= 0; 							// bar goes up
	end
	
	///////////////////////////////////////////////////////////////////////////////////////////////////////
	assign X_out = 8'b0; // x not incremented
	
	wire frame_to_use;
	assign frame_to_use = (!y_erase | !dy) ? frame15: frameFASTER; // y_erase or bar going down just makes it faster
	
	ycounter ycounter(
		.Clock(Clock),
		.reset(Resetn),
		.WriteEnable(frame_to_use),
		.play(play), // tester
		.y_erase(y_erase),
		.stop_incrementing(stop_incrementing),
		.CountUp(dy),
		.Q(Y_out)
	);
	
	framecounter frame1( // lol not even 15 anymore
		.Clock(Clock), 
		.Resetn(Resetn), 
		.Enable(delay60), 
		.Pulse_out(frame15)
	);
	
	framecountererase frame2(
		.Clock(Clock), 
		.Resetn(Resetn), 
		.Enable(delay60), 
		.Pulse_out(frameFASTER)
	);
	
	modifiedclock mc(
		.Clock(Clock), 
		.Resetn(Resetn), 
		.Enable_out(delay60)
	);
endmodule

module ycounter(Clock, reset, WriteEnable, play, y_erase, load_y, stop_incrementing, CountUp, Q); 
	input Clock, reset, WriteEnable, CountUp, play, stop_incrementing;
	
	output reg [6:0] Q = 7'd21; // initializes y_out to start at 21 and not 0, as animation doesn't take up whole screen height
	
	input load_y; // tester
	input y_erase; // testing
	
	always @(posedge Clock)
	begin
			if (reset == 1'b0)
				Q <= 7'd80; 
			else if (WriteEnable == 1'b1) // writeEnable = frameCounterOutput
			begin
				if(stop_incrementing)
					Q <= Q;
				else if(CountUp == 1'b1)
					Q <= Q + 1;
				else if(CountUp == 1'b0)
					Q <= Q - 1;
			end
	end
endmodule
	
module modifiedclock(
					input Clock, 
					input Resetn, 
					output reg Enable_out
	);
	
	reg [19:0] Q;

	always @(posedge Clock)
	begin
		Enable_out <= 0;
		if (Resetn == 1'b0)
			Q <= 20'd30_000;
		else if (Q == 20'b0)
			begin
				Enable_out <= 1;
				Q <= 20'd30_000; // rate determined from visual obervation of how i want the animation to look
			end
		else
			Q <= Q - 1;
	end
endmodule

module framecounter(
					input Clock, 
					input Resetn, 
					input Enable, 
					output reg Pulse_out
	);
	
	reg [3:0] Q;
	
	always @(posedge Clock)
	begin
		Pulse_out <= 1'b0;
		if (Resetn == 1'b0) 
			Q <= 4'b0;
		if (Enable)
		begin
			if (Q == 4'd4) begin // change to 1 later
				Pulse_out <= 1'b1;
				Q <= 4'b0;
			end
			else
				Q <= Q + 1;
		end
	end
endmodule

// a bit faster rate so that it erases quicker
module framecountererase(
						input Clock, 
						input Resetn, 
						input Enable, 
						output reg Pulse_out
	);
	reg [3:0] Q;
	
	always @(posedge Clock)
	begin
		Pulse_out <= 1'b0;
		if (Resetn == 1'b0) 
			Q <= 4'b0;
		if (Enable)
		begin
			if (Q == 4'd1) begin // change to 1 later
				Pulse_out <= 1'b1;
				Q <= 4'b0;
			end
			else
				Q <= Q + 1;
		end
	end
endmodule
	
