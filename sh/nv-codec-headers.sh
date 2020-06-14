if [ ! -d nv-codec-headers ]; then
    git clone --depth=1 https://github.com/FFmpeg/nv-codec-headers
else
    git -C nv-codec-headers pull | grep 'Already up to date.' && exit
fi
cd nv-codec-headers
make uninstall
make install PREFIX=/mingw32/
