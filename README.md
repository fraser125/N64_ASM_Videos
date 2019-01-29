# N64_ASM_Videos
The files complementing my video series N64 MIPS Assembly 

Install the following software  
**Optional**  
GCC for Windows - http://www.equation.com/servlet/equation.cmd?fa=fortran  
GCC on Windows for N64 - https://cen64.com  
Github Desktop - https://desktop.github.com  
Notepad++ - https://notepad-plus-plus.org/download/v7.6.2.html  

**Recomended**  
Win7 Calculator - https://winaero.com/blog/get-calculator-from-windows-8-and-windows-7-in-windows-10/  

**Required**  
MAME - https://github.com/mamedev/mame/releases  
N64 BIOS (n64.zip) - https://ia800401.us.archive.org/zipview.php?zip=/35/items/MESS-0.151.BIOS.ROMs/MESS-0.151.BIOS.ROMs.zip  
ARM9/bass - https://github.com/arm9/bass  
* Compile yourself using GCC for your platform  
* Download the version available https://sites.google.com/site/consoleprotocols/home/homebrew/n64-assembly-home/Lesson01  

**Development Conventions**  
The following code patterns have been adopted for this repository.
* *.asm main program file.
* *.INC files contain variables, constants and macros.
* *.S files contain functions usually wrapped in macros

Jump labels that are for internal use only are prefixed with an underscore _internal_label  
Game library macros/functions are camelcase with a prefixed lowercase 'nus' as in Nintendo Ultra System  
System and Memory Layout macros are UPPERCASE  
