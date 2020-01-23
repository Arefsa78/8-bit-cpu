`timescale 1ns / 1ps
module cpum(clk, ra, rb, rc, rd, zf, sf, db);
	input wire clk;
	
	output reg [7:0] ra, rb, rc, rd;
	output reg zf, sf;
	
	wire [19:0] ins [0:n-1];
//	$readmemh("in.txt", ins);
	assign ins[0] = 20'b00010000000100000010;
	assign ins[1] = 20'b00110000000100001111;
	
	parameter n=2;
	
	parameter ran = 0;
	parameter rbn = 1;
	parameter rcn = 2;
	parameter rdn = 3;
	parameter tmpn = 4;
	parameter datan = 5;
	
	parameter ra_key = 8'b00000001;
	parameter rb_key = 8'b00000010;
	parameter rc_key = 8'b00000100;
	parameter rd_key = 8'b00001000;
	
	parameter load_key_o = 4'b0001;
	parameter load_key_r = 4'b0010;
	parameter add_key_o  = 4'b0011;
	parameter add_key_r  = 4'b0100;
	parameter sub_key_o  = 4'b0101;
	parameter sub_key_r  = 4'b0110;
	parameter mul_key_o  = 4'b0111;
	parameter mul_key_r  = 4'b1000;
	parameter div_key_o  = 4'b1001;
	parameter div_key_r  = 4'b1010;
	parameter shr_key_o  = 4'b1011;
	parameter shl_key_o  = 4'b1100;
	
	reg [3:0] oprand;
	reg [7:0] lhs, rhs;
	reg [7:0] data,tmp;
	
	reg [1:0] t = 3;
	reg [5:0] out;
	reg [1:0] line = 0;
	
	output wire [7:0] db;
	
	assign db = out[ran] ? ra : 8'bZ;
	assign db = out[rbn] ? rb : 8'bZ;
	assign db = out[rcn] ? rc : 8'bZ;
	assign db = out[rdn] ? rd : 8'bZ; 
	assign db = out[tmpn] ? tmp : 8'bZ; 
	assign db = out[datan] ? data : 8'bZ;
	
	/*assign ra = ~in[ran] ? db : ra;
	assign rb = ~in[rbn] ? db : rb;
	assign rc = ~in[rcn] ? db : rc;
	assign rd = ~in[rdn] ? db : rd;*/
	
	integer i;
	always @(posedge clk) begin
		if (t == 3) begin
			oprand = ins[line][19:16];
			lhs    = ins[line][15:8];
			rhs    = ins[line][7:0];
			data   = ins[line][7:0];
			
			line = line+1;
			t = 0;
		end
		$display("%b %b %b", t,rhs, db);
		if(oprand == load_key_r || oprand == load_key_o) begin
			out = 0;
			if(oprand == load_key_r) begin
				if (rhs == ra_key)
					out[ran] = 1;
				if (rhs == rb_key)
					out[rbn] = 1;
				if (rhs == rc_key)
					out[rcn] = 1;
				if (rhs == rd_key)
					out[rdn] = 1;
			end
			else
				out[datan] = 1;
			$display("%b %b %b %b", t, data, db, out);
			if (lhs == ra_key)
				ra = db;
			if (lhs == rb_key)
				rb = db;
			if (lhs == rc_key)
				rc = db;
			if (lhs == rd_key)
				rd = db;
			$display("%b %b %b", t,rhs, db);
			t = 3;
		end
		else if(oprand < shr_key_o) begin
			out = 0;
			if (t == 0) begin
				if (oprand == add_key_r || oprand == sub_key_r || oprand == div_key_r || oprand == mul_key_r) begin
					if (rhs == ra_key)
						out[ran] = 1;
					if (rhs == rb_key)
						out[rbn] = 1;
					if (rhs == rc_key)
						out[rcn] = 1;
					if (rhs == rd_key)
						out[rdn] = 1;
				end
				else
					out[datan] = 1;

				tmp = db;
			end
			if (t == 1) begin
				if(oprand > mul_key_r) begin
					if (lhs == ra_key)
						tmp = ra / tmp;
					if (lhs == rb_key)
						tmp = rb / tmp;
					if (lhs == rc_key)
						tmp = rc / tmp;
					if (lhs == rd_key)
						tmp = rd / tmp;
				end
				else if(oprand > sub_key_r) begin
					if (lhs == ra_key)
						tmp = tmp * ra;
					if (lhs == rb_key)
						tmp = tmp * rb;
					if (lhs == rc_key)
						tmp = tmp * rc;
					if (lhs == rd_key)
						tmp = tmp * rd;
				end
				else if(oprand > add_key_r) begin
					if (lhs == ra_key)
						tmp = tmp - ra;
					if (lhs == rb_key)
						tmp = tmp - rb;
					if (lhs == rc_key)
						tmp = tmp - rc;
					if (lhs == rd_key)
						tmp = tmp - rd;
				end
				else begin
					$display("FUUUUCK");
					if (lhs == ra_key)
						tmp = tmp + ra;
					if (lhs == rb_key)
						tmp = tmp + rb;
					if (lhs == rc_key)
						tmp = tmp + rc;
					if (lhs == rd_key)
						tmp = tmp + rd;
				end
				zf = tmp == 0 ? 1 : 0;
				sf = tmp[7] == 0 ? 0 : 1;
			end
			if (t == 2) begin
				out[tmpn] = 1;
				if (lhs == ra_key)
					ra = db;
				if (lhs == rb_key)
					rb = db;
				if (lhs == rc_key)
					rc = db;
				if (lhs == rd_key)
					rd = db;
			end
							
			t = t+1;
			$display("%b %b %b %b %b", t, data, db, out, tmp);
		end
		else begin
			if (oprand == shl_key_o) begin
				if (lhs == ra_key)
					ra = ra << rhs;
				if (lhs == rb_key)
					rb = rb << rhs;
				if (lhs == rc_key)
					rc = rc << rhs;
				if (lhs == rd_key)
					rd = rd << rhs;
			end
			else begin
				if (lhs == ra_key)
					ra = ra >> rhs;
				if (lhs == rb_key)
					rb = rb >> rhs;
				if (lhs == rc_key)
					rc = rc >> rhs;
				if (lhs == rd_key)
					rd = rd >> rhs;
			end
				t = 3;
		end
	
	end
	
	always @(negedge clk) begin
			if (lhs == ra_key)
				ra <= db;
			if (lhs == rb_key)
				rb = db;
			if (lhs == rc_key)
				rc = db;
			if (lhs == rd_key)
				rd = db;
	end


endmodule
