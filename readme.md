# The JASL Project

**JASL** is a project that seeks to emulate the behavior of a theoretical 20-bit computer. This project consists of a compiler and emulator. The compiler turns human-readable code to machine-readable 
code, which is in turn read by the emulator. The emulator is designed to act as close to the 20-bit computer as reasonably possible.

## Instructions

### Requirements
- D language compiler (preferably DMD)
- 8 MB disk space & ~16MB RAM

This project has only been tested on Windows 10. I cannot ensure it will run on any *nix systems or a Mac.

### Building
This project is written in the D language. You can build this project using the dub package manager or any dlang compiler. The easiest way is to download the 
dmd compiler from the Digital Mars website and then run the following command:

`$ dmd.exe app.d`

In Windows PowerShell:

`$ ./dmd.exe ./app.d`

which will compile the program to app.exe, which can then be run using the instructions listed below.

### Running
Once compiled, JASL can be run as such:

`$ app.exe <[-c] [-r] [-cr]> <filename> <fileNameOut>`

The following are allowed syntaxes for arguments:

`-c program.jasl program.jbin` compiles program.jasl to program.jbin

`-r program.jbin` emulates the file program.jbin. This file must already be compiled!

`-cr program.jasl program.jbin` compiles program.jasl, writes to program.jbin, and then emulates the compiled file.

Of course, the names used above are placeholders.

## About
The official JASL specification (mandate 1.0) will be released sometime if necessary. Otherwise, whatever the compiler does is the official specification.

See readme.txt and meta/mandate1.txt for additional information.