SET OSTUDIOEXE=C:\Program Files (x86)\ObjectStudio711\ostudio.exe
SET IMAGE=C:\Program Files (x86)\ObjectStudio711\ostudio.img
SET LOADFILE=%TEMP%\OS7Load.txt

echo _include %~dp0\OS\OS7-Generator.txt > %LOADFILE%

cd OS
start "ObjectStudio" "%OSTUDIOEXE%" -i"%IMAGE%" -l%LOADFILE%
