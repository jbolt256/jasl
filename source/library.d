module Main.Library;
import Compiler.Globals;

import std.conv, std.string, std.stdio;

struct LogicalOperation {
	string operation;
	int id;
}

class Library {
	
	/**
	 * If type is true, then it returns a STRING VALUE for an INTEGER ID.
	 * If type is false, then it returns an INTEGER ID for a STRING VALUE.
	 */
	public LogicalOperation getLogicalType(string name, int id, bool type) {
		LogicalOperation op;
				
		string[int] LogicalOperations = [
			0 : "OR",
			1 : "AND",
			2 : "NOR",
			3 : "NAND",
			4 : "XOR",
			5 : "XNOR",
			6 : "NOT",
			7 : "BUF"
			];
			
		if ( type ) {
			op.operation = LogicalOperations[id];
			op.id = id;
		} else {
			/* Again, looping over associative arrays is easier with a for loop, apparently */
			for ( int i = 0 ; i < LogicalOperations.length; i++ ) {
				if ( LogicalOperations[i] == name ) {
					op.id = i;
					break;
				}
			}
			op.operation = name;
		}
		
		return op;
	}
}