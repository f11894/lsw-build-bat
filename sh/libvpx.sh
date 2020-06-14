if [ ! -d libvpx ]; then
    git clone https://chromium.googlesource.com/webm/libvpx
else
    git -C libvpx pull | grep 'Already up to date.' && exit
fi
cd libvpx
if [  -d vpx_build ]; then
    rm -rf vpx_build
fi
mkdir vpx_build
cd vpx_build
../configure --enable-vp9_highbitdepth --disable-vp8-encoder --disable-vp9-encoder --prefix=/mingw32/
make clean
make -j $(nproc)
make install
