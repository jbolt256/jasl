module Main.App;

import std.stdio, std.string, std.conv;
import Compiler.Main, Emulator.Main, Compiler.Globals, Main.Configuration;

/**
 * Main: entry point to the program. Everything is setup and called from here. 
 * $ dub run jasl -- <[-c] [-r] [-cr]> <filename> <fileNameOut>
 */
void main(string[] args)
{
	auto C = new CompilerMain();
	auto E = new EmulatorMain();
	auto Conf = new Config();
	enableConfig(Conf);
	
	/* Config class is initialized for compiling, emulating, and -config */
	if ( args.length >= 3 ) {
		
		/* Call compile function. Extra \r\n's for visibility */
		if ( args[1] == "-c" ) {
			writeln("\r\nJASL Compiler\r\n");
			C.compile(args[2], args[3]);
		}
		
		/* Run -- reads file and runs */
		if ( args[1] == "-r" ) {
			writeln("\r\nJASL Emulator \r\n");
			E.emulate(args[2]);
		}
		
		/* Compile & Run -- compiles to args[3] and then emulates args[3] */
		if ( args[1] == "-cr") {
			writeln("\r\nJASL Compiler\r\n");
			C.compile(args[2], args[3]);
			writeln("\r\nJASL Emulator \r\n");
			E.emulate(args[3]);
		}
	} else if ( args[1] == "-config" ) {
		writeln("CONFIGURATION DATA: \r\n");
		writeln(Conf.meta);
		writeln(Conf.settings);
	} else if ( args[1] == "-buildconfig" ) {
		Conf.buildConfig();
	} else {
		writeln("Too few arguments provided.");
		}
}    