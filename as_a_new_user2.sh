
source ~/.bashrc

cd $LFS/sources

# 5.4
bzcat binutils-2.27.tar.bz2 | tar x
mv binutils-2.27/ binutils-2.27-proto1/
cd binutils-2.27-proto1/
mkdir -v build
cd build
../configure \
    --prefix=/tools \
    --with-sysroot=$LFS \
    --with-lib-path=/tools/lib \
    --target=$LFS_TGT \
    --disable-nls
make
make install
cd ../..

# 5.5
bzcat gcc-6.3.0.tar.bz2 | tar x
mv gcc-6.3.0/ gcc-6.3.0-proto1/
cd gcc-6.3.0-proto1/
tar -xf ../mpfr-3.1.5.tar.xz
mv -v mpfr-3.1.5 mpfr
tar -xf ../gmp-6.1.2.tar.xz
mv -v gmp-6.1.2 gmp
tar -xf ../mpc-1.0.3.tar.gz
mv -v mpc-1.0.3 mpc

for file in gcc/config/{linux,i386/linux{,64}}.h
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

mkdir -v build
cd build
../configure \
    --target=$LFS_TGT \
    --prefix=/tools \
    --with-glibc-version=2.11 \
    --with-sysroot=$LFS \
    --with-newlib \
    --without-headers \
    --with-local-prefix=/tools \
    --with-native-system-header-dir=/tools/include \
    --disable-nls \
    --disable-shared \
    --disable-multilib \
    --disable-decimal-float \
    --disable-threads \
    --disable-libatomic \
    --disable-libgomp \
    --disable-libmpx \
    --disable-libquadmath \
    --disable-libssp \
    --disable-libvtv \
    --disable-libstdcxx \
    --enable-languages=c,c++
make
make install
cd ../..

# 5.6
xzcat linux-4.9.9.tar.xz | tar x
mv linux-4.9.9/ linux-4.9.9-proto
cd linux-4.9.9-proto/
make mrproper
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /tools/include
cd ..

# 5.7
xzcat glibc-2.25.tar.xz | tar x
mv glibc-2.25/ glibc-2.25-proto
cd glibc-2.25-proto/
mkdir -v build
cd build/
../configure \
    --prefix=/tools \
    --host=$LFS_TGT \
    --build=$(../scripts/config.guess) \
    --enable-kernel=2.6.32 \
    -with-headers=/tools/include \
    libc_cv_forced_unwind=yes \
    libc_cv_c_cleanup=yes
make
make install
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools' | tee result.txt
cd ../..

# 5.8
bzcat gcc-6.3.0.tar.bz2 | tar x
mv gcc-6.3.0/ gcc-6.3.0-libstdc++-proto
cd gcc-6.3.0-libstdc++-proto/
mkdir -v build
cd build
../libstdc++-v3/configure \
    --host=$LFS_TGT \
    --prefix=/tools \
    --disable-multilib \
    --disable-nls \
    --disable-libstdcxx-threads \
    --disable-libstdcxx-pch \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/6.3.0
make
make install
cd ../..

# 5.9
bzcat binutils-2.27.tar.bz2 | tar x
mv binutils-2.27/ binutils-2.27-proto2
cd binutils-2.27-proto2/
mkdir -v build
cd build/
CC=$LFS_TGT-gcc \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../configure \
    --prefix=/tools \
    --disable-nls \
    --disable-werror \
    --with-lib-path=/tools/lib \
    --with-sysroot
make
make install
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin
cd ../..

# 5.10
bzcat gcc-6.3.0.tar.bz2 | tar x
mv gcc-6.3.0/ gcc-6.3.0-proto2
cd gcc-6.3.0-proto2/

cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h

for file in gcc/config/{linux,i386/linux{,64}}.h
  do
    cp -uv $file{,.orig}
    sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
        -e 's@/usr@/tools@g' $file.orig > $file
    echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

tar -xf ../mpfr-3.1.5.tar.xz
mv -v mpfr-3.1.5 mpfr
tar -xf ../gmp-6.1.2.tar.xz
mv -v gmp-6.1.2 gmp
tar -xf ../mpc-1.0.3.tar.gz
mv -v mpc-1.0.3 mpc

mkdir -v build
cd build/
CC=$LFS_TGT-gcc \
CXX=$LFS_TGT-g++ \
AR=$LFS_TGT-ar \
RANLIB=$LFS_TGT-ranlib \
../configure \
    --prefix=/tools \
    --with-local-prefix=/tools \
    --with-native-system-header-dir=/tools/include \
    --enable-languages=c,c++ \
    --disable-libstdcxx-pch \
    --disable-multilib \
    --disable-bootstrap \
    --disable-libgomp
make
make install
ln -sv gcc /tools/bin/cc
echo 'int main(){}' > dummy.c
cc dummy.c
readelf -l a.out | grep ': /tools' | tee result.txt
cd ../..

# 5.11
zcat tcl-core8.6.6-src.tar.gz | tar x
mv tcl8.6.6/ tcl8.6.6-proto
cd tcl8.6.6-proto/
cd unix/
./configure --prefix=/tools
make
##TZ=UTC make test | tee result.txt || echo > FAILED
make install
chmod -v u+w /tools/lib/libtcl8.6.so
make install-private-headers
ln -sv tclsh8.6 /tools/bin/tclsh
cd ../..

# 5.12
zcat expect5.45.tar.gz | tar x
mv expect5.45/ expect5.45-proto
cd expect5.45-proto/
cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure
./configure \
    --prefix=/tools \
    --with-tcl=/tools/lib \
    --with-tclinclude=/tools/include
make
##make test | tee result.txt || echo > FAILED
make SCRIPTS="" install
cd ..

# 5.13
zcat dejagnu-1.6.tar.gz | tar x
mv dejagnu-1.6/ dejagnu-1.6-proto
cd dejagnu-1.6-proto/
./configure --prefix=/tools
make install
##make check | tee result.txt || echo > FAILED
cd ..

# 5.14
zcat check-0.11.0.tar.gz | tar x
mv check-0.11.0/ check-0.11.0-proto
cd check-0.11.0-proto/
PKG_CONFIG= ./configure --prefix=/tools
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.15
zcat ncurses-6.0.tar.gz | tar x
mv ncurses-6.0/ ncurses-6.0-proto
cd ncurses-6.0-proto/
sed -i s/mawk// configure
./configure --prefix=/tools \
            --with-shared \
              --without-debug \
            --without-ada \
              --enable-widec \
             --enable-overwrite
make
make install
cd ..

# 5.16
zcat bash-4.4.tar.gz | tar x
#patch -p1 -d bash-4.4/ < bash-4.4-upstream_fixes-1.patch
mv bash-4.4/ bash-4.4-proto
cd bash-4.4-proto/
./configure --prefix=/tools --without-bash-malloc
make
##make tests | tee results.txt || echo > FAILED
make install
ln -sv bash /tools/bin/sh
cd ..

# 5.17
xzcat bison-3.0.4.tar.xz | tar x
mv bison-3.0.4/ bison-3.0.4-proto
cd bison-3.0.4-proto/
./configure --prefix=/tools
make
##make check | tee results.txt || echo > FAILED
make install
cd ..

# 5.18
zcat bzip2-1.0.6.tar.gz | tar x
#patch -p1 -d bzip2-1.0.6 < bzip2-1.0.6-install_docs-1.patch 
mv bzip2-1.0.6/ bzip2-1.0.6-proto
cd bzip2-1.0.6-proto/
make
make PREFIX=/tools install
cd ..

# 5.19
xzcat coreutils-8.26.tar.xz | tar x
mv coreutils-8.26/ coreutils-8.26-proto
cd coreutils-8.26-proto/
./configure --prefix=/tools --enable-install-program=hostname
make
##make RUN_EXPENSIVE_TESTS=yes check | tee result.txt || echo > FAILED
make install
cd ..

# 5.20
xzcat diffutils-3.5.tar.xz | tar x
mv diffutils-3.5/ diffutils-3.5-proto
cd diffutils-3.5-proto/
./configure --prefix=/tools
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.21
zcat file-5.30.tar.gz | tar x
mv file-5.30/ file-5.30-proto
cd file-5.30-proto/
./configure --prefix=/tools
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.22
zcat findutils-4.6.0.tar.gz | tar x
mv findutils-4.6.0/ findutils-4.6.0-proto
cd findutils-4.6.0-proto/
./configure --prefix=/tools
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.23
xzcat gawk-4.1.4.tar.xz | tar x
mv gawk-4.1.4/ gawk-4.1.4-proto
cd gawk-4.1.4-proto/
./configure --prefix=/tools
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.24
xzcat gettext-0.19.8.1.tar.xz | tar x
mv gettext-0.19.8.1/ gettext-0.19.8.1-proto
cd gettext-0.19.8.1-proto/
cd gettext-tools/
EMACS="no" ./configure --prefix=/tools --disable-shared
make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext
cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
cd ../..

# 5.25
xzcat grep-3.0.tar.xz | tar x
mv grep-3.0 grep-3.0-proto
cd grep-3.0-proto/
./configure --prefix=/tools
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.26
xzcat gzip-1.8.tar.xz | tar x
mv gzip-1.8/ gzip-1.8-proto
cd gzip-1.8-proto/
./configure --prefix=/tools
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.27
xzcat m4-1.4.18.tar.xz | tar x
mv m4-1.4.18/ m4-1.4.18-proto
cd m4-1.4.18-proto/
./configure --prefix=/tools
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.28
bzcat make-4.2.1.tar.bz2 | tar x
mv make-4.2.1/ make-4.2.1-proto
cd make-4.2.1-proto/
./configure --prefix=/tools --without-guile
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.29
xzcat patch-2.7.5.tar.xz | tar x
mv patch-2.7.5/ patch-2.7.5-proto
cd patch-2.7.5-proto/
./configure --prefix=/tools
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.30
bzcat perl-5.24.1.tar.bz2 | tar x
mv perl-5.24.1/ perl-5.24.1-proto
cd perl-5.24.1-proto/
sh Configure -des -Dprefix=/tools -Dlibs=-lm
make
cp -v perl cpan/podlators/scripts/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.24.1
cp -Rv lib/* /tools/lib/perl5/5.24.1
cd ..

# 5.31
xzcat sed-4.4.tar.xz | tar x
mv sed-4.4/ sed-4.4-proto
cd sed-4.4-proto/
./configure --prefix=/tools
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.32
xzcat tar-1.29.tar.xz | tar x
mv tar-1.29/ tar-1.29-proto
cd tar-1.29-proto/
./configure --prefix=/tools
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.33
xzcat texinfo-6.3.tar.xz | tar x
mv texinfo-6.3/ texinfo-6.3-proto
cd texinfo-6.3-proto/
./configure --prefix=/tools
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.34
xzcat util-linux-2.29.1.tar.xz | tar x
mv util-linux-2.29.1/ util-linux-2.29.1-proto
cd util-linux-2.29.1-proto/
./configure \
    --prefix=/tools \
    --without-python \
    --disable-makeinstall-chown \
    --without-systemdsystemunitdir \
    PKG_CONFIG=""
make
make install
cd ..

# 5.25
xzcat xz-5.2.3.tar.xz | tar x
mv xz-5.2.3/ xz-5.2.3-proto
cd xz-5.2.3-proto/
./configure --prefix=/tools
make
##make check | tee result.txt || echo > FAILED
make install
cd ..

# 5.36
strip --strip-debug /tools/lib/*
/usr/bin/strip --strip-unneeded /tools/{,s}bin/*
rm -rf /tools/{,share}/{info,man,doc}

