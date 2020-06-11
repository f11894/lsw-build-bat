set MSYSTEM=MINGW32
set FFmpeg_ver=4.2.2
set FFmpeg_patch_ver=4.2.2
set FFmpeg_patch=https://gist.github.com/maki-rxrz/5a7a2c789e4369fa34853b5358fb8a29/raw/8f3016b66a025588b9d361838ed000e8dae30e28/ffmpeg-4.2.2-allpatches.diff
curl -L -O https://github.com/msys2/msys2-installer/releases/download/nightly-x86_64/msys2-base-x86_64-latest.sfx.exe
.\msys2-base-x86_64-latest.sfx.exe x -y -o"."
.\msys64\usr\bin\bash -lc "pacman -Syu --noconfirm"
.\msys64\usr\bin\bash -lc "pacman -Su --noconfirm" 
.\msys64\usr\bin\bash -lc "pacman -S mingw-w64-i686-cmake mingw-w64-i686-gcc mingw-w64-i686-nasm mingw-w64-i686-yasm mingw-w64-i686-ninja mingw-w64-i686-pkg-config mingw-w64-i686-meson git base-devel --noconfirm"
.\msys64\usr\bin\bash -lc "git clone --depth=1 https://github.com/lu-zero/mfx_dispatch && cd mfx_dispatch && autoreconf -i && ./configure --prefix=/mingw32/ && make -j %NUMBER_OF_PROCESSORS% install"
.\msys64\usr\bin\bash -lc "git clone --depth=1 https://github.com/FFmpeg/nv-codec-headers && cd nv-codec-headers && make install PREFIX=/mingw32/"
.\msys64\usr\bin\bash -lc "git clone --depth=1 https://aomedia.googlesource.com/aom && cd aom && mkdir aom_build && cd aom_build && cmake ../ -G Ninja -DFORCE_HIGHBITDEPTH_DECODING=0 -DCONFIG_AV1_ENCODER=0 -DCMAKE_INSTALL_PREFIX=/mingw32/ -DCMAKE_BUILD_TYPE=Release && ninja -j %NUMBER_OF_PROCESSORS% && ninja install"
.\msys64\usr\bin\bash -lc "git clone --depth=1 -b n%FFmpeg_ver% git://source.ffmpeg.org/ffmpeg.git ffmpeg-%FFmpeg_patch_ver% && curl -O -L %FFmpeg_patch% && patch -p0 <ffmpeg-%FFmpeg_patch_ver%-allpatches.diff && cd ffmpeg-%FFmpeg_patch_ver% && ./configure --target-os=mingw32 --disable-shared --disable-debug --disable-encoders --disable-doc --enable-avresample --enable-libaom --enable-libmfx --enable-static --enable-gpl --enable-version3 --enable-runtime-cpudetect --enable-avisynth && make -j %NUMBER_OF_PROCESSORS% && make install"
.\msys64\usr\bin\bash -lc "git clone https://github.com/l-smash/l-smash.git && cd l-smash && ./configure && make -j %NUMBER_OF_PROCESSORS% && make install"
.\msys64\usr\bin\bash -lc "git clone https://github.com/VFR-maniac/L-SMASH-Works && cd L-SMASH-Works/AviUtl && PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/local/lib/pkgconfig:/mingw32/lib/pkgconfig && ./configure --prefix=x86 --extra-libs='-static -static-libgcc -static-libstdc++' && make"
for /f "delims=" %%i in ('.\msys64\usr\bin\bash -lc "cd L-SMASH-Works && git log --oneline --no-merges | wc -l"') do set "revision=%%i"
".\msys64\home\%USERNAME%\l-smash\cli\muxer.exe" --version 2>&1 | find "L-SMASH isom/mov multiplexer" >ver.txt
for /f "delims=" %%i in ('.\msys64\usr\bin\bash -lc "git -C aom log --pretty=%%h -1"') do echo libaom ver %%~i>>ver.txt
for /f "delims=" %%i in ('.\msys64\usr\bin\bash -lc "git -C ffmpeg-%FFmpeg_patch_ver% log --pretty=%%h -1"') do echo FFmpeg ver %FFmpeg_ver% %%~i>>ver.txt
PowerShell Compress-Archive -Path "ver.txt,.\msys64\home\%USERNAME%\L-SMASH-Works\AviUtl\lwinput.aui,.\msys64\home\%USERNAME%\L-SMASH-Works\AviUtl\lwdumper.auf,.\msys64\home\%USERNAME%\L-SMASH-Works\AviUtl\lwmuxer.auf,.\msys64\home\%USERNAME%\L-SMASH-Works\AviUtl\lwcolor.auc" -DestinationPath L-SMASH-Works-VFR-maniac-r%revision%.zip 
