SET OSTUDIOEXE=C:\Program Files (x86)\Cincom\ObjectStudio8.7\ObjectStudio.exe
SET IMAGE=C:\ProgramData\Cincom\ObjectStudio8.7\ObjectStudio.im
SET LOADFILE=%TEMP%\OS7Load.txt

echo %~dp0\OS\test\ApplicationLoader.cls > %LOADFILE%

cd OS
start "ObjectStudio" "%OSTUDIOEXE%" "%IMAGE%" -ostudio "-l%LOADFILE%"
