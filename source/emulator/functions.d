module Emulator.Functions;
import std.stdio, std.string, std.algorithm, std.math, std.conv;
import Compiler.Tools, Compiler.Globals;

class ELibrary {
	/**
	 * Extract the integer value of the binary digits of an integer between start and end INCLUSIVE!.
	 * Inverse of this is CLibrary.encodeNumber(). Both functions are not ZERO-INDEXED: the first digit
	 * is the first digit -- except for the BitLength variable, which is not. 
	 */
	public int extractNumber(int num, ushort start, ushort end, int bitLength = 20) {
		int remainder;
		float result, floatNum = to!float(num);
		
		/* The mathematics below is zero-indexed, but the inverse of this function (encoding) is not zero-indexed,
		 * so we decrement these numbers by one. This zero-indexes the numbers whilst also allowing this to be the
		 * inverse of encodeNumber().
		 */
		start--;
		end--;
		
		if ( bitLength - start == 0 ) { 
			remainder = num;
		} else {
			remainder = num % pow(2, bitLength - start);
		}
		
		result = floor(to!float(remainder) / pow(2, (bitLength - end - 1)));
		
		/* Should already be integer, but just to be sure... */
		return to!int(result);
	}
}
