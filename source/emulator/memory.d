module Emulator.Memory;

import std.conv, std.string, std.stdio, std.algorithm;
import Compiler.Globals, Compiler.Tools;

class Memory : MemoryData {
	private string[int] registers;
	
	/** 
	 * Initialize all registers to zero upon
	 */
	public void init() {
		int i = 0;
		
		if ( MemoryData.initialized != true ) { 
			while ( i < 64 ) {
				MemoryData.registerValues[i] = 0;
				MemoryData.registerParity[i] = 0;
				i++;
				}
			MemoryData.initialized = true;
		}
	}
		
	/** 
	  * UPDATE: registers are now numbers prefixed with a $. No using words anymore (i.e. no 'CRGA', 'CRGB', etc..)
	  */
	public int reg2Bin(string reg) {
		int regReturn = -1;
		
		try { 
			/* Since register values are prefixed by $, check to see if such a number exists */
			if ( canFind(reg, "$") ) {
				regReturn = parse!int(reg.split("$")[1], 16);
			} else {
				throw new JException("Cannot determine register. Missing a '?' perhaps?");
			}
			
			/* Registers cannot be less than 0 or greater than 63. */
			if ( regReturn >= 0 && regReturn <= 63 ) {
				return regReturn;
			} else { 
				throw new JException("Register not found.");
			}
		} catch ( Error e ) {
			throw new JException("Unable to resolve register integer ID.");
		}
	}
	
	/**
	 * Retrieve register value.
	 */
	 public int getVal(int register) {
		if ( register >= 0 && register <= 63 ) {
			return MemoryData.registerValues[register];
		} else {
			return -1;
		}
	 }
	 
	 /**
	  * Set register value. Automatically sets parity flag as well.
	  */
	 public void setVal(int register, int value) {
		/* Ensure that values are within specified range (2^20 - 1) and also set parity flags. */
		if ( value > 1048575 || value < -1048575 ) {
			throw new JEmException("Register value out of accepted range: -1,048,575 to +1,048,575.");
		} else {
			MemoryData.registerValues[register] = value;
			/* Automatically set parity flags. < 0 is negative. */
			if ( value < 0 ) {
				MemoryData.registerParity[register] = 1;
			} else {
				MemoryData.registerParity[register] = 0;
			}
		}
	 }
}

/** 
 * MemoryData is a dummy class that holds memory information.
 */
class MemoryData {
	private static int[int] registerValues;
	private static int[int] registerParity;
	private static float[int] registerRationals;
	public static bool initialized;
}