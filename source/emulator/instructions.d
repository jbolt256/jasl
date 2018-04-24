module Emulator.Instructions;

import std.conv, std.stdio, std.string, std.format;
import Compiler.Globals, Compiler.Tools, Emulator.Memory, Emulator.Functions, Main.Library;

class Instructions {
	/* This next variable is reset by the CPU every line */
	public ByteLineOut lineOut;
	private Memory Mem;
	private ELibrary ELib;
	private Library Lib;
	
	/**
	 * Initialize Memory:: class
	 */
	this() {
		Mem = new Memory();
		ELib = new ELibrary();
		Lib = new Library();
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
	
	/** 
	 * :APL		<op>	<reg>	<flags> 
	 * 20-bit integer. 
	 */
	public ByteLineOut APL(ByteLine Data) {
		int register1, operation, register2, result, register1Value, register2Value;
		
		lineOut.opcodeStr = "APL";
		
		register1 = ELib.extractNumber(Data.databits, 1, 6);
		operation = ELib.extractNumber(Data.databits, 7, 12);
		register2 = ELib.extractNumber(Data.databits, 13, 18);
		
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
			default: result = register1Value; break;
			}
					
		lineOut.compilerMsg = format("Applying logical operation #%s to registers %s and %s.", operation, register1, register2);

		return lineOut;
	}
	
	/**
	 * :ADD		<reg1>		<num||reg2>		<reg3>*
	 * (reg3 not implemented at the moment)
	 * Adds two registers together OR adds a number to a register.
	 */
	public ByteLineOut ADD(ByteLine Data) { 
		int register1Parity, register2Parity;
		int reg1Name, reg2Name, reg3Name, regFlag;
		int register1, register2, register3, r = 1500000, encodedDatabits;
		string text;
		
		lineOut.opcodeStr = "ADD";
		
		reg1Name = Data.auxbits;
		regFlag  = ELib.extractNumber(Data.databits, 1, 1);
		reg2Name = ELib.extractNumber(Data.databits, 2, 20);
		
		/* This convoluted adding system is how the computer would add digits, oddly enough */
		try { 
			register1 = Mem.getVal(reg1Name);
			register1Parity = Mem.getParity(reg1Name);

			/* regFlag being zero indicates that the second number identifies a register, not a number. This is how the computer
			 * interprets things so this is how we will do it as well.
			 */
			if ( regFlag == 0 ) { 
				register2 = Mem.getVal(reg2Name);
				register2Parity = Mem.getParity(reg2Name);
			} else {
				register2 = to!int(reg2Name);
				Lib.parity(register2);
			}
						
			if ( register1Parity == 0 && register2Parity == 0 ) { r = register1 + register2;  } 
			if ( register1Parity == 1 && register2Parity == 1 ) { r = -(register1 + register2); }
			
			/* If the previous two lines fail to change the value of r, then proceed to this switch() case. Otherwise,
			 * don't do this. 
			 */
			if ( r == 1500000 ) { 
				switch ( register1 > register2 ) {
					case true: if ( register1Parity == 0 ) { r = register1 - register2; } else { r = -(register1 - register2); }; break;
					case false: if ( register1Parity == 0 ) { r = -(register2 - register1); } else { r = register2 - register1; }; break;
					default: throw new JEmException("Adder switch case broken.", JEmInstLine);
				}
			}
						
			Mem.setVal(0, r); /* Write to register 0 for now */
			
		} catch ( Exception e ) { throw new JEmException("Error while attempting to add.", JEmInstLine); 
		} catch ( Error e ) { throw new JEmException("Error while attempting to add.", JEmInstLine); }
		
		if ( regFlag == 0 ) {
			text = " register";
		}
		
		lineOut.compilerMsg = format("Adding register %s and%s %s, writing to register 0.", reg1Name, text,reg2Name);
		return lineOut;
	}
}