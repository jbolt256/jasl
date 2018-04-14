module Emulator.Memory;
import std.conv, std.string, std.stdio, std.algorithm;
import Compiler.Globals, Compiler.Tools;

class Memory {
	protected string[int] registers;
	private int[int] registerValues;
	protected int[int] registerParity;
	protected float[int] registerRationals;
	protected bool initialized;
	
	/** 
	 * Initialize all registers to zero upon
	 */
	public void init() {
		int i = 0;
		while ( i < 16 ) {
			this.registerValues[i] = 0;
			this.registerParity[i] = 0;
			i++;
			}
		this.initialized = true;
		}
		
	/** 
	  * UPDATE: registers are now numbers prefixed with a $. No using words anymore (i.e. no 'CRGA', 'CRGB', etc..)
	  */
	public int reg2Bin(string reg) {
		int regReturn = -1;
		
		try { 
			/* Since register values are prefixed by $, check to see if such a number exists */
			if ( canFind(reg, "$") ) {
				regReturn = to!int(reg.split("$")[1]);
			} else {
				throw new JException("Cannot determine register. Missing a '?' perhaps?");
			}
			
			/* Registers cannot be less than 0 or greater than 15. */
			if ( regReturn >= 0 && regReturn <= 15 ) {
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
		if ( register >= 0 && register <= 15 ) {
			return this.registerValues[register];
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
			this.registerValues[register] = value;
			/* Automatically set parity flags. < 0 is negative. */
			if ( value < 0 ) {
				this.registerParity[register] = 1;
			} else {
				this.registerParity[register] = 0;
			}
		}
	 }
}