module Compiler.SVG;

import std.stdio, std.string, std.conv, std.format, std.range;

class SVGW {
	public int line;
	
	public void write(int opcode, int databits, int auxbits) {
		int[int] polyfill;
		int i = 0;
		string textOut = "";
		string basicText = "";
		
		string opcodeBin = format!"%06b"(opcode);
		string databitsBin = format!"%020b"(databits);
		string auxbitsBin = format!"%06b"(auxbits);	
		string allBits = opcodeBin ~ databitsBin ~ auxbitsBin;
		
		if ( std.file.exists("program.svg") ) {
			basicText = to!string(std.file.read("program.svg")).split("<g id=\"sharp3\" transform=\"translate(0.5,0.5)\">")[0] ~ "<g id=\"sharp3\" transform=\"translate(0.5,0.5)\">";
			//foreach( sLine; File("program.svg").byLine().take(1)) {
			//	basicText ~= sLine;
			//}
		}
		
		foreach ( bit; allBits.stride(1)) { 
			if ( bit == '0' ) {
				textOut ~= format("<rect x=\"%s\" y=\"%s\" width=\"14\" height=\"5\" />", 14*i, 5 * this.line);
				}
			i++;
		}
		
		std.file.write("program.svg", basicText ~ textOut);
	}
	
	public void close() {
		std.file.append("program.svg", "</g></svg>");
	}
	
	public void open() {
		std.file.append("program.svg", "\r\n");
	}
}