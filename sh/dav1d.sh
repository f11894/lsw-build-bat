if [ ! -d dav1d ]; then
    git clone https://code.videolan.org/videolan/dav1d
else
    git -C dav1d checkout -f master
    git -C dav1d pull
fi
cd dav1d
git checkout -f 0.9.2
if [  -d dav1d_build ]; then
    rm -rf dav1d_build
fi
mkdir dav1d_build
cd dav1d_build
meson ../ --buildtype release --default-library static --prefix=/mingw32/
ninja clean
ninja -j $(nproc)
ninja install
