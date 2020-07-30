if [ ! -d AviSynthPlus ]; then
    git clone https://github.com/AviSynth/AviSynthPlus
else
    git -C AviSynthPlus pull | grep 'Already up to date.' && exit
fi
cd AviSynthPlus
if [  -d avisynthplus_build ]; then
    rm -rf avisynthplus_build
fi
mkdir avisynthplus_build
cd avisynthplus_build
cmake ../ -G 'MSYS Makefiles' -DCMAKE_INSTALL_PREFIX=/mingw32/ -DHEADERS_ONLY:bool=on
make uninstall
make install
