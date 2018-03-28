module Emulator.CPU;
import std.stdio, std.conv, std.string, std.math, std.algorithm;
import Compiler.Globals, Emulator.Instructions, Compiler.Tools;

class CPU {
	public ByteLineOut LineOut;
	private Instructions I;
	
	/** Initialize **/
	this() {
		LineOut = LineOut.init;
		I = new Instructions();
	}
	
	/**
	 * Send data to call(), which does most of the work. If the instructions returns a compiler message,
	 * print it.
	 */
	public ByteLineOut send(ByteLine Line) {
		ByteLineOut K;
		
		/* Try sending data to this.call() */
		try { 
			K = this.call(Line);
		} catch ( Exception e ) {
			throw new JEmException("Unable to call instruction.", K.lineNum);
		}
		
		/* Display compilerMsg if necessary */
		if ( K.compilerMsg != null ) {
			writeln(K.opcodeStr ~ " (" ~ to!string(K.lineNum) ~ ") " ~ " ~~ " ~ K.compilerMsg);
		}
		
		return K;
	}
	
	/**
	 * This function returns a formatted ByteLineOut. Essentially, it just calls and returns the data from
	 * an instruction in the instructions:: class.
	 */
	private ByteLineOut call(ByteLine Line) {
		ByteLineOut toReturn;
		
		/* Clear any previous return data in the Instructions:: class */
		I.lineOut = I.lineOut.init;
		
		/* Try and call instruction */
		switch ( Line.opcode ) {
			case 64: toReturn = I.ERR(Line); break;
			case 63: toReturn = I.XYZ(Line); break;
			default: toReturn.compilerMsg = "Unidentified opcode."; break;
		}
		
		/* Set line number to current line number, it doesn't matter anyways */
		toReturn.lineNum = Line.lineNum;
		
		if ( toReturn.opcodeStr == null ) {
			toReturn.opcodeStr = "ERR";
			}
				
		return toReturn;
	}
}