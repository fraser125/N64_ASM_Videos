@echo off
bass DoubleBuffer.asm -strict -benchmark
chksum64 DoubleBuffer.N64
copy DoubleBuffer.N64 Z:\