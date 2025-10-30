#! /bin/sh
#Print commands and their arguments as they are executed.
set -x

###################################
# Compiler optimization flags:

# Platform native (not include AVX-512, it's standard options)
# Remove "-flto" to avoid Wstringop-overflow warning for fdkaac
#CFLAGS="-O3 -march=native"

# AVX-512
#CFLAGS="-O3 -march=native -mavx512f -mavx512dq -mavx512er -mavx512cd -mavx512bw -mavx512pf -mavx512vl -mavx512ifma -mavx512vbmi"

# For debugging/reference usage
#CFLAGS="-O0"

###################################

NPB=`cat /proc/cpuinfo |grep "processor"|wc -l`

if [ -z "$MINGW_CHOST" ]; then
    echo "Building failed, because maybe you did not use MinGW terminal instead MSYS terminal."
    echo "See README.md how to use instructions."
    exit
fi

if [ "${MINGW_CHOST:0:6}" == "x86_64" ]; then
    CFLAGS="-O3 -march=native -mcmodel=small -Wl,--gc-sections,--as-needed"
else
    CFLAGS="-O3 -m32 -mfpmath=sse -march=pentium4 -Wl,--gc-sections,--as-needed"
fi

rm -rf stage
mkdir stage
cd stage

rm -rf $MINGW_CHOST
mkdir $MINGW_CHOST
cd $MINGW_CHOST

tar -zxf ../../artifacts/fdk-aac-0.1.6.tar.gz
tar -zxf ../../artifacts/fdk-aac-2.0.3.tar.gz
tar -zxf ../../artifacts/fdkaac-1.0.6.tar.gz

cd fdk-aac-0.1.6
#Temporary add "-flto" option here, should be replaced by interactive compile switches in the future
CC="gcc -pipe -static-libgcc -flto" CXX="g++ -pipe -static-libgcc -flto" ./configure --prefix=$(pwd)$MINGW_PREFIX/ CFLAGS="${CFLAGS}"
make -j$NPB
make install
cd ..

cd fdk-aac-2.0.3
autoreconf -i
#Temporary add "-flto" option here, should be replaced by interactive compile switches in the future
FDK_PKG_PATH="$(pwd)$MINGW_PREFIX/lib/pkgconfig:$PKG_CONFIG_PATH"
CC="gcc -pipe -static-libgcc -flto" CXX="g++ -pipe -static-libgcc -flto" ./configure --prefix=$(pwd)$MINGW_PREFIX/ CFLAGS="${CFLAGS}"
make -j$NPB
make install
cd ..

cd fdkaac-1.0.6
autoreconf -i
PKG_CONFIG_PATH="$FDK_PKG_PATH" CC="gcc -pipe -static-libgcc" CXX="g++ -pipe -static-libgcc" ./configure --prefix=$(pwd)$MINGW_PREFIX/ CFLAGS="${CFLAGS} -s -static"
make -j$NPB
make install
cd ..

cd ../..

rm -rf artifacts/$MINGW_CHOST
mkdir artifacts/$MINGW_CHOST
cd artifacts/$MINGW_CHOST

cp ../../stage/$MINGW_CHOST/fdk-aac-0.1.6/.libs/libfdk-aac.a libfdk-aac-1.a
cp ../../stage/$MINGW_CHOST/fdk-aac-0.1.6/.libs/libfdk-aac.dll.a libfdk-aac-1.dll.a
cp ../../stage/$MINGW_CHOST/fdk-aac-0.1.6/.libs/libfdk-aac-1.dll .

cp ../../stage/$MINGW_CHOST/fdk-aac-2.0.3/.libs/libfdk-aac.a libfdk-aac-2.a
cp ../../stage/$MINGW_CHOST/fdk-aac-2.0.3/.libs/libfdk-aac.dll.a libfdk-aac-2.dll.a
cp ../../stage/$MINGW_CHOST/fdk-aac-2.0.3/.libs/libfdk-aac-2.dll .

cp ../../stage/$MINGW_CHOST/fdkaac-1.0.6/fdkaac.exe .
