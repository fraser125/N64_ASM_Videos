@echo off
echo.
echo      ExceptionHandler
cmd /c ..\lib\ExceptionHandler.cmd
echo.
echo      Exceptions
bass Exceptions.asm -strict -benchmark
chksum64 Exceptions.N64