@echo off & setlocal enabledelayedexpansion

REM Path to the configuration file
set CONFIG_FILE=config.txt

REM Check if the config file exists
if not exist "%CONFIG_FILE%" (
    echo Error: Configuration file "%CONFIG_FILE%" not found!
    exit /b 1
)

REM Read the config file line by line
for /f "usebackq tokens=1* delims==" %%A in ("%CONFIG_FILE%") do (
    set "%%A=%%B"
)

REM Validate required variables
if not defined OUTPUT_DIR (
    echo Error: OUTPUT_DIR is not defined in "%CONFIG_FILE%"!
    exit /b 1
)
if not defined YTDLP_PATH (
    echo Error: YTDLP_PATH is not defined in "%CONFIG_FILE%"!
    exit /b 1
)
if not defined FFMPEG_PATH (
    echo Error: FFMPEG_PATH is not defined in "%CONFIG_FILE%"!
    exit /b 1
)

REM Debugging - Display loaded variables
echo OUTPUT_DIR=!OUTPUT_DIR!
echo YTDLP_PATH=!YTDLP_PATH!
echo FFMPEG_PATH=!FFMPEG_PATH!

:start
echo ---------------------------------
REM Prompts the user to choose between downloading video, audio, or quitting.
echo Do you want to download video, audio, or quit?
echo [1] YouTube Video
echo [2] YouTube Audio
echo [3] Twitch Video
echo [4] Quit
set /p TYPE=Enter your choice: 
if "%TYPE%" == "1" goto video
if "%TYPE%" == "2" goto audio
if "%TYPE%" == "3" goto twitch
if "%TYPE%" == "4" goto eof
echo Invalid input. Please enter 1, 2, 3, or 4.
goto start

:video
REM Prompt user for video link
set /p "LINK=Enter the YouTube video link: "

REM Replace all ampersands (&) with %%26 (URL encoding for &)
set "LINK=!LINK:&=%%26!"

REM Find the position of the first ampersand (&) and truncate
for /f "tokens=1 delims=&" %%A in ("!LINK!") do (
    set "CLEAN_LINK=%%A"
)

REM Display the cleaned link
echo Cleaned Link: !CLEAN_LINK!
pause

REM Download the highest quality video and audio compatible with Premiere Pro
%YTDLP_PATH%  -f "bv*[vcodec^=avc]+ba[ext=m4a]/b[ext=mp4]/b" -o "%OUTPUT_DIR%\%%(title)s.%%(ext)s" "%CLEAN_LINK%" --no-mtime --restrict-filenames
if errorlevel 1 (
    echo ERROR: Unable to download the video in a compatible format. Please check the video link or formats.
    goto end
)

REM Get the most recent file in the directory
for /f "delims=" %%F in ('dir "%OUTPUT_DIR%\*.mp4" /b /o-d /t:w') do (
    set "LAST_DOWNLOADED_FILE=%%F"
    goto :done
)
:done

REM Combine OUTPUT_DIR with the file name to get the full path
set "FULL_FILE_PATH=%OUTPUT_DIR%\!LAST_DOWNLOADED_FILE!"

REM Display the full file path
echo Full File Path: "!FULL_FILE_PATH!"

pause

REM Refresh metadata using ffmpeg
echo Optimizing metadata for file: %FULL_FILE_PATH%
%FFMPEG_PATH% -i "%FULL_FILE_PATH%" -c:v copy -c:a copy -movflags +faststart "%FULL_FILE_PATH%.tmp.mp4"
if errorlevel 1 (
    echo ERROR: Failed to optimize metadata. Keeping the original file.
    goto end
)

REM Replace the original file with the optimized one
move /y "%FULL_FILE_PATH%.tmp.mp4" "%FULL_FILE_PATH%" >nul
echo Metadata optimization successful. File updated.

echo Video with audio download complete. File saved to %OUTPUT_DIR%.
goto start

:audio
REM Prompt user for video link
set /p "LINK=Enter the YouTubevideo link: "

REM Replace all ampersands (&) with %%26 (URL encoding for &)
set "LINK=!LINK:&=%%26!"

REM Find the position of the first ampersand (&) and truncate
for /f "tokens=1 delims=&" %%A in ("!LINK!") do (
    set "CLEAN_LINK=%%A"
)

REM Display the cleaned link
echo Cleaned Link: !CLEAN_LINK!
pause

REM Download the highest quality audio
%YTDLP_PATH% -f bestaudio --extract-audio --audio-format mp3 -o "%OUTPUT_DIR%\%%(title)s.%%(ext)s" "%CLEAN_LINK%"
if errorlevel 1 (
    echo ERROR: Unable to download the audio in a compatible format. Please check the video link or formats.
    goto end
)

echo Audio download complete. File saved to %OUTPUT_DIR%.
goto start

:twitch
REM Prompt user for video link
set /p "LINK=Enter the Twitch VOD link: "

REM Replace all ampersands (&) with %%26 (URL encoding for &)
set "LINK=!LINK:&=%%26!"

REM Find the position of the first ampersand (&) and truncate
for /f "tokens=1 delims=&" %%A in ("!LINK!") do (
    set "CLEAN_LINK=%%A"
)

REM Display the cleaned link
echo Cleaned Link: !CLEAN_LINK!
pause

REM Download the highest quality video and audio compatible with Premiere Pro
%YTDLP_PATH%  -f "bv*[vcodec^=avc]+ba[ext=m4a]/b[ext=mp4]/b" -o "%OUTPUT_DIR%\%%(title)s.%%(ext)s" "%CLEAN_LINK%" --no-mtime --restrict-filenames
if errorlevel 1 (
    echo ERROR: Unable to download the video in a compatible format. Please check the video link or formats.
    goto end
)

REM Get the most recent file in the directory
for /f "delims=" %%F in ('dir "%OUTPUT_DIR%\*.mp4" /b /o-d /t:w') do (
    set "LAST_DOWNLOADED_FILE=%%F"
    goto :done
)
:done

REM Combine OUTPUT_DIR with the file name to get the full path
set "FULL_FILE_PATH=%OUTPUT_DIR%\!LAST_DOWNLOADED_FILE!"

REM Display the full file path
echo Full File Path: "!FULL_FILE_PATH!"

pause

REM Refresh metadata using ffmpeg
echo Optimizing metadata for file: %FULL_FILE_PATH%
%FFMPEG_PATH% -i "%FULL_FILE_PATH%" -c:v copy -c:a copy -movflags +faststart "%FULL_FILE_PATH%.tmp.mp4"
if errorlevel 1 (
    echo ERROR: Failed to optimize metadata. Keeping the original file.
    goto end
)

REM Replace the original file with the optimized one
move /y "%FULL_FILE_PATH%.tmp.mp4" "%FULL_FILE_PATH%" >nul
echo Metadata optimization successful. File updated.

echo Video with audio download complete. File saved to %OUTPUT_DIR%.
goto start

:end
echo Done! Output is located in %OUTPUT_DIR%.
pause