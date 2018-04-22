module Emulator.Main;

import std.string, std.stdio, std.algorithm, std.conv;
import Compiler.Globals, Emulator.CPU, Compiler.Tools, Emulator.Memory;

class EmulatorMain { 
	/** 
	 * This is the main emulate entry point. Everything basic is done here and outsourced to the "CPU".
	 */
	public bool emulate(string filename) {
		ByteLine SendLine;
		auto Proc = new CPU();
		auto Mem = new Memory();
		int lineNum = 1;
		string[] linePipeSplit, lines;
		
		/* Initialize all memory registers */
		Mem.init();
		
		lines = Compiler.Tools.TFile.getFileLines(filename);
				
		foreach ( string line; lines ) {
		
			try { 
				/* The standard delimiter for compiled JASL bytecode is pipe | */
				linePipeSplit 		= line.split("|");
				SendLine.opcode 	= to!int(strip(linePipeSplit[0]));
				SendLine.databits 	= to!int(strip(linePipeSplit[1]));
				SendLine.auxbits	= to!int(strip(linePipeSplit[2]));
				SendLine.lineNum	= lineNum;
				JEmInstLine			= lineNum;
				Proc.send(SendLine);
			} catch ( Error e ) {
				writeln(e);
				throw new JEmException("Unable to resolve data from file.", lineNum);
			} catch ( Exception e ) {	
				writeln(e);
				throw new JEmException("Unable to resolve data from file.", lineNum);
			}
			
			lineNum++;
		}
		
		return true;
	}
}