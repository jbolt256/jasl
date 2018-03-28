module Compiler.Globals;

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
	int opcode, databits;
	int inLineNum, outLineNum;
	string compilerMsg, cmdlineMsg, modifier;
}

/**
 * Modifier attributes. These are set in the modifier.d file.
 * Currently, maxArgs is not enforced by the compiler.
 */
struct ModAttrib {
	int minArgs, maxArgs;
}

/** 
  * These next two structs are used exclusively by the emulator to when working with
  * lines that have already been compiled by the JASL compiler.
  */
struct ByteLine {
	int opcode, databits, lineNum;
}

struct ByteLineOut {
	int opcode, databits, lineNum;
	string compilerMsg, opcodeStr;
}