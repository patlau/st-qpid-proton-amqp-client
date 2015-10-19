@ECHO OFF
REM Simple DOS Batch to copy files to our distribution environment


IF "%SRC%" == ""  SET SRC=%~dp0
IF "%DST%" == "" SET DST=C:\Projekte\V6\SubSys\Messaging

SET SRC_CLASSES=%SRC%\OS\classes
SET SRC_TEST=%SRC%\OS\test

SET DST_CLASSES=%DST%\ModelClasses
rmdir /S /Q %DST_CLASSES%
mkdir %DST_CLASSES%

xcopy /E /R /Y %SRC_CLASSES% %DST_CLASSES%

cd %DST%
echo #Messaging-Model > %DST%\Model.txt
for %%f in (ModelClasses\*.txt) do (
	echo _include %%f >> %DST%\Model.txt
)

cd %SRC%

SET DST_TEST=%DST%\Test
rmdir /S /Q %DST_TEST%
mkdir %DST_TEST%

for /f %%f in ('dir /s /b %SRC_TEST%\*Test.cls') do (
	xcopy /R /Y %%f %DST_TEST%
)

cd %DST%
echo #Messaging-Test > %DST%\Test.txt
for %%f in (Test\*.cls) do (
	echo %%f >> %DST%\Test.txt
)
