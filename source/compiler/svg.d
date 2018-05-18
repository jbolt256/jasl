module Compiler.SVG;

import std.stdio, std.string, std.conv, std.format, std.range, std.file, std.algorithm;

class SVGW {
	public int line;
	private string basicText;
	
	this() {
		}
		
	/** 
	 * Writes to program.svg
	 */
	public void write(int opcode, int databits, int auxbits) {
		int i = 0;
		string textOut = "", basicText = "";
		
		/* Convert the three bit sections to binary numbers formatted to a desired length (6, 20, 6 bits) then merge them to one 32-bit string */
		string opcodeBin = format!"%06b"(opcode);
		string databitsBin = format!"%020b"(databits);
		string auxbitsBin = format!"%06b"(auxbits);	
		string allBits = opcodeBin ~ databitsBin ~ auxbitsBin;
				
		/* Split by the sharp3 id, then add it again, later on merge with new text */		
		/* Write black boxes wherever zeroes are located in allBits string */
		foreach ( bit; allBits.stride(1)) { 
			if ( bit == '0' ) {
				textOut ~= format("<rect x=\"%s\" y=\"%s\" width=\"14\" height=\"5\" />", 14 * i, 5 * ( this.line - 1) );
				}
			i++;
		}
	
		try { 
			std.file.append("program.svg", textOut);
		} catch ( Exception e ) {
			writeln("Unable to append to file program.svg");
		}
		
		/* Ensure that large variables are deleted */
	}
	
	/** 
	 * Closes SVG file by appending last two necessary tags.
	 */
	public void close() {
		std.file.append("program.svg", "</g></svg>");
		this.basicText = this.basicText.init;
	}
	
	/** 
	 * Opens SVG file by placing a newline before where the new text will be added.
	 */
	public void open() {
		auto fileContents = std.file.read("program.svg");
		
		if ( std.file.exists("program.svg") ) {
			this.basicText = to!string(fileContents).split("<g id=\"sharp3\" transform=\"translate(0.5,0.5)\">")[0] ~ "<g id=\"sharp3\" transform=\"translate(0.5,0.5)\">";
		} else {
			writeln("Unable to write to file program.svg. The file either does not already exist, xor is malformed.");
		}
		
		std.file.write("program.svg", this.basicText);
		std.file.append("program.svg", "\r\n");
	}
}