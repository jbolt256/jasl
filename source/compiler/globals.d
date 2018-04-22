module Compiler.Globals;
import Main.Configuration;

Config GlobalConfig;

const uint JASL_vers= 1000;
bool JASL_strict	= false;		// not yet a feature
bool JASL_usingJC	= false;		// the compiler will set this if needed
int JEmInstLine		= 0;			// global current emulator line used CAUTIOUSLY for instructions ONLY

/** 
 * struct ILine
 * This struct contains all the data needed to form a standard input line (non-JC style).
 */
struct ILine {
	int inLineNum, outLineNum, argc;
	string compilerMsg, levelType, modifier;
	string[] args;
	}
	
/**
 * struct OLine
 * This struct contains all the data needed to form an output line.
 */
struct OLine {
	int opcode, databits, auxbits;
	int inLineNum, outLineNum;
	string compilerMsg, cmdlineMsg, modifier;
}

/**
 * Modifier attributes. These are set in the modifier.d file.
 * Currently, maxArgs is not enforced by the compiler.
 */
struct ModAttrib {
	int opcode, minArgs, maxArgs;
}

/** 
  * These next two structs are used exclusively by the emulator to when working with
  * lines that have already been compiled by the JASL compiler.
  */
struct ByteLine {
	int opcode, databits, lineNum, auxbits;
}

struct ByteLineOut {
	int opcode, databits, lineNum;
	string compilerMsg, opcodeStr;
}

/** 
 * This function creates a single instance of the Config so that it can be used globally by other
 * methods.
 */
void enableConfig(Config c) {
	GlobalConfig = c;
}