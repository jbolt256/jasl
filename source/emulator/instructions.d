module Emulator.Instructions;
import std.conv, std.stdio, std.string;
import Compiler.Globals, Compiler.Tools, Emulator.Memory, Emulator.Functions;

class Instructions {
	/* This variable is reset by the CPU every line */
	public ByteLineOut lineOut;
	private Memory Mem;
	private ELibrary ELib;
	
	/**
	 * Initialize Memory:: class
	 */
	this() {
		Mem = new Memory();
		ELib = new ELibrary();
	}

	/* ERR Cmd */
	public ByteLineOut ERR(ByteLine Data) {
		lineOut.compilerMsg = "TEST.";
		lineOut.opcodeStr = "ERR";
		return lineOut;
	}
	
	public ByteLineOut XYZ(ByteLine Data) {
		lineOut.compilerMsg = "Success.";
		lineOut.opcodeStr = "XYZ";
		return lineOut;
	}
	
	/** :APL		<op>	<reg>	<flags> 
	 * 20-bit integer. 
	 */
	public ByteLineOut APL(ByteLine Data) {
		int register1, operation, register2, result, register1Value, register2Value;
		
		lineOut.opcodeStr = "APL";
		
		register1 = ELib.extractNumber(Data.databits, 0, 3);
		operation = ELib.extractNumber(Data.databits, 4, 7);
		register2 = ELib.extractNumber(Data.databits, 8, 11);
		
		register1Value = Mem.getVal(register1);
		register2Value = Mem.getVal(register2);
		
		
		/* Apply logical operations to register values */
		switch ( operation ) {
			case 0: result = register1Value | register2Value; break;
			case 1: result = register1Value & register2Value; break;
			case 2: result = ~(register1Value | register2Value); break;
			case 3: result = ~(register1Value & register2Value); break;
			case 4: result = register1Value ^ register2Value; break;
			case 5: result = ~(register1Value ^ register2Value); break;
			case 6: result = ~register1Value; break;
			case 7: result = register1Value; break;
			default: operation = 7; break;
			}
			
		writeln(result);
		
		lineOut.compilerMsg = "APL.";

		return lineOut;
	}
}