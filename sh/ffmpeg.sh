FFmpeg_ver=4.2.2
FFmpeg_patch_ver=4.2.2
FFmpeg_patch=https://gist.github.com/maki-rxrz/5a7a2c789e4369fa34853b5358fb8a29/raw/8f3016b66a025588b9d361838ed000e8dae30e28/ffmpeg-4.2.2-allpatches.diff
if [ ! -d ffmpeg-${FFmpeg_ver} ]; then
    git clone --depth=1 -b n${FFmpeg_ver} git://source.ffmpeg.org/ffmpeg.git ffmpeg-${FFmpeg_ver}
    pushd ffmpeg-${FFmpeg_ver}
    curl -O -L ${FFmpeg_patch}
    patch -p1 <ffmpeg-${FFmpeg_patch_ver}-allpatches.diff
    popd
fi
cd ffmpeg-${FFmpeg_ver}
./configure --target-os=mingw32 --prefix=/mingw32/ --disable-shared --disable-debug --disable-encoders --disable-doc $1 --enable-libmfx --enable-static --enable-gpl --enable-version3 --enable-runtime-cpudetect --enable-avisynth
make clean
make uninstall
make -j $(nproc)
make install
echo "FFmpeg ver. ${FFmpeg_ver} $(git log --pretty=%h -1)">../ffmpeg_ver.txt
