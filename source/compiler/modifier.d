module Compiler.Modifier;
import std.conv, std.string, std.algorithm, std.math, std.stdio;
import Compiler.Tools, Compiler.Globals, Emulator.Memory, Compiler.Functions;

class Modifiers {
	public OLine ret;
	public int[string] minArgs;
	public ModAttrib[string] opcodeAttrib;
	private Memory Mem;
	private CLibrary CLib;
	
	/** 
	 * Initialize modifier attributes.
	 * ( int minArgs, int maxArgs ) 
	 */
	this() {
		/* Initialize classes we will use */
		Mem = new Memory();
		CLib = new CLibrary();
		
		/* Set attributes for modifiers. */
		opcodeAttrib = [
			"XYZ": ModAttrib(2, 10),
			"ERR": ModAttrib(1, 10),
			"APL": ModAttrib(2, 2)
			];
		}
		
	public OLine XYZ(ILine data) {
		int h;
		ret.opcode = 63;
		ret.databits = to!int(data.args[1]); // add tools functionality for this
		ret.cmdlineMsg = "Success.";
		return ret;
	}
	
	public OLine ERR(ILine data) {
		ret.opcode = 64;
		ret.databits = 0;
		ret.cmdlineMsg = "Error.";
		return ret;
	}
}