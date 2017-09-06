@echo off

cd "%userprofile%\Documents\Visual Studio 2005\"
C:
if not exist Addins md Addins

cd "%userprofile%\Documents\Visual Studio 2008\"
if not exist Addins md Addins

pushd "%~dp0"

copy /y ".\JsCssCompiler.dll" "%userprofile%\Documents\Visual Studio 2005\Addins\JsCssCompiler.dll" > nul
copy /y ".\JsCssCompiler.AddIn" "%userprofile%\Documents\Visual Studio 2005\Addins\JsCssCompiler.AddIn" > nul

copy /y ".\JsCssCompiler.dll" "%userprofile%\Documents\Visual Studio 2008\Addins\JsCssCompiler.dll" > nul
copy /y ".\JsCssCompiler.AddIn" "%userprofile%\Documents\Visual Studio 2008\Addins\JsCssCompiler.AddIn" > nul

rundll32 setupapi.dll,InstallHinfSection DefaultInstall 128 .\install.inf
popd

echo.
echo Successfully installed.
echo.
pause
