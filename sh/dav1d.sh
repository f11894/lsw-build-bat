if [ ! -d aom ]; then
    git clone https://code.videolan.org/videolan/dav1d
else
    git -C dav1d pull | grep 'Already up to date.' && exit
fi
cd dav1d
if [  -d dav1d_build ]; then
    rm -rf dav1d_build
fi
mkdir dav1d_build
cd dav1d_build
meson ../ --buildtype release --default-library static
ninja clean
ninja -j $(nproc)
ninja install
