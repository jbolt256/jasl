module Compiler.JC;
import std.conv, std.string, std.stdio, std.math, std.algorithm;
import Compiler.Globals, Compiler.Tools;

struct JCLine {
	string[] keywords, operators, brackets;
}

struct JCUnformattedLine {
	int inLineNum, outLineNum;
	string line;
}

class JCMain {
	public void eval(string fileLine, int inLineNum, int outLineNum) {
		JCLine Line;
		JCUnformattedLine UnformattedLine;
		
		UnformattedLine.inLineNum = inLineNum;
		UnformattedLine.outLineNum = outLineNum;
		
		Line = this.formatLine(UnformattedLine);		
	}
	
	private JCLine formatLine(JCUnformattedLine Line) {
		JCLine formattedLine;
		
		return formattedLine;
	}
}

class JCGlobals {

}

class JCParser { 

}

class JCMethods {

}
