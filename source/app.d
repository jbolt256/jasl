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
	
	/* Create new Config, send to enableConfig() */
	auto Conf = new Config();
	enableConfig(Conf);
	
	/* Setup conf */
	writefln(">>>\r\n>>>JASL Version %s, release date %s, mandate specification #%s.\r\n>>>", GlobalConfig.meta["JASL"].tags["Version"], GlobalConfig.meta["JASL"].tags["ReleaseDate"], 
	GlobalConfig.settings["useMandate"].tags["Data"]);
	
	/* This is an inefficient but basic way to handle arguments, since very few arguments need to be
	 * processed by the app.
	 */
	 
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
		
	/* Outputs unformatted, parsed configuration data */
	} else if ( args[1] == "-config" ) {
		writeln("CONFIGURATION DATA: \r\n");
		writeln(GlobalConfig.settings["useTabs"].tags);
		
	/* Builds new config from default */
	} else if ( args[1] == "-buildconfig" ) {
		Conf.buildConfig();
		
	/* Otherwise, not enough arguments. */
	} else {
		writeln("Too few arguments provided.");
	}
}    