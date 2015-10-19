SET OSTUDIOEXE=C:\Program Files (x86)\ObjectStudio711\ostudio.exe
SET IMAGE=C:\Program Files (x86)\ObjectStudio711\ostudio.img
SET LOADFILE=%TEMP%\OS7Load.txt

echo %~dp0\OS\test\ApplicationLoader.cls > %LOADFILE%

cd OS
start "ObjectStudio" "%OSTUDIOEXE%" "-i%IMAGE%" -l%LOADFILE%
