:: Simplify running BusyBox
::
:: USAGE
::   Print BusyBox help pages
::     bb --help
::     bb --version
::     bb --list[-full]
::
::   Run a built-in BusyBox function
::     bb function [function-options]
::
::   Run an external command or script from within shell
::     bb [shell-options] -c "command [command-options]"
::
::   Run a command or script found in $PATH
::     bb command [command-options]
::
::   Download the latest 32-bit or 64-bit build of BusyBox
::     bb --download win32
::     bb --download win64
::
:: SEE ALSO
::   Learn more about BusyBox following these links:
::
::   https://busybox.net/
::   https://frippery.org/busybox/
::   https://github.com/rmyorston/busybox-w32
@echo off

setlocal

set "BB_EXE="

:: Look for the instance in $PATH
for %%f in (
	busybox.exe
	busybox64.exe
) do if not defined BB_EXE if not "%%~$PATH:f" == "" set "BB_EXE=%%~$PATH:f"

:: Look for the latest instance next to this script
if not defined BB_EXE for /f "tokens=*" %%f in ( '
	dir /b /o-n "%~dp0busybox*.exe" 2^>nul
' ) do if not defined BB_EXE if exist "%~dp0%%~f" set "BB_EXE=%~dp0%%~f"

if not defined BB_EXE if /i not "%~1" == "--download" (
	2>nul echo:ERROR: BusyBox executable not found
	exit /b 1
)

:: ========================================================================

if /i "%~1" == "" (
	"%BB_EXE%" sed -n "1 { /^::/!d; } /^::/!q; s/^:: \?//p" "%~f0"
	goto :EOF
)

if /i "%~1" == "--version" (
	"%BB_EXE%" sh -c "busybox | head -2"
	goto :EOF
)

if /i "%~1" == "--download" (
	for %%p in ( "powershell.exe" ) do if "%%~$PATH:p" == "" (
		echo:%%p is required>&2
		goto :EOF
	)

	set "BB_URL="
	set "BB_DST="

	if /i "%~2" == "win32" (
		set "BB_URL=https://frippery.org/files/busybox/busybox.exe"
		set "BB_DST=%~dp0busybox.exe"
	) else if /i "%~2" == "win64" (
		set "BB_URL=https://frippery.org/files/busybox/busybox64.exe"
		set "BB_DST=%~dp0busybox64.exe"
	) else (
		echo:win32 or win64 required>&2
		goto :EOF
	)

	setlocal enabledelayedexpansion
	echo:Downloading started...
	echo:Source = !BB_URL!
	echo:Target = !BB_DST!
	endlocal

	powershell -NoLogo -NoProfile -Command "[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12;$w=New-Object System.Net.WebClient;$w.DownloadFile($Env:BB_URL,$Env:BB_DST)"

	echo:Downloading completed

	goto :EOF
)

for %%o in (
	--help
	--list
	--list-full
) do if "%~1" == "%%~o" (
	"%BB_EXE%" %%~o
	goto :EOF
)

:: ========================================================================

:: Locate the history file in the $TEMP directory
set "HISTFILE=%TEMP%\.ash_history"

:: Locate the history file next to Busybox executable
::set "HISTFILE=%~dp0.ash_history"

:: Another way to locate the history file is to set HOME dir
::for %%p in ( "%~dp0." ) do set "HOME=%%~fp"

:: ========================================================================

for /f "tokens=* delims=-" %%n in ( "%~1" ) do if not "%%~$PATH:n" == "" (
	"%BB_EXE%" sh -c "%*"
) else if "%~1" == "%%~n" (
	"%BB_EXE%" %*
) else (
	"%BB_EXE%" sh %*
)

goto :EOF

:: ========================================================================

:: EOF
