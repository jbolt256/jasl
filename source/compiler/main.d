module Compiler.Main;
import std.string, std.conv, std.stdio, std.algorithm;
import Compiler.Tools, Compiler.Globals, Compiler.Modifier;

class CompilerMain {

	private Modifiers M;
	private JCMain JC;
	
	/** Initialize necessary classes **/
	this() {
		M = new Modifiers();
		JC = new JCMain();
	}
	
	/** 
	 * This controls the entire compiler routine. The only improvement, I think, would be to output the byte line 
	 * as soon as it is formatted, not all of the lines at the end.
	 */
	public void compile(string filenameIn, string filenameOut) {
		/* Just a note: line numbers start at 1, not 0 */
		int inLineNum = 1, outLineNum = 1, i = 1, doubleHashes = 0;
		bool isNormalLine, isCommented = false;
		
		ILine ILine_current;
		ILine[int] ILine_all;
		
		OLine[int] OLine_all;
		OLine OLine_current;
		OLine_current.opcode = -1;
		OLine_current.databits = -1;
		
		string[] fileLines, fileLineSplit, fileLinesOut, fileLineSplit_before;

		fileLines = Compiler.Tools.TFile.getFileLines(filenameIn);
		
		foreach ( string fileLine; fileLines ) {
			/* Support for double-commented lines 
			 * This surprisingly simple solution checks for even numbers of doubleHashes. When this occurs, reset the number and continue on.
			 */
			doubleHashes = doubleHashes + count(fileLine, "##");
			if ( (doubleHashes % 2) == 0 ) {
				isCommented = false;
				doubleHashes = 0;
			} else { 
				isCommented = true;
				}
			
			/* Normal lines are ones that start with :.
			 * Comment lines start with #, and are ignored.
			 * All other lines are JC, and are sent to the JC processor.
			 * So of the three line styles, only one is actually processed here (normal lines).
			 */
			if ( fileLine.startsWith(":") && isCommented == false ) {
				isNormalLine = true;
			} else {
				isNormalLine = false;
			}
			
			/* Ignore comment lines, and ones that are blank but still in proper form. */
			if ( !fileLine.startsWith("#") && isNormalLine == true ) {
				/* Clear fileLineSplit buffer */
				fileLineSplit = fileLineSplit.init;
				
				/* If the code contains a line-comment ('#'), then split string twice.
				 * Otherwise, split string only once by tab.
				 */			
				if ( canFind("#", fileLine) ) {
					fileLineSplit_before = fileLine.split("#")[0].split("	");
				} else { 
					fileLineSplit_before = fileLine.split("	");
				}
				
				
				/* Don't include blank arguments in new split array */
				foreach ( string segment ; fileLineSplit_before ) {
					if ( segment != "" && segment != "	" && segment != null && segment != "  " ) {
						fileLineSplit ~= strip(segment);
					}
				}
				
				/* Try to set up struct data for ILine_current. Should any of these fail,
				 * throw an exception and exit program.
				 */
				try { 
					ILine_current.args 		= fileLineSplit;
					ILine_current.argc 		= fileLineSplit.length;
					ILine_current.modifier 	= fileLineSplit[0][1..4];
					ILine_current.inLineNum = inLineNum;
					ILine_current.outLineNum = outLineNum;
					ILine_current.levelType = fileLineSplit[0][0..1];
					ILine_all[inLineNum] = ILine_current;
				} catch ( Error e ) {
					throw new JException("Compiler was unable to read malformed line.", inLineNum);
				} catch ( Exception e ) {
					throw new JException("Compiler was unable to read malformed line.", inLineNum);
				} finally {
					OLine_current = this.send(ILine_current);
				}
				
				/* Only increment outLineNum if send was a success, also if opcode is <65 and >-1 (i.e 0..64) */
				if ( OLine_current.opcode > -1 && OLine_current.opcode < 65 ) {
					OLine_all[outLineNum] = OLine_current;			
					outLineNum++;
				}
				
			} else {
				/* Comment lines are ignored entirely, so if this isn't a normal line and it isn't a 
				 * comment line, it must be a JC line.
				 */
				if ( !fileLine.startsWith("#") ) {
					//JC.eval(fileLine, inLineNum, outLineNum);
				}
			}
			
			inLineNum++;
		}
		
		/* So for some reason, dlang likes to read this array backwards, beginning with the last element and then
		 * moving towards the first. I use an index variable (i) to prevent this. (However, the backwards reading
		 * would make for a neat feature).
		 */
		 
		foreach ( OLine outLine; OLine_all ) {
			fileLinesOut ~= to!string(OLine_all[i].opcode) ~ "|" ~ to!string(OLine_all[i].databits);
			
			if ( outLine.cmdlineMsg != null ) {
				writefln("%s : %s () ~~ %s", OLine_all[i].inLineNum,  OLine_all[i].modifier, OLine_all[i].cmdlineMsg);
			} else {
				writefln("%s : %s () ~~",  OLine_all[i].inLineNum,  OLine_all[i].modifier);
			}
			
			i++;
		}
		
		/* Write data to file and set newline */
		Compiler.Tools.TFile.toFile(filenameOut, fileLinesOut);
		writeln("");
	}

	/**
	 * FUNCTION: send ( ILine data )
	 * RETURNS: OLine
	 * DESCRIPTION: This function accepts a standard line input (ILine) and returns a modified standard line output (OLine).
	 * It also sets the .modifier and .inLineNum attributes.
	 */
	private OLine send(ILine data) {
		OLine toReturn;
		
		/* Reset modifier return */
		M.ret = M.ret.init;
		
		/* Try and find modifier -- throws OPCODE_DNE otherwise. */
		try { 
			if ( M.opcodeAttrib[data.modifier].minArgs <= data.argc ) {
				switch ( data.modifier ) {
					case "XYZ": toReturn = M.XYZ(data); break;
					case "ERR": toReturn = M.ERR(data); break;
					case "APL": toReturn = M.APL(data); break;
					default: 
						throw new JException("Opcode does not exist.", data.inLineNum);
				}	
				
				/* Unless modifier returns own opcode, use attributes */
				if ( toReturn.opcode == 0 ) {
					toReturn.opcode = M.opcodeAttrib[data.modifier].opcode;
				}
			} else {
				throw new JException("Too few arguments provided to call opcode.", data.inLineNum);
			}
		} catch ( Error e ) {
			writeln(e);
			throw new JException("Exception calling opcode. Perhaps opcode does not exist?", data.inLineNum);
		} catch ( Exception e ) {		
			throw new JException("Error calling opcode. Perhaps opcode does not exist?", data.inLineNum);
		}
		
		/* The modifiers don't typically return these values, so force them. */
		toReturn.inLineNum	= data.inLineNum;
		toReturn.modifier	= data.modifier;
		
		return toReturn;
	}
}