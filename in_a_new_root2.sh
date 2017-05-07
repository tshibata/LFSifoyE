
touch /var/log/{btmp,lastlog,faillog,wtmp}
chgrp -v utmp /var/log/lastlog
chmod -v 664  /var/log/lastlog
chmod -v 600  /var/log/btmp


# 6.7

cd /sources/
xzcat linux-4.9.9.tar.xz | tar x
cd linux-4.9.9/


make mrproper


make INSTALL_HDR_PATH=dest headers_install
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* /usr/include


cd ..


# 6.8

xzcat man-pages-4.09.tar.xz | tar x
cd man-pages-4.09/


make install


cd ..


# 6.9

xzcat glibc-2.25.tar.xz | tar x
cd glibc-2.25/


patch -Np1 -i ../glibc-2.25-fhs-1.patch


case $(uname -m) in
    x86) ln -s ld-linux.so.2 /lib/ld-lsb.so.3
    ;;
    x86_64) ln -s ../lib/ld-linux-x86-64.so.2 /lib64
            ln -s ../lib/ld-linux-x86-64.so.2 /lib64/ld-lsb-x86-64.so.3
    ;;
esac


mkdir -v build
cd build/


../configure --prefix=/usr \
             --enable-kernel=2.6.32 \
             --enable-obsolete-rpc \
             --enable-stack-protector=strong \
             libc_cv_slibdir=/lib


make


##make check | tee result.txt || echo > FAILED


touch /etc/ld.so.conf


make install


cp -v ../nscd/nscd.conf /etc/nscd.conf
mkdir -pv /var/cache/nscd


mkdir -pv /usr/lib/locale
localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_GB -f UTF-8 en_GB.UTF-8
localedef -i en_HK -f ISO-8859-1 en_HK
localedef -i en_PH -f ISO-8859-1 en_PH
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
localedef -i es_MX -f ISO-8859-1 es_MX
localedef -i fa_IR -f UTF-8 fa_IR
localedef -i fr_FR -f ISO-8859-1 fr_FR
localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
localedef -i it_IT -f ISO-8859-1 it_IT
localedef -i it_IT -f UTF-8 it_IT.UTF-8
localedef -i ja_JP -f EUC-JP ja_JP
localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
localedef -i zh_CN -f GB18030 zh_CN.GB18030


make localedata/install-locales


cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF


tar -xf ../../tzdata2016j.tar.gz

ZONEINFO=/usr/share/zoneinfo
mkdir -pv $ZONEINFO/{posix,right}

for tz in etcetera southamerica northamerica europe africa antarctica \
          asia australasia backward pacificnew systemv; do
    zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
    zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
    zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
done

cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
zic -d $ZONEINFO -p America/New_York
unset ZONEINFO


#tzselect
# interractive!!!


cp -v /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime
# FIXME!!!


cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF


# 6.10

mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld


gcc -dumpspecs | sed -e 's@/tools@@g' \
    -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
    -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > \
    `dirname $(gcc --print-libgcc-file-name)`/specs


## echo 'int main(){}' > dummy.c
## cc dummy.c -v -Wl,--verbose &> dummy.log
## readelf -l a.out | grep ': /lib' | tee result2.txt


## grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log | tee result3.txt


## grep -B1 '^ /usr/include' dummy.log | tee result4.txt


## grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g' | tee result5.txt


## grep "/lib.*/libc.so.6 " dummy.log | tee result6.txt


## grep found dummy.log | tee result7.txt


## rm -v dummy.c a.out dummy.log


cd ../..


# 6.11

xzcat zlib-1.2.11.tar.xz | tar x
cd zlib-1.2.11/


./configure --prefix=/usr


make


##make check | tee result.txt || echo > FAILED


make install


mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so


cd ..


# 6.12

zcat file-5.30.tar.gz | tar x
cd file-5.30/


./configure --prefix=/usr


make


##make check | tee result.txt || echo > FAILED


make install


cd ..


# 6.13

bzcat binutils-2.27.tar.bz2 | tar x
cd binutils-2.27


## expect -c "spawn ls" | tee spawn_is.txt


mkdir -v build
cd build


../configure --prefix=/usr \
             --enable-gold \
             --enable-ld=default \
             --enable-plugins \
             --enable-shared \
             --disable-werror \
             --with-system-zlib


make tooldir=/usr


##make -k check | tee result.txt || echo > FAILED


make tooldir=/usr install


cd ../..


# 6.14

xzcat gmp-6.1.2.tar.xz | tar x
cd gmp-6.1.2/


ABI=32 ./configure --prefix=/usr \
            --enable-cxx \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.2


make
make html


##make check 2>&1 | tee gmp-check-log || echo > FAILED


awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log


make install
make install-html


cd ..


# 6.15

xzcat mpfr-3.1.5.tar.xz | tar x
cd mpfr-3.1.5/


./configure --prefix=/usr \
            --disable-static \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-3.1.5


make
make html


##make check | tee result.txt || echo > FAILED


make install
make install-html


cd ..


# 6.16

zcat mpc-1.0.3.tar.gz | tar x
cd mpc-1.0.3/


./configure --prefix=/usr \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.0.3


make
make html


##make check | tee result.txt || echo > FAILED


make install
make install-html


cd ..


# 6.17

bzcat gcc-6.3.0.tar.bz2 | tar x
cd gcc-6.3.0


mkdir -v build
cd build/


SED=sed \
../configure --prefix=/usr \
             --enable-languages=c,c++ \
             --disable-multilib \
             --disable-bootstrap \
             --with-system-zlib


make


ulimit -s 32768


##make -k check | tee result.txt || echo > FAILED


##../contrib/test_summary


make install


ln -sv /usr/bin/cpp /lib/


ln -sv /usr/bin/gcc /usr/bin/cc


install -v -dm755 /usr/lib/bfd-plugins
ln -sfv /usr/libexec/gcc/$(gcc -dumpmachine)/6.3.0/liblto_plugin.so \
    /usr/lib/bfd-plugins/


## echo 'int main(){}' > dummy.c
## cc dummy.c -v -Wl,--verbose &> dummy.log
## readelf -l a.out | grep ': /lib' | tee result2.txt


## grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log | tee result3.txt


## grep -B4 '^ /usr/include' dummy.log | tee result4.txt


## grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g' | tee result5.txt


## grep "/lib.*/libc.so.6 " dummy.log | tee result6.txt


## grep found dummy.log | tee result7.txt


## rm -v dummy.c a.out dummy.log


mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib


cd ../..


# 6.18

zcat bzip2-1.0.6.tar.gz | tar x
cd bzip2-1.0.6/


patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch


sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile


sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile


make -f Makefile-libbz2_so
make clean


make


make PREFIX=/usr install


cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat


cd ..


# 6.16

zcat pkg-config-0.29.1.tar.gz | tar x
cd pkg-config-0.29.1/


./configure --prefix=/usr \
            --with-internal-glib \
            --disable-compile-warnings \
            --disable-host-tool \
            --docdir=/usr/share/doc/pkg-config-0.29.1


make


##make check | tee result.txt || echo > FAILED


make install


cd ..


# 6.20

zcat ncurses-6.0.tar.gz | tar x
cd ncurses-6.0/


sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in


./configure --prefix=/usr \
            --mandir=/usr/share/man \
            --with-shared \
            --without-debug \
            --without-normal \
            --enable-pc-files \
            --enable-widec


make


make install


mv -v /usr/lib/libncursesw.so.6* /lib


ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so


for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done


rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so


mkdir -v /usr/share/doc/ncurses-6.0
cp -v -R doc/* /usr/share/doc/ncurses-6.0


cd ..


# 6.21

zcat attr-2.4.47.src.tar.gz | tar x
cd attr-2.4.47/


sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in


sed -i -e "/SUBDIRS/s|man[25]||g" man/Makefile


./configure --prefix=/usr \
            --bindir=/bin \
            --disable-static


make


##make -j1 tests root-tests | tee result.txt || echo > FAILED


make install install-dev install-lib
chmod -v 755 /usr/lib/libattr.so


mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so


cd ..


# 6.22

zcat acl-2.2.52.src.tar.gz | tar x
cd acl-2.2.52/


sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in


sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test


sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \
    libacl/__acl_to_any_text.c


./configure --prefix=/usr \
            --bindir=/bin \
            --disable-static \
            --libexecdir=/usr/lib


make


make install install-dev install-lib
chmod -v 755 /usr/lib/libacl.so


mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so


cd ..


# 6.23

xzcat libcap-2.25.tar.xz | tar x
cd libcap-2.25/


sed -i '/install.*STALIBNAME/d' libcap/Makefile


make


make RAISE_SETFCAP=no lib=lib prefix=/usr install
chmod -v 755 /usr/lib/libcap.so


mv -v /usr/lib/libcap.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so


cd ..


# 6.24

xzcat sed-4.4.tar.xz | tar x
cd sed-4.4/


sed -i 's/usr/tools/' build-aux/help2man
sed -i 's/panic-tests.sh//' Makefile.in


./configure --prefix=/usr --bindir=/bin


make
make html


##make check | tee result.txt || echo FAILED


make install
install -d -m755           /usr/share/doc/sed-4.4
install -m644 doc/sed.html /usr/share/doc/sed-4.4


cd ..


# 6.25

xzcat shadow-4.4.tar.xz | tar x
cd shadow-4.4/


sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;


sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
       -e 's@/var/spool/mail@/var/mail@' etc/login.defs


echo '--- src/useradd.c   (old)
+++ src/useradd.c   (new)
@@ -2027,6 +2027,8 @@
        is_shadow_grp = sgr_file_present ();
 #endif

+       get_defaults ();
+
        process_flags (argc, argv);

 #ifdef ENABLE_SUBIDS
@@ -2036,8 +2038,6 @@
            (!user_id || (user_id <= uid_max && user_id >= uid_min));
 #endif                         /* ENABLE_SUBIDS */

-       get_defaults ();
-
 #ifdef ACCT_TOOLS_SETUID
 #ifdef USE_PAM
        {' | patch -p0 -l


sed -i 's/1000/999/' etc/useradd


sed -i -e '47 d' -e '60,65 d' libmisc/myname.c


./configure --sysconfdir=/etc --with-group-name-max-length=32


make


make install


mv -v /usr/bin/passwd /bin


pwconv


grpconv


#passwd root # Not now.


cd ..


# 6.26

zcat psmisc-22.21.tar.gz | tar x
cd psmisc-22.21/


./configure --prefix=/usr


make


make install


mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin


cd ..


# 6.27

bzcat iana-etc-2.30.tar.bz2 | tar x
cd iana-etc-2.30/


make


make install


cd ..


#  6.28

xzcat m4-1.4.18.tar.xz | tar x
cd m4-1.4.18/


./configure --prefix=/usr


make


##make check | tee result.txt || echo > FAILED


make install


cd ..


# 6.29

xzcat bison-3.0.4.tar.xz | tar x
cd bison-3.0.4/


./configure --prefix=/usr --docdir=/usr/share/doc/bison-3.0.4


make


make install


cd ..


# 6.30

zcat flex-2.6.3.tar.gz | tar x
cd flex-2.6.3/


HELP2MAN=/tools/bin/true \
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.6.3


make


##make check | tee result.txt || echo FAILED


make install


ln -sv flex /usr/bin/lex


cd ..


# 6.31

xzcat grep-3.0.tar.xz | tar x
cd grep-3.0/


./configure --prefix=/usr --bindir=/bin


make


##make check | tee result.txt || echo > FAILED


make install


cd ..


# 6.32

zcat readline-7.0.tar.gz | tar x
cd readline-7.0/


sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install


./configure --prefix=/usr \
            --disable-static \
            --docdir=/usr/share/doc/readline-7.0


make SHLIB_LIBS=-lncurses


make SHLIB_LIBS=-lncurses install


mv -v /usr/lib/lib{readline,history}.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so


install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-7.0


cd ..


# 6.33

zcat bash-4.4.tar.gz | tar x
cd bash-4.4/


patch -Np1 -i ../bash-4.4-upstream_fixes-1.patch


./configure --prefix=/usr \
            --docdir=/usr/share/doc/bash-4.4 \
            --without-bash-malloc \
            --with-installed-readline


make


# skip the test!!


make install
mv -vf /usr/bin/bash /bin


cd ..

