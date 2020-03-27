module sound21( 
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
					  
	key31 key31(	.address(address), 
				.clock(clock), 
				.q(audio_in)
	);
endmodule

module sound22( 
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
					  
	key32 key32(	.address(address), 
				.clock(clock), 
				.q(audio_in)
	);
endmodule

module sound23( 
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
					  
	key33 key33(	.address(address), 
				.clock(clock), 
				.q(audio_in)
	);
endmodule

module sound24( 
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
					  
	key34 key34(	.address(address), 
				.clock(clock), 
				.q(audio_in)
	);
endmodule

module sound25( 
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
					  
	key35 key35(	.address(address), 
				.clock(clock), 
				.q(audio_in)
	);
endmodule

module sound26( 
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
					  
	key36 key36(	.address(address), 
				.clock(clock), 
				.q(audio_in)
	);
endmodule
