@echo off

set ROM=%~dpnx1

set OLDDIR=%CD%
cd \mame
mame64.exe n64 -debug -log -verbose -window -cart %ROM% -switchres -nofilter
chdir /d %OLDDIR%