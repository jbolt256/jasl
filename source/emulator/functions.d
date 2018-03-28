module Emulator.Functions;
import std.stdio, std.string, std.algorithm, std.math, std.conv;
import Compiler.Tools, Compiler.Globals;

class ELibrary {
	/**
	 * Extract the integer value of the binary digits of an integer between start and end INCLUSIVE!.
	 * Inverse of this is CLibrary.encodeNumber()
	 */
	public int extractNumber(int num, ushort start, ushort end, int bitLength = 20) {
		int remainder;
		float result, floatNum = to!float(num);
		
		remainder = num % pow(2, bitLength - start + 1);
		writeln(remainder);
		result = floor(to!float(remainder) / pow(2, (bitLength - end)));
		
		/* Should already be integer, but just to be sure... */
		return to!int(result);
	}
}
