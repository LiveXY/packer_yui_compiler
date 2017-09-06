@echo off
echo *******************************************************************************
echo *
echo *                Closure/Packer/YUI Compiler 压缩JS/CSS文件
echo *
echo *    生成文件名后加“-min” 如 filename.(js/css) -^> filename-min.(js/css)

REM 过滤文件后缀，只压缩 js/css文件
if "%~x1" NEQ ".js" (
    if "%~x1" NEQ ".css" (
        echo *
        echo *
        echo *    错误：请选择 .js 或 .css 文件！
        echo *
        goto End
    )
)

if "%~x1" EQU ".js" (
	goto JS
)
if "%~x1" EQU ".css" (
	goto CSS
)

:JS
set RESULT_FILE=%~n1-min%~x1
set RESULT_FILE_SIZE=%~z1

cd "%~dp1"
%~d1

"%~dp0compiler.jar" --js "%~nx1" --js_output_file "%RESULT_FILE%"
if %ERRORLEVEL% == 0 (
	echo *
	echo *
	echo *    Closure 压缩文件%~nx1到%RESULT_FILE%成功！
	echo *
	for %%a in ("%RESULT_FILE%") do (
		echo *    文件大小从 %~z1 bytes 压缩到 %%~za bytes
		set RESULT_FILE_SIZE=%%~za
	)
) else (
	echo *
	echo *
	echo *    Closure ：文件 %~nx1 中有写法错误，请仔细检查
	echo *
	goto End
)

"%~dp0packer.exe" "%RESULT_FILE%"
if %ERRORLEVEL% == 0 (
	echo *
	echo *
	echo *    Packer 压缩文件%RESULT_FILE%到%RESULT_FILE% 成功！
	echo *
	for %%a in ("%RESULT_FILE%") do (
		echo *    文件大小从 %RESULT_FILE_SIZE% bytes 压缩到 %%~za bytes
		if %RESULT_FILE_SIZE% LSS %%~za ( goto GG )
	)
	echo *
) else (
	echo *
	echo *
	echo *    Packer ：文件 %~nx1 中有写法错误，请仔细检查
	echo *
	goto End
)

goto End

:CSS

cd "%~dp1"
%~d1

set RESULT_FILE=%~n1-min%~x1
"%~dp0yuicompressor-2.4.2.jar" --charset UTF-8 "%~nx1" -o "%RESULT_FILE%"
if %ERRORLEVEL% == 0 (
	echo *
	echo *
	echo *    YUICompressor 压缩文件%~nx1到%RESULT_FILE%成功！
	echo *
	for %%a in ("%RESULT_FILE%") do (
		echo *    文件大小从 %~z1 bytes 压缩到 %%~za bytes
	)
	echo *
) else (
	echo *
	echo *
	echo *    YUICompressor ：文件 %~nx1 中有写法错误，请仔细检查
	echo *
	goto End
)
goto End

:GG
"%~dp0compiler.jar" --js "%~nx1" --js_output_file "%RESULT_FILE%"
if %ERRORLEVEL% == 0 (
	echo *
	echo *
	echo *    Closure 重新压缩文件%~nx1到%RESULT_FILE%成功！
	echo *
	for %%a in ("%RESULT_FILE%") do (
		echo *    文件大小从 %~z1 bytes 压缩到 %%~za bytes
	)
	echo *
) else (
	echo *
	echo *
	echo *    文件 %~nx1 中有写法错误，请仔细检查
	echo *
	goto End
)
goto End

:End
echo *******************************************************************************
echo.
ENDLOCAL
pause
