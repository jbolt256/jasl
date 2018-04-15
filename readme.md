# The JASL Project

**JASL** is a project that seeks to emulate the behavior of a theoretical 20-bit computer. This project consists of a compiler and emulator. The compiler turns human-readable code to machine-readable 
code, which is in turn read by the emulator. The emulator is designed to act as close to the 20-bit computer as reasonably possible, executing the instructions on a
virtual machine. This theoretical 20-bit computer could be physically constructed.

## Instructions

### Requirements

In order to build this program, you will need:
- A D2 language compiler (preferably DMD: https://dlang.org/download.html#dmd)
- ~8 MB disk space & ~16MB RAM

If you are using dub with this project, you will also need:
- dxml package (available on dub: https://code.dlang.org/packages/dxml)

This project has only been tested on Windows 10. I cannot ensure it will run on any other systems.

### Building
This project is written in the D language. You can build this project using the dub package manager or any D2 language compiler. The easiest way is to download the 
dmd compiler from the Digital Mars website (linked above) and then run the following command

`$ ./dmd.exe ./app.d`

which will compile the program to app.exe. Rename that file to 'jasl.exe'. Then build the config by running

`$ ./jasl.exe -buildconfig`

Which should place a file called "config.xml" into your current working directory. If this fails, you may need to manually create a config.xml
by copying meta/config.default.xml.

#### Alternative Method

Alternatively, released versions (marked by 0.x.x), will have compiled exe files available. Go to https://github.com/jbolt256/jasl/releases to see available
releases. Released versions will always be built from the branch with that version number (i.e release 0.2.2 would be built from branch v0.2.2).

### Running
Once the config has been built, JASL can be run as such:

`$ app.exe <[-c] [-r] [-cr] [-config] [-buildconfig]> <filename> <fileNameOut>`

The following are allowed syntaxes for arguments:

`-c program.jasl program.jbin` compiles program.jasl to program.jbin

`-r program.jbin` emulates the file program.jbin. This file must already be compiled!

`-cr program.jasl program.jbin` compiles program.jasl, writes to program.jbin, and then emulates the compiled file.

`-config` displays the parsed XML config (config.xml)

`-buildconfig` builds a new default config.xml (see meta/config.default.xml)

Of course, the names used above are placeholders.

## Other

### Notepad++
Custom syntax highlighting for notepad++ can be found at meta/notepad++UDL.xml. Follow the instructions listed at the top of that file
to install highlighting.

For best formatting, use a tab-indent equal to 4 spaces.

### About
The official JASL specification (mandate 1.0) will be released sometime if necessary. Otherwise, whatever the compiler does is the official specification.

See readme.txt and meta/mandates/mandate1.txt for additional information.