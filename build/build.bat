@ECHO OFF

REM -- Dirty trick to run this script as Administrators --
set "params=%*"
cd /d "%~dp0" && ( if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs" ) && fsutil dirty query %systemdrive% 1>nul 2>nul || (  echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "cmd.exe", "/k cd ""%~sdp0"" && %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs" && "%temp%\getadmin.vbs" && exit /B )

CD /D "%~dp0"
CD ..

ECHO [DEL] Deleting bin\
@RD /S /Q "bin\"

ECHO [DEL] Deleting release\
@RD /S /Q "release\"

IF NOT EXIST "bin" MKDIR "bin"

REM ECHO Current folder is: %CD%

ECHO [RPL] Replacing default WinAPIGdi.au3 in Autoit3\Include
CALL COPY "lib\UDF\WinAPIGdi.au3" "%ProgramFiles(x86)%\AutoIt3\Include\WinAPIGdi.au3" /Y

ECHO [CMP] Compiling kyts-font-viewer.au3
CALL "%ProgramFiles(x86)%\AutoIt3\AutoIt3.exe" "%ProgramFiles(x86)%\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.au3" /in "kyts-font-viewer.au3"
ECHO [CMP] Compiling uninstall.au3
CALL "%ProgramFiles(x86)%\AutoIt3\AutoIt3.exe" "%ProgramFiles(x86)%\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.au3" /in "uninstall.au3"
ECHO [CMP] Compiling installer.au3
CALL "%ProgramFiles(x86)%\AutoIt3\AutoIt3.exe" "%ProgramFiles(x86)%\AutoIt3\SciTE\AutoIt3Wrapper\AutoIt3Wrapper.au3" /in "installer.au3"

IF NOT EXIST "release" MKDIR "release"
ECHO [CPY] Copying Installer to release...
CALL COPY "bin\kfv-installer.exe" "release\kfv-installer.exe" /Y

PAUSE