///////////////////////////////////////////// COMBINATION OF CONTROLLER AND DATAPATH ////////////////////////////////////////////
module squaredrawer(
					// inputs
					input Clock, 
					input Resetn, 
					input Black, 
					input Plot_in, 
					input dy, 
					input [7:0] X_in, 
					input [6:0] Y_in, 
					input [8:0] Colour_in, 
					
					// outputs
					output [7:0] X_out, 
					output [6:0] Y_out, 
					output [8:0] Colour_out, 
					output Plot_out
	);
	wire black_w;

	controller controller(
		.clock(Clock),
		.reset(Resetn),
		.plot_in(Plot_in),
		.black_in(Black),
		.plot_out(Plot_out),
		.black_out(black_w)
	);

	datapath datapath(
		.clock(Clock),
		.reset(Resetn),
		.colour_in(Colour_in),
		.dy(dy),
		.x_in(X_in),
		.y_in(Y_in),
		.black(black_w),
		.x_out(X_out),
		.y_out(Y_out),
		.colour_out(Colour_out)
	);
endmodule 

///////////////////////////////////////////// BUTTON DRAWER DATAPATH ////////////////////////////////////////////
module button_drawer(
		// inputs
		input clock,
		input key_pressed,
		input [8:0] colour_in,
		input [8:0] colour_idle,
		input [7:0] x_in,
		input [6:0] y_in,
		
		// outputs
		output reg [7:0] x_out,
		output reg [6:0] y_out,
		output reg [8:0] colour_out
	);
	reg [7:0] x_count = 8'd4;
	reg [6:0] y_count = 7'd4;
	reg done;
	
	reg [7:0] count = 8'b0;
	
	always@(posedge clock) begin		
		x_out = x_in + count[7:4];
		y_out = y_in + count [3:0];
		
		if(count == 8'b1111_1111)
			count = 8'b0;
		else 
			count = count + 1;
	end	

	// select colour
	always@(posedge clock)
	begin
			case(key_pressed)
				1'b0: colour_out = colour_idle; // change this
				1'b1: colour_out = colour_in;
			endcase
	end
endmodule

///////////////////////////////////////////// DATAPATH ////////////////////////////////////////////
module datapath(
		// inputs
		input clock,
		input reset,
		input [8:0] colour_in,
			
		input dy, // determines if colour is colour or black (drawing bar up or down - "erasing")
		
		input [7:0] x_in,
		input [6:0] y_in,

		input black,
		
		// outputs
		output reg [7:0] x_out,
		output reg [6:0] y_out,
		output reg [8:0] colour_out
	);
	reg [5:0] count = 6'b0;
	
	always@(posedge clock) begin
		x_out = x_in + count[5:3];
		y_out = y_in + count [2:0];
		
		if(count == 6'b111_111)
			count = 6'b0;
		else 
			count = count + 1;
	end	
	
	// Select colour
	always@(posedge clock)
	begin
		
		if (black)
			colour_out = 9'b0;
		else
			case(dy)
				1'b0: colour_out = colour_in;
				1'b1: colour_out = 9'b0;
			endcase
	end
endmodule


///////////////////////////////////////////// CONTROLPATH ////////////////////////////////////////////
module controller(
		// inputs
		input clock, 
		input reset, 
		input plot_in, 
		input black_in, 

		// outputs
		output plot_out, 
		output black_out,
		output [7:0] x_counter, 
		output [6:0] y_counter
	);

	wire [7:0] counter_load;
	wire counter_loadenable;
	wire [7:0] counter_out;

	wire plot_out_temp, black_out_temp;
	assign plot_out = ~plot_out_temp;
	assign black_out = ~black_out_temp;

	counter counter(
		.clock(clock),
		.reset(reset),
		.load_enable(counter_loadenable),
		.load(counter_load),
		.Q(counter_out)
	);
	counter_loader cl(
		.plot_in(~plot_in),
		.black_in(~black_in),
		.load_out(counter_load),
		.load_enable_out(counter_loadenable)
	);
	draw draw(
		.clock(clock),
		.reset(reset),
		.plot_in(~plot_in),
		.black_in(~black_in),
		.counter_in(counter_out),
		.plot_out(plot_out_temp),
		.black_out(black_out_temp)
	);
 	counter_out counter_out(
		.Q_in(counter_out),
		.x_counter_out(x_counter),
		.y_counter_out(y_counter)
	);
endmodule

module draw(
		// inputs 
		input clock,
		input reset,
		input plot_in,
		input black_in,
		input [14:0] counter_in,
		// outputs 
		output reg plot_out,
		output reg black_out
	); 

	reg [2:0] state;
	
	always@(posedge clock) begin
		state[0] <= ~|counter_in;
		state[1] <= (state[0]&plot_in) | (state[1]&|counter_in);
		state[2] <= (state[0]&black_in) | (state[2]&|counter_in);
		
		plot_out = state[1] | state[2];
		black_out = state[2];
	end
endmodule

module counter(
		// inputs
		input clock, 
		input reset, 
		input load_enable, 
		input [5:0] load, // either 15'b0 (plot) or 15'b11111111_1111111 (erase, this was from lab 7 part 3 but no longer needed, took out option of different load option)

		// outputs
		output reg [5:0] Q // counter output 
	); 
	always @(posedge clock)
	begin
		if (reset == 1'b0)
			Q <= 6'b0;
		else if (load_enable == 1'b1 | Q == 6'b0) // need to transfer the load_enable signal to get rid of counter_loader
			Q <= 6'b111_111;
		else if (Q > 6'b0)
			Q <= Q - 1;
	end
endmodule

// don't technically need this anymore but changed functionality from lab 7 
module counter_loader(
			// inputs
			input plot_in, 
			input black_in, 
			// outputs
			output load_enable_out, 
			output [5:0] load_out
	);
	
	assign load_enable_out =  plot_in | black_in;	
	assign load_out = 6'b111_111;
	
endmodule

// originally needed for lab 7 part 2 and 3, removed some functionality of it but just left the module as is so that structure of rest of code could remain the same
module counter_out(
			// inputs
			input [6:0] Q_in, 
			// outputs
			output reg [7:0] x_counter_out, 
			output reg [6:0] y_counter_out
	);
	always @(*)
	begin
		begin
			x_counter_out = {5'b0, Q_in[5:3]};
			y_counter_out = {4'b0, Q_in[2:0]};
		end
	end
endmodule
