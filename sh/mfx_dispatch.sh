if [ ! -d mfx_dispatch ]; then
    git clone --depth=1 https://github.com/lu-zero/mfx_dispatch
else
    git -C mfx_dispatch pull | grep 'Already up to date.' && exit
fi
cd mfx_dispatch
autoreconf -i
./configure --prefix=/mingw32/
make clean
make -j $(nproc) install
