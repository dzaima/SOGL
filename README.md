# SOGL
A very weakly typed language, meaning that every function will do something for all types of input.  
For example, 05AB1E has a function `u` for uppercasing and `î` for ceiling, but SOGL has one for both - `U`.  
You'll never need to uppercase a number and take the ceiling of a string, will you?  
This makes the language very complex, but makes many more free characters available.  
If anything, then kolmogorov-complexity is the languages strong side.  

note: this language is very much in developement, and can, and probably will change a lot in the future, so if used, always keep the version number (or the last commit) the program was made for.

### To run a program, 

  - download [V0.8](https://github.com/dzaima/SOGL/blob/master/P5ParserV0_8_2/P5Parser.zip), [V0.9](https://github.com/dzaima/SOGL/blob/master/P5Parser/P5Parser.zip) (for challenges posted before ~30th of April), or the new (and possibly very glitchy) [V0.10](https://github.com/dzaima/SOGL/blob/master/P5Parser/P5Parser.zip)
  - make a file with the program as its contents
  - launch with the 1st argument as a path (either relative to the `data/` path or a full path) to the file and the continuing args as inputs
  - the output will be on STDOUT and/or (depending on `data/options.txt`) in the file `output.txt`

Find what each char does in [here](https://github.com/dzaima/SOGL/blob/master/charDefsParser/data/charDefs.txt).
