// PROBLEMs
// if one sound is playing and its numbers are between 1-16, it will divide to 0

// also i set audio to 0 when !play

module mixer(
		input [9:0] c1,			// channel 1, etc.
		input [9:0] c2,
		input [9:0] c3,
		input [9:0] c4,
		input [9:0] c5,
		input [9:0] c6,
		input [9:0] c7,
		input [9:0] c8,
		input [9:0] c9,
		
		output reg [31:0] mixed_audio		// 12 bits
	);

	parameter SIZE = 12; // sum of 4 numbers at 10 bits can reach a max of 12 bits width
	reg [SIZE - 1:0] sum; // sum of 4 numbers at 10 bits can reach a max of 12 bits width
	reg [SIZE - 1:0] neg_sum;
	reg [SIZE - 1:0] pos_sum;

	//reg [SIZE - 1:0] temp_sum_neg_to_pos;
	//reg [SIZE - 1:0] temp_sum_quotient;

	reg [SIZE - 1:0] quotient;

	reg [9:0] pos_c1;
	reg [9:0] pos_c2;
	reg [9:0] pos_c3;
	reg [9:0] pos_c4;
	reg [9:0] pos_c5;
	reg [9:0] pos_c6;
	reg [9:0] pos_c7;
	reg [9:0] pos_c8;
	reg [9:0] pos_c9;

	reg [9:0] neg_c1;
	reg [9:0] neg_c2;
	reg [9:0] neg_c3;
	reg [9:0] neg_c4;
	reg [9:0] neg_c5;
	reg [9:0] neg_c6;
	reg [9:0] neg_c7;
	reg [9:0] neg_c8;
	reg [9:0] neg_c9;

	wire [3:0] count = |c1 + |c2 + |c3 + |c4 + |c5 + |c6 + |c7 + |c8 + |c9;	// counts how many inputs were on aka not 0's 

	always@(*)
	begin
		pos_c1 = 0;
		pos_c2 = 0;
		pos_c3 = 0;
		pos_c4 = 0;
		pos_c5 = 0;
		pos_c6 = 0;
		pos_c7 = 0;
		pos_c8 = 0;
		pos_c9 = 0;
		

		neg_c1 = 0;
		neg_c2 = 0;
		neg_c3 = 0;
		neg_c4 = 0;
		neg_c5 = 0;
		neg_c6 = 0;
		neg_c7 = 0;
		neg_c8 = 0;
		neg_c9 = 0;

		case(c1[9])
			1'b1: neg_c1 = ~c1 + 1; // convert to positive
			1'b0: pos_c1 = c1;
		endcase
		case(c2[9])
			1'b1: neg_c2 = ~c2 + 1; // convert to positive
			1'b0: pos_c2 = c2;
		endcase
		case(c3[9])
			1'b1: neg_c3 = ~c3 + 1; // convert to positive
			1'b0: pos_c3 = c3;
		endcase
		case(c4[9])
			1'b1:  neg_c4 = ~c4 + 1; // convert to positive
			1'b0: pos_c4 = c4;
		endcase
		case(c5[9])
			1'b1:  neg_c5 = ~c5 + 1; // convert to positive
			1'b0: pos_c5 = c5;
		endcase
		case(c5[9])
			1'b1:  neg_c5 = ~c5 + 1; // convert to positive
			1'b0: pos_c5 = c5;
		endcase
		case(c6[9])
			1'b1:  neg_c6 = ~c6 + 1; // convert to positive
			1'b0: pos_c6 = c6;
		endcase
		case(c7[9])
			1'b1:  neg_c7 = ~c7 + 1; // convert to positive
			1'b0: pos_c7 = c7;
		endcase
		case(c8[9])
			1'b1:  neg_c8 = ~c8 + 1; // convert to positive
			1'b0: pos_c8 = c8;
		endcase
		case(c9[9])
			1'b1:  neg_c9 = ~c9 + 1; // convert to positive
			1'b0: pos_c9 = c9;
		endcase
		
		neg_sum = neg_c1 + neg_c2 + neg_c3 + neg_c4 + neg_c5 + neg_c6 + neg_c7 + neg_c8 + neg_c9;	// sum of the absolute value of all the negative inputs
		pos_sum = pos_c1 + pos_c2 + pos_c3 + pos_c4 + pos_c5 + pos_c6 + pos_c7 + pos_c8 + pos_c9;	// sum of the positive inputs
		sum = (~neg_sum + 1) + pos_sum;			// difference of the two above (positive sum + negative of the other sum)
	end

	// division based on count
	always@(*) 
	begin
		if(count == 1 || count == 0)
			case(sum[11])
				1'b1: quotient = {2'b11, sum[11:2]};
				1'b0: quotient = {2'b0, sum[11:2]};				// divide by 2 by shifting right by 1 bit
			endcase
		else if(count == 2)
			case(sum[11])
				1'b1: quotient = {2'b11, sum[11:2]};
				1'b0: quotient = {2'b0, sum[11:2]};				// divide by 2 by shifting right by 1 bit
			endcase
		else if(count > 2 && count <= 4)
			case(sum[11])
				1'b1: quotient = {2'b11, sum[11:2]};
				1'b0: quotient = {2'b0, sum[11:2]};				// divide by 4 by shifting right by 2 bits
			endcase
		else if(count > 4 && count <= 8)
			case(sum[11])
				1'b1: quotient = {3'b111, sum[11:3]};
				1'b0: quotient = {3'b0, sum[11:3]};				// divide by 8 by shifting right by 3 bits
			endcase
//		else if(count > 8 && count <= 16)
//			case(sum[11])
//				1'b1: quotient = {4'b1111, sum[11:4]};
//				1'b0: quotient = {4'b0, sum[11:4]};				// divide by 16 by shifting right by 4 bits
//			endcase
	end

	always@(*)
	begin
		mixed_audio = {quotient, 20'b0}; // *********padded with 1's instead of 0's
	end
endmodule 
