@ECHO OFF
REM Simple DOS Batch to copy files to our distribution environment


IF "%SRC%" == ""  SET SRC=%~dp0
IF "%DST%" == "" SET DST=C:\Projekte\V6\SubSys\Messaging

SET SRC_CLASSES=%SRC%\OS\classes
SET SRC_TEST=%SRC%\OS\test

SET DST_CLASSES=%DST%\ModelClasses

for /f %%f in ('dir /s /b %SRC_CLASSES%\*.cls') do (
	xcopy /R /Y %%f %DST_CLASSES%
)

for /f %%f in ('dir /s /b %SRC_CLASSES%\*.txt') do (
	xcopy /R /Y %%f %DST_CLASSES%
)

cd %DST%
echo #Messaging-Model > %DST%\Model.txt
for %%f in (ModelClasses\*.txt) do (
	echo _include %%f >> %DST%\Model.txt
)

pause