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
	 * 20-bit integer. Bits 1 - 4 are opcode, 5 - 8 register, 9 is flags. 
	 */
	//public ByteLineOut APL(ByteLine Data) {
		
	//}
}