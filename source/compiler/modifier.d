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
		int register1, register2 = 0, operation, encodedDatabits;
		
		try {
			register1 = Mem.reg2Bin(data.args[1]);
			
			/* Only use register2 if needed */
			if ( data.args.length > 2 ) {
				register2 = Mem.reg2Bin(data.args[3]);
			}
			
			/* Determine logical shift identifier number */
			switch ( data.args[2] ) {
				case "OR": operation = 0; break;
				case "AND": operation = 1; break;
				case "NOR": operation = 2; break;
				case "NAND": operation = 3; break;
				case "XOR": operation = 4; break;
				case "XNOR": operation = 5; break;
				case "NOT": operation = 6; break;
				case "BUF": operation = 7; break;
				default: operation = 7; break;
				}
			} catch ( Exception e ) {
				throw new JException("Unable to process APL shift instruction.", data.inLineNum);
			} catch ( Error e ) {
				throw new JException("Unable to process APL shift instruction.", data.inLineNum);			
			}
			
		/* Encode into three 4-bit partitions starting with the leftmost digit */
		encodedDatabits = CLib.encodeNumber(encodedDatabits, 0, 3, register1);
		encodedDatabits = CLib.encodeNumber(encodedDatabits, 4, 7, operation);
		encodedDatabits = CLib.encodeNumber(encodedDatabits, 8, 11, register2);
		
		/* Output message */
		ret.databits = encodedDatabits;
		
		return ret;
		}
}