if [ ! -d l-smash ]; then
    git clone https://github.com/l-smash/l-smash.git
else
    git -C l-smash pull | grep 'Already up to date.' && exit
fi
cd l-smash
./configure --prefix=/mingw32/
make clean
make -j $(nproc)
make install
