# video_downloader
Uses `yt-dlp` and `FFmpeg` to create a simple CLI application for downloading YouTube videos, YouTube audio, and Twitch videos.

## Getting Started

1. Download the latest version of `video_downloader.bat` and `config.txt` from this repo.
2. Download `yt-dlp.exe` from this link: https://github.com/yt-dlp/yt-dlp/wiki/Installation. Assuming you're using Windows, click on the "Windows X64" button. 
4. Move `yt-dlp.exe` to wherever you want.
5. In `config.txt`, change `YTDLP_PATH` to the filepath of `yt-dlp.exe`. For example, mine is: `YTDLP_PATH=G:\tools\youtube_downloader\yt-dlp.exe`
6. Download `ffmpeg.exe` from this link: https://www.gyan.dev/ffmpeg/builds/. Assuming you're using Windows, scroll down and click on the `ffmpeg-release-essentials.zip` button. (You can read more about FFmpeg here: https://www.ffmpeg.org/download.html#build-windows)
7. Extract the entire folder to wherever you want.
8. In `config.txt`, change `FFMPEG_PATH` to the filepath of `ffmpeg.exe`. For example, mine is: `FFMPEG_PATH=G:\tools\ffmpeg\bin\ffmpeg.exe`
9. In `config.txt`, change `OUTPUT_DIR` to wherever you want files to be downloaded. For example, mine is: `OUTPUT_DIR=G:\downloaded_vids`
10. You should now be ready to run the script. Simply open `video_downloader.bat`, and then follow the on-screen instructions.

Feel free to message me on Twitter @griffinbeels if anything is wrong. Hope this helps you download stuff more quickly and safely :^D
