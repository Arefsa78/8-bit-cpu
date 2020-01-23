`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:48:51 01/22/2020
// Design Name:   cpum
// Module Name:   D:/verilog/cpu/cputest.v
// Project Name:  cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: cpum
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module cputest;

	// Inputs
	reg clk;
	reg [19:0] ins[2];

	// Outputs
	wire [7:0] ra;
	wire [7:0] rb;
	wire [7:0] rc;
	wire [7:0] rd;
	wire zf;
	wire sf;

	// Instantiate the Unit Under Test (UUT)
	cpum uut (
		.clk(clk), 
		.ins(ins), 
		.ra(ra), 
		.rb(rb), 
		.rc(rc), 
		.rd(rd), 
		.zf(zf), 
		.sf(sf)
	);

	initial begin
	   $readmemb("file.txt", in_ram);
		// Initialize Inputs
		clk = 0;
		ins[0] = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
	
	always #50 clk = !clk;
      
endmodule

