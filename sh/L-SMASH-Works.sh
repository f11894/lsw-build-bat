author=$1
if [ ! -d L-SMASH-Works-${author} ]; then
    git clone https://github.com/${author}/L-SMASH-Works L-SMASH-Works-${author}
else
    git -C L-SMASH-Works-${author} pull
fi
cd L-SMASH-Works-${author}/AviUtl
PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/mingw32/lib/pkgconfig
./configure --extra-libs='-static -static-libgcc -static-libstdc++'
make clean
make -j $(nproc)
