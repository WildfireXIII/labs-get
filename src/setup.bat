@echo off
rem -------------------------------------------
rem		Labs-Get setup script v0.1.0-w
rem		Date Created: 12/19/2015
rem		Date Edited: 12/19/2015
rem		Copyright � 2015 Digital Warrior Labs
rem		Author: Nathan Martindale (WildfireXIII)
rem		Description: Setup script for the windows labs-get package manager.
rem			Run this on first-time use, or if files/env variables are missing
rem -------------------------------------------

rem PREREQ: MUST HAVE GIT INSTALLED in order to run this setup

rem check existence of environment variables
echo Checking environment variables...
:ENVCHECK
	if "%BIN_DIR%" == "" goto CREATEBIN
	if "%LIB_DIR%" == "" goto CREATELIB
	if "%DATA_DIR%" == "" goto CREATEDATA
	if "%PKG_DIR%" == "" goto CREATEPKG
	if "%CONF_DIR%" == "" goto CREATECONF
	echo Environment variables ready
	goto PATHCHECK

rem make sure tht the BIN_DIR exists within the path variable
:PATHCHECK
	echo Checking PATH...
	rem insert clean runnable to bin folder and see if possible to run
	echo echo Bin directory is in path > %BIN_DIR%\path_check.bat
	path_check.bat 2> NUL rem hides error if not found
	if errorlevel 1 goto ADDTOPATH

	echo Copying primary program files...
	goto COPYPRGM
	
:COPYPRGM
	copy labs-get.ps1 %BIN_DIR%
	echo Program files located appropriately
	echo Setting up data files...
	goto SETDATAFILES

:SETDATAFILES
	if not exist %DATA_DIR%\labs-get (md %DATA_DIR%\labs-get)
	if not exist %PKG_DIR%\labs-get-list goto GETGITLIST
	if not exist %DATA_DIR%\labs-get\installed.dat (echo name,packagename,url,tags,dependencies > %DATA_DIR%\labs-get\installed.dat)
	if not exist (%DATA_DIR%\labs-get\default-tags.dat goto GETTAGS
	echo All data files properly installed
	goto END

:SETEXECUTIONPOLICY
	echo Labs-Get is a powershell script that requires RemoteSigned execution policy in order to run
	set /p allow=Allow this script to change your powershell execution policy? (y/[n]):
	if /I "%allow%" neq "y" goto END
	>nul powershell.exe -executionpolicy unrestricted -command set-executionpolicy remotesigned
	goto END


rem ------functions------

:ADDTOPATH
	echo Bin directory wasn't found in the PATH variable
	goto PATHCHECK

:GETTAGS
	set /p tags=Enter default package tags to filter (can be changed later in the default-tags.dat file in the data directory):
	echo %tags% > %DATA_DIR%\labs-get\default-tags.dat
	goto SETDATAFILES

:GETGITLIST
	echo Retrieving list git repo...
	set /p giturl=Enter git url for package list:
	git clone %giturl% %PKG_DIR%\labs-get-list
	echo List data git repo installed
	goto SETDATAFILES

:CREATEBIN
	echo No bin path defined!
	set /p bin=Enter path to bin folder:
	setx BIN_DIR %bin%
	goto ENVCHECK

:CREATELIB
	echo No lib path defined!
	set /p lib=Enter path to lib folder:
	setx LIB_DIR %lib%
	goto ENVCHECK

:CREATEDATA
	echo No data path defined!
	set /p data=Enter path to data folder:
	setx DATA_DIR %data%
	goto ENVCHECK
	
:CREATEPKG
	echo No pkg path defined!
	set /p pkg=Enter path to pkg folder:
	setx PKG_DIR %pkg%
	goto ENVCHECK
	
:CREATECONF
	echo No conf path defined!
	set /p conf=Enter path to conf folder:
	setx CONF_DIR %conf%
	goto ENVCHECK
	
:END
	echo Setup complete!
