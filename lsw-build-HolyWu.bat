set author=HolyWu
set MSYSTEM=MINGW32
if not exist .\msys64 (
    curl -L -O https://github.com/msys2/msys2-installer/releases/download/nightly-x86_64/msys2-base-x86_64-latest.sfx.exe
    .\msys2-base-x86_64-latest.sfx.exe x -y -o"."
    del .\msys2-base-x86_64-latest.sfx.exe
)
.\msys64\usr\bin\bash -lc "pacman -Syu --noconfirm"
.\msys64\usr\bin\bash -lc "pacman -Su --noconfirm" 
.\msys64\usr\bin\bash -lc "pacman -S --needed mingw-w64-i686-cmake mingw-w64-i686-gcc mingw-w64-i686-nasm mingw-w64-i686-yasm mingw-w64-i686-ninja mingw-w64-i686-pkg-config mingw-w64-i686-meson git base-devel autotools --noconfirm"
copy /y .\sh\*sh ".\msys64\home\%USERNAME%"
.\msys64\usr\bin\bash -lc "sh -x mfx_dispatch.sh"
.\msys64\usr\bin\bash -lc "sh -x nv-codec-headers.sh"
.\msys64\usr\bin\bash -lc "sh -x libvpx.sh"
.\msys64\usr\bin\bash -lc "sh -x dav1d.sh"
.\msys64\usr\bin\bash -lc "sh -x ffmpeg.sh '--disable-decoder=vp8 --disable-decoder=vp9 --enable-libdav1d --enable-libvpx'"
.\msys64\usr\bin\bash -lc "sh -x l-smash.sh"
.\msys64\usr\bin\bash -lc "sh -x L-SMASH-Works.sh '%author%'"
for /f "delims=" %%i in ('.\msys64\usr\bin\bash -lc "git -C L-SMASH-Works-%author% log --oneline --no-merges | wc -l"') do set "revision=%%i"
".\msys64\home\%USERNAME%\l-smash\cli\muxer.exe" --version 2>&1 | find "L-SMASH isom/mov multiplexer" >ver.txt
for /f "delims=" %%i in ('.\msys64\usr\bin\bash -lc "git -C mfx_dispatch log --pretty=%%h -1"') do echo mfx_dispatch %%~i>>ver.txt
for /f "delims=" %%i in ('.\msys64\usr\bin\bash -lc "git -C nv-codec-headers log --pretty=%%h -1"') do echo nv-codec-headers %%~i>>ver.txt
for /f "delims=" %%i in ('.\msys64\usr\bin\bash -lc "git -C libvpx log --pretty=%%h -1"') do echo libvpx %%~i>>ver.txt
for /f "delims=" %%i in ('.\msys64\usr\bin\bash -lc "git -C dav1d log --pretty=%%h -1"') do echo dav1d %%~i>>ver.txt
more <".\msys64\home\%USERNAME%\ffmpeg_ver.txt">>ver.txt
PowerShell Compress-Archive -Force -Path "ver.txt,.\msys64\home\%USERNAME%\L-SMASH-Works-%author%\AviUtl\lwinput.aui,.\msys64\home\%USERNAME%\L-SMASH-Works-%author%\AviUtl\lwdumper.auf,.\msys64\home\%USERNAME%\L-SMASH-Works-%author%\AviUtl\lwmuxer.auf,.\msys64\home\%USERNAME%\L-SMASH-Works-%author%\AviUtl\lwcolor.auc" -DestinationPath L-SMASH-Works-%author%-r%revision%.zip 
