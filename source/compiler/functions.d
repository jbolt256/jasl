module Compiler.Functions;
import std.conv, std.stdio, std.string, std.algorithm, std.math;
import Compiler.Tools, Compiler.Globals;

class CLibrary {
	/** 
	 * Encode a number into an integer of a fixed-length.
	 * Inverse of this is ELibrary.extractNumber()
	 */
	public int encodeNumber(int num, int start, int end, int value, int bitLength = 20) {
		
		/* The start value doesn't actually mean anything, in some sense. Binary numbers, are fixed by the rightmost digit,
		 * not the leftmost. We just check to ensure that the number being inserted is not greater than the maximum number
		 * for that block. I.e, if we are inserting a 6-bit binary number from digits 3 to 8 (inclusive), the maximum number
		 * is 63, otherwise it would run for 7 digits.
		 */
		if ( value > 0 ) { 
			if ( value < pow(2, end - start + 1) ) {
				/* Multiply this number to be inserted by 2^n, where n is the number of digits to the right of the endpoint */
				if ( (bitLength - end - 1) == 0 ) { 
					num = num + value;
				} else {
					num = num + ( value * pow(2, bitLength - end));	
				}
			} else {
				throw new JException("Number too large to encode.");
			}
		}
		return num;
	}
}