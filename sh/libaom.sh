if [ ! -d aom ]; then
    git clone https://aomedia.googlesource.com/aom
else
    git -C aom pull | grep 'Already up to date.' && exit
fi
cd aom
if [  -d aom_build ]; then
    rm -rf aom_build
fi
mkdir aom_build
cd aom_build
cmake ../ -G Ninja -DFORCE_HIGHBITDEPTH_DECODING=0 -DCONFIG_AV1_ENCODER=0 -DCMAKE_INSTALL_PREFIX=/mingw32/ -DCMAKE_BUILD_TYPE=Release
ninja clean
ninja -j $(nproc)
ninja install
