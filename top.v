module Audio_Top (
	// Inputs
	CLOCK_50,
	CLOCK2_50,
	CLOCK3_50,
	CLOCK4_50,
	
	KEY,

	AUD_ADCDAT,

	// Bidirectionals
	AUD_BCLK,
	AUD_ADCLRCK,
	AUD_DACLRCK,

	FPGA_I2C_SDAT,

	// Outputs
	AUD_XCK,
	AUD_DACDAT,

	FPGA_I2C_SCLK,
	SW,
	
	
	// Keyboard
	PS2_CLK,
	PS2_DAT,
	
	HEX0, HEX1,
	LEDR,
	
	
	// VGA STUFF
	VGA_CLK,   						//	VGA Clock
	VGA_HS,							//	VGA H_SYNC
	VGA_VS,							//	VGA V_SYNC
	VGA_BLANK_N,						//	VGA BLANK
	VGA_SYNC_N,						//	VGA SYNC
	VGA_R,   						//	VGA Red[9:0]
	VGA_G,	 						//	VGA Green[9:0]
	VGA_B,  
);

// Inputs
input				CLOCK_50;
input				CLOCK2_50;
input				CLOCK3_50;
input				CLOCK4_50;

input		[3:0]	KEY;
input		[3:0]	SW;

input				AUD_ADCDAT;

// Bidirectionals
inout				AUD_BCLK;
inout				AUD_ADCLRCK;
inout				AUD_DACLRCK;

inout				FPGA_I2C_SDAT;

// Outputs
output				AUD_XCK;
output				AUD_DACDAT;

output				FPGA_I2C_SCLK;

output [7:0] HEX0, HEX1;
output [9:0] LEDR;

hex_decoder H0(key_data[3:0], HEX0);
hex_decoder H1(key_data[7:4], HEX1);

// Internal Wires
wire				audio_in_available;
wire		[31:0]	left_channel_audio_in;
wire		[31:0]	right_channel_audio_in;
wire				read_audio_in;

wire				audio_out_allowed;

wire				write_audio_out;

wire		[2:0]	write_audio_out_1, write_audio_out_2, write_audio_out_3, write_audio_out_4, 
						write_audio_out_5, write_audio_out_6, write_audio_out_7, write_audio_out_8, write_audio_out_9;


// audio outputs of each shared sounds
wire		[9:0]	audio_out_shared_1, audio_out_shared_2, audio_out_shared_3;

// audio outputs for kit 1
wire [9:0] audio_out_14, audio_out_15, audio_out_16, audio_out_17, audio_out_18, audio_out_19;
//audio outputs for kit 2
wire [9:0] audio_out_21, audio_out_22, audio_out_23, audio_out_24, audio_out_25, audio_out_26, audio_out_27, audio_out_28, audio_out_29;



wire		[31:0]	mixed_audio;
wire [2:0] play1, play2, play3, play4, play5, play6, play7, play8, play9;

//Increasing bar on VGA
wire [1:0] up1, up2, up3, up4, up5, up6;
wire [5:0] raise;
assign raise = {|up6, |up5, |up4, |up3, |up2, |up1};

wire raise4;
assign raise4 = |up4;

assign LEDR[6:1] = raise;

// Internal Registers

reg [18:0] delay_cnt;
wire [18:0] delay;

reg snd;


assign write_audio_out = write_audio_out_1 || write_audio_out_2 || write_audio_out_3 || write_audio_out_4 ||
								 write_audio_out_5 || write_audio_out_6 || write_audio_out_7 || write_audio_out_8 || write_audio_out_9;

wire sound1done;
wire sound2done;
wire sound3done;
wire sound4done;
wire sound5done;
wire sound6done;

assign sound1done = write_audio_out_1[0] | write_audio_out_1[1];
assign sound2done = write_audio_out_2[0] | write_audio_out_2[1];
assign sound3done = write_audio_out_3[0] | write_audio_out_3[1];
assign sound4done = write_audio_out_4[0] | write_audio_out_4[1];
assign sound5done = write_audio_out_5[0] | write_audio_out_5[1];
assign sound6done = write_audio_out_6[0] | write_audio_out_6[1];


//************KIT1***********************
soundshared1 sound1(
		.clock(CLOCK_50),
		.resetn(KEY[0]), // ~ b/c reset is 0 which should corresponding with SW on
		.play(play1[0]),
		.audio_out_allowed(audio_out_allowed),
		.address_max(20'd16163),
		.clear_buffer( ),
		.write_audio_out(write_audio_out_1[0]),
		.audio_out(audio_out_shared_1),
		.up(up1[0])
);

soundshared2 sound2(
		.clock(CLOCK_50),
		.resetn(KEY[0]),
		.play(play2[0]),
		.audio_out_allowed(audio_out_allowed),
		.address_max(20'd5659),
		.clear_buffer( ),
		.write_audio_out(write_audio_out_2[0]),
		.audio_out(audio_out_shared_2),
		.up(up2[0])
);

soundshared3 sound3(
		.clock(CLOCK_50),
		.resetn(KEY[0]),
		.play(play3[0]),
		.audio_out_allowed(audio_out_allowed),
		.address_max(20'd2894),
		.clear_buffer( ),
		.write_audio_out(write_audio_out_3[0]),
		.audio_out(audio_out_shared_3),
		.up(up3[0])
);

sound14 sound14(
		.clock(CLOCK_50),
		.resetn(KEY[0]),
		.play(play4[0]),
		.audio_out_allowed(audio_out_allowed),
		.address_max(20'd20220),
		.clear_buffer( ),
		.write_audio_out(write_audio_out_4[0]),
		.audio_out(audio_out_14),
		.up(up4[0])
);
sound15 sound15(
		.clock(CLOCK_50),
		.resetn(KEY[0]),
		.play(play5[0]),
		.audio_out_allowed(audio_out_allowed),
		.address_max(20'd4638),
		.clear_buffer( ),
		.write_audio_out(write_audio_out_5[0]),
		.audio_out(audio_out_15),
		.up(up5[0])
);

sound16 sound16(
		.clock(CLOCK_50),
		.resetn(KEY[0]),
		.play(play6[0]),
		.audio_out_allowed(audio_out_allowed),
		.address_max(20'd26960),
		.clear_buffer( ),
		.write_audio_out(write_audio_out_6[0]),
		.audio_out(audio_out_16),
		.up(up6[0])
);

//***************KIT2*************************
sound21 sound21(
		.clock(CLOCK_50),
		.resetn(KEY[0]), // ~ b/c reset is 0 which should corresponding with SW on
		.play(play1[1]),
		.audio_out_allowed(audio_out_allowed),
		.address_max(20'd24322),
		.clear_buffer( ),
		.write_audio_out(write_audio_out_1[1]),
		.audio_out(audio_out_21),
		.up(up1[1])
);
sound22 sound22(
		.clock(CLOCK_50),
		.resetn(KEY[0]), // ~ b/c reset is 0 which should corresponding with SW on
		.play(play2[1]),
		.audio_out_allowed(audio_out_allowed),
		.address_max(20'd24322),
		.clear_buffer( ),
		.write_audio_out(write_audio_out_2[1]),
		.audio_out(audio_out_22),
		.up(up2[1])
);
sound23 sound23(
		.clock(CLOCK_50),
		.resetn(KEY[0]), // ~ b/c reset is 0 which should corresponding with SW on
		.play(play3[1]),
		.audio_out_allowed(audio_out_allowed),
		.address_max(20'd24322),
		.clear_buffer( ),
		.write_audio_out(write_audio_out_3[1]),
		.audio_out(audio_out_23),
		.up(up3[1])
);
sound24 sound24(
		.clock(CLOCK_50),
		.resetn(KEY[0]), // ~ b/c reset is 0 which should corresponding with SW on
		.play(play4[1]),
		.audio_out_allowed(audio_out_allowed),
		.address_max(20'd24322),
		.clear_buffer( ),
		.write_audio_out(write_audio_out_4[1]),
		.audio_out(audio_out_24),
		.up(up4[1])
);
sound25 sound25(
		.clock(CLOCK_50),
		.resetn(KEY[0]), // ~ b/c reset is 0 which should corresponding with SW on
		.play(play5[1]),
		.audio_out_allowed(audio_out_allowed),
		.address_max(20'd24322),
		.clear_buffer( ),
		.write_audio_out(write_audio_out_5[1]),
		.audio_out(audio_out_25),
		.up(up5[1])
);
sound26 sound26(
		.clock(CLOCK_50),
		.resetn(KEY[0]), // ~ b/c reset is 0 which should corresponding with SW on
		.play(play6[1]),
		.audio_out_allowed(audio_out_allowed),
		.address_max(20'd24322),
		.clear_buffer( ),
		.write_audio_out(write_audio_out_6[1]),
		.audio_out(audio_out_26),
		.up(up6[1])
);

mixer mix(	
		.c1(audio_out_shared_1 | audio_out_21),
		.c2(audio_out_shared_2 | audio_out_22),
		.c3(audio_out_shared_3 | audio_out_23),
		.c4(audio_out_14 | audio_out_24),
		.c5(audio_out_15 | audio_out_25),
		.c6(audio_out_16 | audio_out_26),
		.c7(audio_out_17 | audio_out_27),
		.c8(audio_out_18 | audio_out_28),
		.c9(audio_out_19 | audio_out_29),
		.mixed_audio(mixed_audio)
);

Audio_Controller Audio_Controller (
	// Inputs
	.CLOCK_50						(CLOCK_50),
	.reset						(~KEY[0]),

	.clear_audio_in_memory		(),
	.read_audio_in				( ),
	
	.clear_audio_out_memory		(),
	.left_channel_audio_out		(mixed_audio),
	.right_channel_audio_out	(mixed_audio),
	.write_audio_out			(write_audio_out),

	.AUD_ADCDAT					(AUD_ADCDAT),

	// Bidirectionals
	.AUD_BCLK					(AUD_BCLK),
	.AUD_ADCLRCK				(AUD_ADCLRCK),
	.AUD_DACLRCK				(AUD_DACLRCK),


	// Outputs
	.audio_in_available			( ),
	.left_channel_audio_in		( ),
	.right_channel_audio_in		( ),

	.audio_out_allowed			(audio_out_allowed),

	.AUD_XCK					(AUD_XCK),
	.AUD_DACDAT					(AUD_DACDAT)

);

avconf #(.USE_MIC_INPUT(1)) avc (
	.I2C_SCLK					(FPGA_I2C_SCLK),
	.I2C_SDAT					(FPGA_I2C_SDAT),
	.CLOCK_50						(CLOCK_50),
	.reset							(~KEY[0])
);


// *************************KEYBOARD ******************************
inout				PS2_CLK;
inout				PS2_DAT;

// Internal wires and registers
wire			[7:0]	key_data;
wire					key_pressed;


// 1
keyboard_top key1(.clock(CLOCK_50),
								.resetn(KEY[0]),
								.received_data_en(key_pressed),
								.last_data_received(key_data),
								.make(8'h69),
								.play(play1)
);

// 2
keyboard_top key2(.clock(CLOCK_50),
								.resetn(KEY[0]),
								.received_data_en(key_pressed),
								.last_data_received(key_data),
								.make(8'h72),
								.play(play2)
);

// 3
keyboard_top key3(.clock(CLOCK_50),
								.resetn(KEY[0]),
								.received_data_en(key_pressed),
								.last_data_received(key_data),
								.make(8'h7A),
								.play(play3)
);

// 4
keyboard_top key4(.clock(CLOCK_50),
								.resetn(KEY[0]),
								.received_data_en(key_pressed),
								.last_data_received(key_data),
								.make(8'h6B),
								.play(play4)
);

//5
keyboard_top key5(.clock(CLOCK_50),
								.resetn(KEY[0]),
								.received_data_en(key_pressed),
								.last_data_received(key_data),
								.make(8'h73),
								.play(play5)
);

//6
keyboard_top key6(.clock(CLOCK_50),
								.resetn(KEY[0]),
								.received_data_en(key_pressed),
								.last_data_received(key_data),
								.make(8'h74),
								.play(play6)
);

//7
keyboard_top key7(.clock(CLOCK_50),
								.resetn(KEY[0]),
								.received_data_en(key_pressed),
								.last_data_received(key_data),
								.make(8'h6C),
								.play(play7)
);

//8
keyboard_top key8(.clock(CLOCK_50),
								.resetn(KEY[0]),
								.received_data_en(key_pressed),
								.last_data_received(key_data),
								.make(8'h75),
								.play(play8)
);

//9
keyboard_top key9(.clock(CLOCK_50),
								.resetn(KEY[0]),
								.received_data_en(key_pressed),
								.last_data_received(key_data),
								.make(8'h7D),
								.play(play9)
);

				
PS2_Controller PS2 (
	.CLOCK_50				(CLOCK_50),
	.reset					(~KEY[0]),

	.PS2_CLK					(PS2_CLK),
 	.PS2_DAT					(PS2_DAT),

	.received_data			(key_data),
	.received_data_en		(key_pressed)
);



//*************************************VGA*************************************
	// Do not change the following outputs
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK_N;				//	VGA BLANK
	output			VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire resetn;
	wire reset_fake;
	assign resetn = KEY[0];
	assign reset_fake = 1'b1;

	wire [8:0] colour, colour2, colour3, colour4, colour5, colour6, colour7, colour8, colour9;
	wire [7:0] x_w, x_w2, x_w3, x_w4, x_w5, x_w6, x_w7, x_w8, x_w9;
	wire [6:0] y_w, y_w2, y_w3, y_w4, y_w5, y_w6, y_w7, y_w8, y_w9;
	
	wire [7:0] x, x2, x3, x4, x5, x6, x7, x8, x9;
	wire [6:0] y, y2, y3, y4, y5, y6, y7, y8, y9;
	
	reg [7:0] x_final;
	reg [6:0] y_final;
	reg [8:0] colour_final;
	
	reg plot_w, plot_w2, plot_w3, plot_w4, plot_w5, plot_w6, plot_w7, plot_w8, plot_w9;
	reg black_w, black_w2, black_w3, black_w4, black_w5, black_w6, black_w7, black_w8, black_w9;

	wire frame_start, frame_start2, frame_start3, frame_start4, frame_start5, frame_start6, frame_start7, frame_start8, frame_start9; // frame start is the slower clock hz
	wire frame_counter, frame_counter2, frame_counter3, frame_counter4, frame_counter5, frame_counter6, frame_counter7, frame_counter8, frame_counter9; // frame counter is the slower frame rate used to slow down the address incrementing
	
	wire trigger1, trigger2, trigger3, trigger4, trigger5, trigger6, trigger7;

	wire key_pressed1, key_pressed2, key_pressed3, key_pressed4, key_pressed5, key_pressed6, key_pressed7, key_pressed8, key_pressed9;
	
	wire dy, dy2, dy3, dy4, dy5, dy6, dy7, dy8, dy9;
	wire y_erase, y_erase2, y_erase3, y_erase4, y_erase5, y_erase6, y_erase7, y_erase8, y_erase9;
	
	wire [10:0] address_count, address_count2, address_count3, address_count4, address_count5, address_count6, address_count7, address_count8, address_count9; // 11 bits just cause
	
	assign key_pressed1 = |play1;
	assign key_pressed2 = |play2;
	assign key_pressed3 = |play3;
	assign key_pressed4 = |play4;
	assign key_pressed5 = |play5;
	assign key_pressed6 = |play6;
	assign key_pressed7 = |play7;
	assign key_pressed8 = |play8;
	assign key_pressed9 = |play9;
	
	////////////////////////////////////// CLOCKS ////////////////////////////////////////////
	wire [8:0] clock;
	assign clock[0] = CLOCK_50;
	assign clock[1] = ~CLOCK_50;
	assign clock[2] = CLOCK2_50;
	assign clock[3] = ~CLOCK2_50;
	assign clock[4] = CLOCK3_50;
	assign clock[5] = ~CLOCK3_50;
	assign clock[6] = CLOCK4_50;
	assign clock[7] = ~CLOCK4_50;
	
	wire [7:0] x_button, x_button2, x_button3, x_button4, x_button5, x_button6;
	wire [6:0] y_button, y_button2, y_button3, y_button4, y_button5, y_button6;
	wire [8:0] colour_button, colour_button2, colour_button3, colour_button4, colour_button5, colour_button6;
	
	wire test1;
	
	//////////////////////////////////////////// FIRST ONE ////////////////////////////////////////////
	animation 			a(.Clock(clock[1]), .Resetn(resetn), .play(trigger1), .key_pressed(key_pressed1), .X_out(x_w), .Y_out(y_w), .dy(dy), .done(sound1done));
	modifiedclock 		c(.Clock(clock[1]), .Resetn(resetn), .Enable_out(frame_start)); 
	framecounter 		frame(clock[1], resetn, frame_start, frame_counter); 
	squaredrawer 		sd(.Clock(clock[1]), .Resetn(resetn), .Black(black_w), .Plot_in(plot_w), .dy(dy), .X_in(8'd23), .Y_in(y_w), .Colour_in(9'b111_000_000), .X_out(x), .Y_out(y), .Colour_out(colour), .Plot_out(writeEn));
	
	button_drawer		button(.clock(clock[1]), .key_pressed(key_pressed1), .colour_in(9'b111_000_000), .colour_idle(9'b101_000_000), .x_in(8'd20), .y_in(7'd84), .x_out(x_button), .y_out(y_button), .colour_out(colour_button));
	
	tester 				test (.address(address_count), .clock(clock[1]), .q(trigger1) );
	address_counter 	ac (.clock(frame_counter),	.key_pressed(key_pressed), .address_count(address_count));
	
	//////////////////////////////////////////// SECOND ONE ////////////////////////////////////////////
	animation 			a2 (.Clock(clock[2]), .Resetn(resetn), .play(trigger2), .key_pressed(key_pressed2), .X_out(x_w2), .Y_out(y_w2), .dy(dy2), .done(sound2done));
	modifiedclock 		c2 (.Clock(clock[2]), .Resetn(resetn), .Enable_out(frame_start2)); 
	framecounter 		frame2 (clock[2], resetn, frame_start2, frame_counter2); 
	squaredrawer 		sd2 (.Clock(clock[2]), .Resetn(resetn), .Black(black_w2), .Plot_in(plot_w2), .dy(dy2), .X_in(8'd44), .Y_in(y_w2), .Colour_in(9'b111_000_111), .X_out(x2), .Y_out(y2), .Colour_out(colour2), .Plot_out(writeEn2));
	
	button_drawer		button2(.clock(clock[2]), .key_pressed(key_pressed2), .colour_in(9'b111_000_111), .colour_idle(9'b110_000_110), .x_in(8'd41), .y_in(7'd84), .x_out(x_button2), .y_out(y_button2), .colour_out(colour_button2));

	tester 				test2 (.address(address_count2), .clock(clock[2]), .q(trigger2) );
	address_counter 	ac2 (.clock(frame_counter2),	.key_pressed(key_pressed), .address_count(address_count2));
	
	//////////////////////////////////////////// THIRD ONE ////////////////////////////////////////////
	animation 			a3 (.Clock(clock[6]), .Resetn(resetn), .play(trigger3), .key_pressed(key_pressed3), .X_out(x_w3), .Y_out(y_w3), .dy(dy3), .done(sound3done));
	modifiedclock 		c3 (.Clock(clock[6]), .Resetn(resetn), .Enable_out(frame_start3)); 
	framecounter 		frame3 (clock[6], resetn, frame_start3, frame_counter3); 
	squaredrawer 		sd3 (.Clock(clock[6]), .Resetn(resetn), .Black(black_w3), .Plot_in(plot_w3), .dy(dy3), .X_in(8'd65), .Y_in(y_w3), .Colour_in(9'b011_111_110), .X_out(x3), .Y_out(y3), .Colour_out(colour3), .Plot_out(writeEn3));
	
	button_drawer		button3(.clock(clock[6]), .key_pressed(key_pressed3), .colour_in(9'b011_111_110), .colour_idle(9'b010_111_100), .x_in(8'd62), .y_in(7'd84), .x_out(x_button3), .y_out(y_button3), .colour_out(colour_button3));

	tester 				test3 (.address(address_count3), .clock(clock[6]), .q(trigger3) );
	address_counter 	ac3 (.clock(frame_counter3),	.key_pressed(key_pressed), .address_count(address_count3));
	
	//////////////////////////////////////////// FOURTH ONE ////////////////////////////////////////////
	animation 			a4 (.Clock(clock[4]), .Resetn(resetn), .play(trigger4), .key_pressed(key_pressed4), .X_out(x_w4), .Y_out(y_w4), .dy(dy4), .done(sound4done));
	modifiedclock 		c4 (.Clock(clock[4]), .Resetn(resetn), .Enable_out(frame_start4)); 
	framecounter 		frame4 (clock[4], resetn, frame_start3, frame_counter4); 
	squaredrawer 		sd4 (.Clock(clock[4]), .Resetn(resetn), .Black(black_w4), .Plot_in(plot_w4), .dy(dy4), .X_in(8'd87), .Y_in(y_w4), .Colour_in(9'b000_111_000), .X_out(x4), .Y_out(y4), .Colour_out(colour4), .Plot_out(writeEn4));

	button_drawer		button4(.clock(clock[4]), .key_pressed(key_pressed4), .colour_in(9'b000_111_000), .colour_idle(9'b000_001_000),  .x_in(8'd83), .y_in(7'd84), .x_out(x_button4), .y_out(y_button4), .colour_out(colour_button4));

	tester 				test4 (.address(address_count4), .clock(clock[4]), .q(trigger4));
	address_counter 	ac4 (.clock(frame_counter4),	.key_pressed(key_pressed4), .address_count(address_count4));
	
	//////////////////////////////////////////// FIFTH ONE ////////////////////////////////////////////
	animation 			a5 (.Clock(clock[7]), .Resetn(resetn), .play(trigger5), .key_pressed(key_pressed5), .X_out(x_w5), .Y_out(y_w5), .dy(dy5), .done(sound5done));
	modifiedclock 		c5 (.Clock(clock[7]), .Resetn(resetn), .Enable_out(frame_start5)); 
	framecounter 		frame5 (clock[7], resetn, frame_start5, frame_counter5); 
	squaredrawer 		sd5 (.Clock(clock[7]), .Resetn(resetn), .Black(black_w5), .Plot_in(plot_w5), .dy(dy5), .X_in(8'd107), .Y_in(y_w5), .Colour_in(9'b000_011_101), .X_out(x5), .Y_out(y5), .Colour_out(colour5), .Plot_out(writeEn5));
	
	button_drawer		button5(.clock(clock[7]), .key_pressed(key_pressed5), .colour_in(9'b000_011_101), .colour_idle(9'b000_001_111), .x_in(8'd104), .y_in(7'd84), .x_out(x_button5), .y_out(y_button5), .colour_out(colour_button5));
		
	tester 				test5 (.address(address_count5), .clock(clock[7]), .q(trigger5));
	address_counter 	ac5(.clock(frame_counter5),	.key_pressed(key_pressed), .address_count(address_count5));
	
	//////////////////////////////////////////// SIXTH ONE ////////////////////////////////////////////
	animation 			a6 (.Clock(clock[3]), .Resetn(resetn), .play(trigger6), .key_pressed(key_pressed6), .X_out(x_w6), .Y_out(y_w6), .dy(dy6), .done(sound6done));
	modifiedclock 		c6 (.Clock(clock[3]), .Resetn(resetn), .Enable_out(frame_start6)); 
	framecounter 		frame6 (clock[3], resetn, frame_start6, frame_counter6); 
	squaredrawer 		sd6 (.Clock(clock[3]), .Resetn(resetn), .Black(black_w6), .Plot_in(plot_w6), .dy(dy6), .X_in(8'd128), .Y_in(y_w6), .Colour_in(9'b000_000_100), .X_out(x6), .Y_out(y6), .Colour_out(colour6), .Plot_out(writeEn6));
	
	button_drawer		button6(.clock(clock[3]), .key_pressed(key_pressed6), .colour_in(9'b000_000_100), .colour_idle(9'b000_000_001), .x_in(8'd125), .y_in(7'd84), .x_out(x_button6), .y_out(y_button6), .colour_out(colour_button6));
		
	tester 				test6 (.address(address_count6), .clock(clock[3]), .q(trigger6));
	address_counter 	ac6(.clock(frame_counter6),	.key_pressed(key_pressed), .address_count(address_count6));
	
	//////////////////////////////////////////// SEVENTH ONE ////////////////////////////////////////////
	animation 			a7 (.Clock(clock[0]), .Resetn(resetn), .play(trigger7), .key_pressed(key_pressed7), .X_out(x_w7), .Y_out(y_w7), .dy(dy7), .done(sound7done));
	modifiedclock 		c7 (.Clock(clock[0]), .Resetn(resetn), .Enable_out(frame_start7)); 
	framecounter 		frame7 (clock[0], resetn, frame_start7, frame_counter7); 
	squaredrawer 		sd7(.Clock(clock[0]), .Resetn(resetn), .Black(black_w7), .Plot_in(plot_w7), .dy(dy7), .X_in(8'd163), .Y_in(y_w7), .Colour_in(9'b111_111_111), .X_out(x7), .Y_out(y7), .Colour_out(colour7), .Plot_out(writeEn7));
	
	button_drawer		button7(.clock(clock[0]), .key_pressed(key_pressed7), .colour_in(9'b111_111_111), .colour_idle(), .x_in(8'd160), .y_in(7'd84), .x_out(x_button7), .y_out(y_button7), .colour_out(colour_button7));
	
	tester 				test7 (.address(address_count7), .clock(clock[0]), .q(trigger7));
	address_counter 	ac7(.clock(frame_counter7),	.key_pressed(key_pressed), .address_count(address_count7));

	//////////////////////////////////////////// SELECTING VGA OUTPUT ////////////////////////////////////////////
	reg [3:0] count = 4'b0;
	
	always@(posedge CLOCK_50) begin
		if(count == 4'b0) begin
				x_final = x;
				y_final = y;
				colour_final = colour;
				count = count + 1;
		end
		else if(count == 4'd1) begin
				x_final = x2;
				y_final = y2;
				colour_final = colour2;
				count = count + 1;
		end
		else if(count == 4'd2) begin
				x_final = x3;
				y_final = y3;
				colour_final = colour3;
				count = count + 1;
		end
		else if(count == 4'd3) begin
				x_final = x4;
				y_final = y4;
				colour_final = colour4;
				count = count + 1;
		end
		else if(count == 4'd4) begin
				x_final = x5;
				y_final = y5;
				colour_final = colour5;
				count = count + 1;
		end
		else if(count == 4'd5) begin
				x_final = x6;
				y_final = y6;
				colour_final = colour6;
				count = count + 1;
		end
		else if(count == 4'd6) begin
				x_final = x7;
				y_final = y7;
				colour_final = colour7;
				count = count + 1;
		end
		else if(count == 4'd7) begin
				x_final = x8;
				y_final = y8;
				colour_final = colour8;
				count = count + 1;
		end

		else if(count == 4'd8) begin
				x_final = x_button;
				y_final = y_button;
				colour_final = colour_button;
				count = count + 1;
		end
		else if(count == 4'd9) begin
				x_final = x_button2;
				y_final = y_button2;
				colour_final = colour_button2;
				count = count + 1;
		end
		else if(count == 4'd10) begin
				x_final = x_button3;
				y_final = y_button3;
				colour_final = colour_button3;
				count = count + 1;
		end
		else if(count == 4'd11) begin
				x_final = x_button4;
				y_final = y_button4;
				colour_final = colour_button4;
				count = count + 1;
		end
		else if(count == 4'd12) begin
				x_final = x_button5;
				y_final = y_button5;
				colour_final = colour_button5;
				count = count + 1;
		end
		else if(count == 4'd13) begin
				x_final = x_button6;
				y_final = y_button6;
				colour_final = colour_button6;
				count = count + 1;
		end
		else if(count == 4'd14) begin
				x_final = x_button7;
				y_final = y_button7;
				colour_final = colour_button7;
				count = 4'b0;
		end
	end

	// Create an Instance of a VGA controller - there can be only one!
	// Define the number of colours as well as the initial background
	// image file (.MIF) for the controller.
	vga_adapter VGA(
			.resetn(resetn),
			.clock(CLOCK_50),
			.colour(colour_final), 
			.x(x_final),
			.y(y_final),
			.plot(1'b1), 
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 3;
		defparam VGA.BACKGROUND_IMAGE = "background7.mif";
	// Put your code here. Your code should produce signals x,y,colour and writeEn
	// for the VGA controller, in addition to any other functionality your design may require.

endmodule

