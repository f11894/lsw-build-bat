set MSYSTEM=MINGW32
set FFmpeg_ver=4.2.2
set FFmpeg_patch=https://gist.github.com/maki-rxrz/5a7a2c789e4369fa34853b5358fb8a29/raw/8f3016b66a025588b9d361838ed000e8dae30e28/ffmpeg-4.2.2-allpatches.diff
curl -o 7z.msi -L "https://ja.osdn.net/frs/redir.php?m=ymu&f=sevenzip%%2F70468%%2F7z1806.msi
mkdir 7-Zip
msiexec /a 7z.msi targetdir="%~dp07-Zip" /qn
curl -O http://repo.msys2.org/distrib/msys2-x86_64-latest.tar.xz
.\7-Zip\Files\7-Zip\7z.exe x -so msys2-x86_64-latest.tar.xz | .\7-Zip\Files\7-Zip\7z.exe x -aoa -si -ttar
.\msys64\usr\bin\bash -lc "pacman -Syu --noconfirm"
.\msys64\usr\bin\bash -lc "pacman -Su --noconfirm" 
.\msys64\usr\bin\bash -lc "pacman -S mingw-w64-i686-cmake mingw-w64-i686-gcc mingw-w64-i686-nasm mingw-w64-i686-yasm mingw-w64-i686-ninja mingw-w64-i686-pkg-config mingw-w64-i686-meson git base-devel --noconfirm" 
.\msys64\usr\bin\bash -lc "git clone --depth=1 https://chromium.googlesource.com/webm/libvpx && mkdir vpxbuild && cd vpxbuild && ../libvpx/configure --enable-vp9_highbitdepth --disable-vp8-encoder --disable-vp9-encoder --prefix=/mingw32/ && make -j %NUMBER_OF_PROCESSORS% && make install"
.\msys64\usr\bin\bash -lc "git clone --depth=1 https://github.com/lu-zero/mfx_dispatch && cd mfx_dispatch && autoreconf -i && ./configure --prefix=/mingw32/ && make -j %NUMBER_OF_PROCESSORS% install"
.\msys64\usr\bin\bash -lc "git clone --depth=1 https://github.com/FFmpeg/nv-codec-headers && cd nv-codec-headers && make install PREFIX=/mingw32/"
.\msys64\usr\bin\bash -lc "git clone --depth=1 https://code.videolan.org/videolan/dav1d && mkdir dav1d_build && cd dav1d_build && meson ../dav1d --buildtype release --default-library static && ninja && ninja install"
.\msys64\usr\bin\bash -lc "git clone --depth=1 -b n%FFmpeg_ver% git://source.ffmpeg.org/ffmpeg.git ffmpeg-%FFmpeg_ver% && curl -O -L %FFmpeg_patch% && patch -p0 <ffmpeg-%FFmpeg_ver%-allpatches.diff && cd ffmpeg-%FFmpeg_ver% && ./configure --target-os=mingw32 --disable-shared --disable-debug --disable-encoders --disable-decoder=vp9 --disable-doc --enable-libdav1d --enable-libvpx --enable-libmfx --enable-static --enable-gpl --enable-version3 --enable-runtime-cpudetect --enable-avisynth && make -j %NUMBER_OF_PROCESSORS% && make install"
.\msys64\usr\bin\bash -lc "git clone https://github.com/l-smash/l-smash.git && cd l-smash && ./configure && make -j %NUMBER_OF_PROCESSORS% && make install"
.\msys64\usr\bin\bash -lc "git clone https://github.com/HolyWu/L-SMASH-Works && cd L-SMASH-Works/AviUtl && PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig:/mingw32/lib/pkgconfig && ./configure --prefix=x86 --extra-libs='-static -static-libgcc -static-libstdc++' && make"
for /f "delims=" %%i in ('.\msys64\usr\bin\bash -lc "cd L-SMASH-Works && git log --oneline --no-merges | wc -l"') do set "revision=%%i"
".\msys64\home\%USERNAME%\l-smash\cli\muxer.exe" --version 2>&1 | find "L-SMASH isom/mov multiplexer" >ver.txt
for /f "tokens=2" %%i in ('findstr /R /C:"^[0-9a-f][0-9a-f]* [0-9a-f][0-9a-f]*" ".\msys64\home\%USERNAME%\libvpx\.git\logs\HEAD"') do echo libvpx ver %%~i >>ver.txt
for /f "tokens=2" %%i in ('findstr /R /C:"^[0-9a-f][0-9a-f]* [0-9a-f][0-9a-f]*" ".\msys64\home\%USERNAME%\dav1d\.git\logs\HEAD"') do echo dav1d ver %%~i >>ver.txt
for /f "tokens=2" %%i in ('findstr /R /C:"^[0-9a-f][0-9a-f]* [0-9a-f][0-9a-f]*" ".\msys64\home\%USERNAME%\ffmpeg-%FFmpeg_ver%\.git\logs\HEAD"') do echo FFmpeg ver %FFmpeg_ver% %%~i >>ver.txt
.\7-Zip\Files\7-Zip\7z.exe a L-SMASH-Works-HolyWu-r%revision%.zip ver.txt .\msys64\home\%USERNAME%\L-SMASH-Works\AviUtl\lwinput.aui .\msys64\home\%USERNAME%\L-SMASH-Works\AviUtl\lwdumper.auf .\msys64\home\%USERNAME%\L-SMASH-Works\AviUtl\lwmuxer.auf .\msys64\home\%USERNAME%\L-SMASH-Works\AviUtl\lwcolor.auc
