@echo off
cd /D "%~dp0"
@echo on
@echo Installing new files
wsl ./install_files.sh
@echo off
pause
