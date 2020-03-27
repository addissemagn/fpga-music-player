//*******************SHARED AUDIO ROMS***********************

module soundshared1( 
		input clock, 
		input resetn, 
		input play, 
		input audio_out_allowed, 
		input [19:0] address_max,
				
		output clear_buffer, write_audio_out,
		output [9:0] audio_out	// change this maybe size
		
		,output up
	);
	wire ld_address, increment;
	wire stop;
	
	wire [9:0]audio_in; 
	wire [19:0] address;
	
	// keeps playing sound
	controlPath control1(	.clock(clock), 
				.resetn(resetn), 
				.play(play), 
				.audio_out_allowed(audio_out_allowed), 
				.stop(stop),
				.write_audio_out(write_audio_out), 
				.increment(increment), 
				.ld_address(ld_address), 
				.clear_buffer(clear_buffer)
	);
	
	dataPath data1(		.clock(clock),
				.resetn(resetn),
				.audio_in(audio_in), 
				.address_max(address_max), 
				.ld_address(ld_address), 
				.increment(increment),
				.stop(stop), 
				.audio_out(audio_out), 
				.address(address),
				.up(up)
	);
					  
	key1 key1(	.address(address), 
				.clock(clock), 
				.q(audio_in)
	);
endmodule
	
module soundshared2( 
		input clock, 
		input resetn, 
		input play, 
		input audio_out_allowed, 
		input [19:0] address_max,
				
		output clear_buffer, write_audio_out,
		output [9:0] audio_out	// change this maybe size
		
		,output up
	);
	wire ld_address, increment;
	wire stop;
	
	wire [9:0]audio_in; 
	wire [19:0] address;
	
	// keeps playing sound
	controlPathHoldSound control1(	.clock(clock), 
				.resetn(resetn), 
				.play(play), 
				.audio_out_allowed(audio_out_allowed), 
				.stop(stop),
				.write_audio_out(write_audio_out), 
				.increment(increment), 
				.ld_address(ld_address), 
				.clear_buffer(clear_buffer)
	);
	
	dataPath data1(		.clock(clock), 
				.resetn(resetn),
				.audio_in(audio_in), 
				.address_max(address_max), 
				.ld_address(ld_address), 
				.increment(increment),
				.stop(stop), 
				.audio_out(audio_out), 
				.address(address),
				.up(up)
	);
					  
	key2 key2(	.address(address), 
				.clock(clock), 
				.q(audio_in)
	);
endmodule

module soundshared3( 
		input clock, 
		input resetn, 
		input play, 
		input audio_out_allowed, 
		input [19:0] address_max,
				
		output clear_buffer, write_audio_out,
		output [9:0] audio_out	// change this maybe size
		,output up
	);
	wire ld_address, increment;
	wire stop;
	
	wire [9:0]audio_in; 
	wire [19:0] address;
	
	// keeps playing sound
	controlPath control1(	.clock(clock), 
				.resetn(resetn), 
				.play(play), 
				.audio_out_allowed(audio_out_allowed), 
				.stop(stop),
				.write_audio_out(write_audio_out), 
				.increment(increment), 
				.ld_address(ld_address), 
				.clear_buffer(clear_buffer)
	);
	
	dataPath data1(		.clock(clock), 
				.resetn(resetn),
				.audio_in(audio_in), 
				.address_max(address_max), 
				.ld_address(ld_address), 
				.increment(increment),
				.stop(stop), 
				.audio_out(audio_out), 
				.address(address),
				.up(up)
	);
					  
	key3 key3(	.address(address), 
				.clock(clock), 
				.q(audio_in)
	);
endmodule
