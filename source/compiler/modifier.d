module Compiler.Modifier;
import std.conv, std.string, std.algorithm, std.math, std.stdio;
import Compiler.Tools, Compiler.Globals, Emulator.Memory, Compiler.Functions;

class Modifiers {
	public OLine ret;
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
			"XYZ": ModAttrib(63, 2, 10),
			"ERR": ModAttrib(64, 1, 10),
			"APL": ModAttrib(62, 2, 2)
			];
		}
		
	public OLine XYZ(ILine data) {
		ret.databits = to!int(data.args[1]); // add tools functionality for this
		ret.cmdlineMsg = "Success.";
		return ret;
	}
	
	public OLine ERR(ILine data) {
		ret.databits = 0;
		ret.cmdlineMsg = "Error.";
		return ret;
	}
}