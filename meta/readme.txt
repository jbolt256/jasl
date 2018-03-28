						README
				Last Revised March 28, 2018
						jbolt256
						
						
+-----------------------+
+						+
+	TABLE OF CONTENTS	+
+						+
+-----------------------+

0. About & Info
1. Building & Running
2. JASL Language
3. JASL Emulator
4. Mandates


+-----------------------+
+						+
+0. About & Info 	+
+						+
+-----------------------+

JASL consists of two (mostly disjoint) subprograms: a compiler and an emulator. The compiler takes JASL code and compiles it to 
JBIN code, and the emulator takes JBIN code and emulates it. The emulator acts like a theoretical 16-bit computer that I designed
but never built. Therefore, not everything acts like one would expect. The way that the computer operates is different than most,
for it does not have any central CPU clock (and no multi-threading, though there is support for parallel processing). For information
about the JASL language, see section 2. For information on the emulator, see section 3.


+-----------------------+
+						+
+	2. JASL Language	+
+						+
+-----------------------+				
	
+-----------------------+
+	2.1 The Basics		+
+-----------------------+
JASL is a language quite similar to assembly in syntax. Each command is defined by a three word identifier (i.e "XYZ", "JMP", "MOV", etc.)
The word identifier (hereafter called opcode) is ALWAYS the first word in any and EVERY program line. Here is an example line:
			
			:XYZ 	64						(2.1.1)

This calls the "XYZ" instruction with the first argument of "64". 
			
There is no "HELLO WORLD" example, at least not yet, because JASL cannot print to a command line. There is an 8x8 screen that can be printed to,
but I have not yet built functionality for this. Therefore, (2.1.1) is the essentially the simplest program you can develop.

+-----------------------+
+	2.2 Comments		+
+-----------------------+
One can insert comments on newlines and at the end of lines only. The comment delimiter is '#'. Multi-line comments open with '##' and close with '##'. They
can also be inserted at the end of lines.
Commented lines are entirely ignored by the compiler and do not affect the resulting JBIN code, as should be expected.		

+-----------------------+
+	2.3. Instructions	+
+-----------------------+
Consider the following example:
