# N64_ASM_Videos
The files complementing my video series N64 MIPS Assembly 

## Install the following software  
### Optional  
GCC for Windows - http://www.equation.com/servlet/equation.cmd?fa=fortran  
GCC on Windows for N64 - https://cen64.com  
Github Desktop - https://desktop.github.com  
Notepad++ - https://notepad-plus-plus.org/download/v7.6.2.html  

### Recomended  
Win7 Calculator - https://winaero.com/blog/get-calculator-from-windows-8-and-windows-7-in-windows-10/  

### Required  
MAME - https://github.com/mamedev/mame/releases  
N64 BIOS (n64.zip) - https://ia800401.us.archive.org/zipview.php?zip=/35/items/MESS-0.151.BIOS.ROMs/MESS-0.151.BIOS.ROMs.zip  
ARM9/bass - https://github.com/arm9/bass  
* Compile yourself using GCC for your platform  
* Download the version available https://sites.google.com/site/consoleprotocols/home/homebrew/n64-assembly-home/Lesson01  

## References
Cheatsheet - https://github.com/fraser125/N64_ASM_Videos/blob/master/Cheatsheet.md
VR4300 User Manual - http://n64dev.org/p/U10504EJ7V0UMJ1.pdf  
Wiki on MIPS Architecture - https://en.wikibooks.org/wiki/MIPS_Assembly/MIPS_Architecture  
Registers - http://n64dev.org/registers.html  


## Development Naming Conventions  
The following code patterns have been adopted for this repository.
* *.asm main program file.
* *.INC files contain variables, constants and macros.
* *.S files contain functions usually wrapped in macros

Jump labels that are for internal use ONLY are prefixed with an underscore _internal_label  

### Game library macros/functions are camelcase 
* prefixed lowercase 'nus' as in Nintendo Ultra System  
* next is the hardware area if applicable (i.e. AI, DP, SI, SP, VI)
* then 'init' or a descriptive name
System and Memory Layout macros are UPPERCASE  
