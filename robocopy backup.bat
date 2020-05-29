@ECHO off
rem ============================================================================
rem This bat file executes a backup to a specified location using robocopy.
rem Files that are deleted in the source will NOT be deleted in the 
rem destination!
rem The output will be saved in a timestamped log file.
rem For detailed info on robocopy visit:
rem https://technet.microsoft.com/en-GB/library/cc733145.aspx
rem 
rem <Source>       File path of the source folder
rem <Destination>  File path of the destination folder
rem 
rem File paths with white spaces need to go between quotation marks,
rem and in general paths must not end with a trailing backslash.
rem 
rem If any copying process fails the console window will stay open and 
rem display an error message.
rem
rem (c) 2020 Sebastian Steiner
rem ============================================================================

SETLOCAL

rem Enter the path where the logfile should go here:
SET "LOGPATH=some path"

rem Create log file name
SET "SAVESTAMP=%DATE:/=-%@%TIME::=-%"
SET "LOGFILENAME="%LOGPATH%\%SAVESTAMP: =%.txt""

rem Initialise error flag to zero
SET ERRORFLAG=0

rem This block will be displayed before the copying starts and inform the user to not close the window
@ECHO #
@ECHO ######################################################################
@ECHO ######################################################################
@ECHO #  _                   _                                             #
@ECHO # |_)   _   |_    _   /    _   ._         |_    _.   _  |        ._  #
@ECHO # | \  (_)  |_)  (_)  \_  (_)  |_)  \/    |_)  (_|  (_  |<  |_|  |_) #
@ECHO #                              |    /                            |   #
@ECHO #                                                                    #
@ECHO #                    RoboCopy backup script v0.2                     #
@ECHO #                      © 2020 Sebastian Steiner                      #
@ECHO #                                                                    #
@ECHO #   RoboCopy is scanning the files in the destination, this might    #
@ECHO #         take a moment. Do not close the window! The window         #
@ECHO #           will close itself once the backup is finished.           #
@ECHO #                                                                    #
@ECHO ######################################################################
@ECHO ######################################################################
@ECHO #

rem This is the actual robocopy command.Replace <Source> and <Destination> with the file paths.
rem You can copy those lines (including the if statement) as often as you need. 
robocopy <Source> <Destination> /e /xo /np /z /r:10 /w:1 /mt:4 /log:%LOGFILENAME% /tee
if errorlevel 8 (
	SET ERRORFLAG=1
)

rem This is the error report. If any of the above copying actions fails, 
rem it will display the error message and prevent the window from closing.
if %ERRORFLAG% EQU 1 (
    @ECHO #
	@ECHO ###########################################################
	@ECHO ###########################################################
	@ECHO ##                                                       ##
	@ECHO ##                      ERROR!                           ##
	@ECHO ##                                                       ##
	@ECHO ##  Something went wrong with the backup, please check!  ##
	@ECHO ##                                                       ##
	@ECHO ##    Press any key to close this window. The script     ##
	@ECHO ##     won't run again until this window is closed.      ##
	@ECHO ##                                                       ##
	@ECHO ###########################################################
	@ECHO ###########################################################
	@ECHO #
	pause
)
