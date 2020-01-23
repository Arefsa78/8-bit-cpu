`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   07:32:37 01/23/2020
// Design Name:   cpum
// Module Name:   D:/verilog/cpu/test2.v
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

module test2;

	// Inputs
	reg clk;
	reg [19:0] ins;

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
		// Initialize Inputs
		clk = 0;
		ins = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

