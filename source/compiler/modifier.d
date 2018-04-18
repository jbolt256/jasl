module Compiler.Modifier;
import std.conv, std.string, std.algorithm, std.math, std.stdio;
import Compiler.Tools, Compiler.Globals, Emulator.Memory, Compiler.Functions, Main.Library;

class Modifiers {
	public OLine ret;
	public ModAttrib[string] opcodeAttrib;
	private Memory Mem;
	private CLibrary CLib;
	private Library Lib;
	
	/** 
	 * Initialize modifier attributes.
	 * ( int minArgs, int maxArgs ) 
	 */
	this() {
		/* Initialize classes we will use */
		Mem = new Memory();
		CLib = new CLibrary();
		Lib = new Library();
		
		/* Set attributes for modifiers. */
		opcodeAttrib = [
			"ERR": ModAttrib(64, 1, 10),
			"XYZ": ModAttrib(63, 2, 10),
			"APL": ModAttrib(62, 2, 3)
			];
		}
		
	public OLine XYZ(ILine data) {
		ret.databits = to!int(data.args[1]); // add tools functionality for this
		return ret;
	}
	
	public OLine ERR(ILine data) {
		ret.databits = 0;
		return ret;
	}
	
	/* APL - apply logic operations to two registers. The result will be written in a new register. 
	 * A typical line would look like: 	APL		$3		XOR		$5	
	 * Which means apply an XOR operation to both registers, right-adjusted.
	 * Encode this so that the first 4 bits are register1, second 4 bits are operation, third 4 bits are register2.
	 */
	public OLine APL(ILine data) { 
		int register1, register2 = 0, encodedDatabits;
		LogicalOperation operation;
		
		try {
			register1 = Mem.reg2Bin(data.args[1]);
			
			/* Only use register2 if needed */
			if ( data.args.length > 2 ) {
				register2 = Mem.reg2Bin(data.args[3]);
			}
			
			/* Determine logical shift identifier number */
			operation = Lib.getLogicalType(data.args[2], 0, false);
					
			} catch ( Exception e ) {
				throw new JException("Unable to process APL shift instruction.", data.inLineNum);
			} catch ( Error e ) {
				throw new JException("Unable to process APL shift instruction.", data.inLineNum);			
			}
			
		/* Encode into two 6-bit partitions and one 4-bit partition starting with the leftmost digit */
		encodedDatabits = CLib.encodeNumber(encodedDatabits, 0, 5, register1);
		encodedDatabits = CLib.encodeNumber(encodedDatabits, 6, 9, operation.id);
		encodedDatabits = CLib.encodeNumber(encodedDatabits, 10, 15, register2);
		
		/* Output message */
		ret.databits = encodedDatabits;
		
		return ret;
		}
}