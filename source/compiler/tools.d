module Compiler.Tools;
import std.stdio, std.string, std.algorithm, std.conv, std.file, core.stdc.stdlib;
import Compiler.Globals;

class TFile {
	/**
	 * Returns an array with all the lines from a file.
	 */
	public static string[] getFileLines(string filename) {
		string[] lines;
		try {
			foreach (line ; File(filename).byLine) {
				lines ~= to!string(line);     
			}
		} catch ( Exception e ) {
			writeln("An error ocurred while attempting read file ", filename, ".");
		}

		return lines; 
	}
		
	/**
	 * Takes a filename and an array of all the lines and writes it to  file.
	 */
	public static void toFile(string filename, string[] lines) {
		std.file.write(filename, "");
		uint l = 1;
		try { 
			foreach ( line; lines ) {
				std.file.append(filename, line ~ "\r\n");
				l++;
			}
		} catch ( Exception e ) {
			writeln(__FUNCTION__, "Unable to write to file.");
		}
	}
}

class Extra {
	/**
	 * FUNCTION: formatNumber 
	 * RETURNS: int
	 * PARAMETERS: ( string number, int minValue, uint maximumValue, bool warnings )
	 * DESCRIPTION: Takes a string with a number that could be an integer, a hexadecimal number, a base-32 number, or none of those. If the value is
	 * not base-10, base-16 or base-32, it returns 0, which indicates an error. Also accepts maximum and minimum numbers.
	 */
	public static int formatNumber(string value, int minValue = -1048575, uint maxValue = 1048575, bool warnings = true) {
		int returnInt; 
		string valueWithoutPrefix;
		valueWithoutPrefix = value[1..value.length];
		
		/* If the string begins with x, it is hexadecimal. If it starts with t, it is a base-32 number. Otherwise, probably an integer.
		 * base-16 : hexadecimal standard
		 * base-32 : triacontakaidecimal (not RFC4648)
		 */
		if ( value.startsWith("x") ) {
			returnInt = parse!int(valueWithoutPrefix, 16);
			} else if ( value.startsWith("t") ) {
			returnInt = parse!int(valueWithoutPrefix, 32);
			} else {
			try { 
				returnInt = to!int(value);
				} catch ( Exception e ) {
				if ( warnings ) {
					throw new JException("Attempted to format a non-integer.");
					}
				}
			}
		
		/* ensure that the number is within the ranges specified. Default is between -65535 and 65535. */
		if ( maxValue > returnInt && minValue < returnInt ) {
			return returnInt;
		} else {
			if ( warnings ) {
				throw new JException("Number is too large to format.");
			}
		}

		return returnInt;
	}		
	
	/** 
	 * Attempt to convert a string (ex. "$") to the proper level type identifier.
	 */
	public static int levelTypeStr2Int(string val) {
		int levelType = -1;
		
		switch ( val ) {
			case ":": levelType = 0; break;
			default: levelType = -1; break;
		}
		
		if ( levelType == -1 ) {
			throw new JException("Incorrect level type while converting string to int.");
		}
		
		return levelType;
	}
}






/*** WARNING ***
 * You probably don't want to read past this point. The code below is less than ideal by pretty much every standard.
 ***/
/** 
 * JEception throws an error. Set flag exit to 1 to force close application.
 */
class JException : Exception {
    this(string msg, int cLine = 0, int exit = 1, string file = __FILE__, size_t line = __LINE__) {
		writeln(":: EXCEPTION (" ~ to!string(cLine) ~ ") :: " ~ msg);
		if ( exit != 0 ) {
			core.stdc.stdlib.exit(1);
		}
		super(msg, file, line);
    }
}

/**
 * JWarning throws a warning. It cannot force close the application.
 */
class JWarning : Exception {
    this(string msg, int cLine = 0, string file = __FILE__, size_t line = __LINE__) {
		super(msg, file, line);
		writeln(":: WARNING (" ~ to!string(cLine) ~ ") :: " ~ msg);
    }
}

class JEmException : Exception {
    this(string msg, int cLine = 0, int exit = 0, string file = __FILE__, size_t line = __LINE__) {		
		writeln(":: ERROR (" ~ to!string(cLine) ~ ") :: " ~ to!string(msg));
		
		if ( exit != 0 ) {
			core.stdc.stdlib.exit(1);
		}
		
		super(msg, file, line);
    }
}