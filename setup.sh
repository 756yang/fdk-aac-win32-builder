#! /bin/sh

if [ -z "$MINGW_CHOST" ]; then
    echo "Setup failed because maybe you did not use MinGW terminal instead MSYS terminal."
    echo "See README.md how to use instructions."
    exit
fi

rm -rf artifacts
mkdir artifacts
cd artifacts

wget https://github.com/kekyo/fdk-aac-win32-builder/releases/download/distributes/fdk-aac-0.1.6.tar.gz
#wget https://github.com/kekyo/fdk-aac-win32-builder/releases/download/distributes/fdk-aac-2.0.2.tar.gz
wget -O fdk-aac-2.0.3.tar.gz https://github.com/mstorsjo/fdk-aac/archive/refs/tags/v2.0.3.tar.gz
#wget https://github.com/kekyo/fdk-aac-win32-builder/releases/download/distributes/fdkaac-1.0.2.tar.gz
#wget https://github.com/kekyo/fdk-aac-win32-builder/releases/download/distributes/fdkaac-1.0.3.tar.gz
wget -O fdkaac-1.0.6.tar.gz https://github.com/nu774/fdkaac/archive/refs/tags/v1.0.6.tar.gz

cd ..
