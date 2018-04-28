module Compiler.SVG;

import std.stdio, std.string, std.conv, std.format, std.range;

class SVGW {
	public int line;
	
	/** 
	 * Writes to program.svg
	 */
	public void write(int opcode, int databits, int auxbits) {
		int i = 0;
		string textOut = "";
		string basicText = "";
		
		/* Convert the three bit sections to binary numbers formatted to a desired length (6, 20, 6 bits) then merge them to one 32-bit string */
		string opcodeBin = format!"%06b"(opcode);
		string databitsBin = format!"%020b"(databits);
		string auxbitsBin = format!"%06b"(auxbits);	
		string allBits = opcodeBin ~ databitsBin ~ auxbitsBin;
		
		/* Split by the sharp3 id, then add it again, later on merge with new text */
		if ( std.file.exists("program.svg") ) {
			basicText = to!string(std.file.read("program.svg")).split("<g id=\"sharp3\" transform=\"translate(0.5,0.5)\">")[0] ~ "<g id=\"sharp3\" transform=\"translate(0.5,0.5)\">";
		}
		
		/* Write black boxes wherever zeroes are located in allBits string */
		foreach ( bit; allBits.stride(1)) { 
			if ( bit == '0' ) {
				textOut ~= format("<rect x=\"%s\" y=\"%s\" width=\"14\" height=\"5\" />", 14*i, 5 * this.line);
				}
			i++;
		}
		
		std.file.write("program.svg", basicText ~ textOut);
	}
	
	/** 
	 * Closes SVG file by appending last two necessary tags.
	 */
	public void close() {
		std.file.append("program.svg", "</g></svg>");
	}
	
	/** 
	 * Opens SVG file by placing a newline before where the new text will be added.
	 */
	public void open() {
		std.file.append("program.svg", "\r\n");
	}
}