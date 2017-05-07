
cd /sources/

# 6.34

bzcat bc-1.06.95.tar.bz2 | tar x
cd bc-1.06.95/


patch -Np1 -i ../bc-1.06.95-memory_leak-1.patch


./configure --prefix=/usr \
            --with-readline \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info


make


##echo "quit" | ./bc/bc -l Test/checklib.b | tee result.txt


make install


cd ..


# 6.35

xzcat libtool-2.4.6.tar.xz | tar x
cd libtool-2.4.6/


./configure --prefix=/usr


make


##make check | tee result.txt || echo > FAILED


make install


cd ..


# 6.36

zcat gdbm-1.12.tar.gz | tar x
cd gdbm-1.12/


./configure --prefix=/usr \
            --disable-static \
            --enable-libgdbm-compat


make


##make check | tee result.txt || echo > FAILED


make install


cd ..


# 6.37

zcat gperf-3.0.4.tar.gz | tar x
cd gperf-3.0.4/


./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.0.4


make


##make -j1 check | tee result.txt || echo > FAILED


make install


cd ..


# 6.38

bzcat expat-2.2.0.tar.bz2 | tar x
cd expat-2.2.0/


./configure --prefix=/usr --disable-static


make


##make check | tee result.txt || echo > FAILED


make install


# document

cd ..


# 6.39

xzcat inetutils-1.9.4.tar.xz | tar x
cd inetutils-1.9.4/


./configure --prefix=/usr \
    --localstatedir=/var \
    --disable-logger \
    --disable-whois \
    --disable-rcp \
    --disable-rexec \
    --disable-rlogin \
    --disable-rsh \
    --disable-servers


make


##make check | tee result.txt || echo > FAILED


make install


mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
mv -v /usr/bin/ifconfig /sbin


cd ..


# 6.40

bzcat perl-5.24.1.tar.bz2 | tar x
cd perl-5.24.1/


echo "127.0.0.1 localhost $(hostname)" > /etc/hosts


export BUILD_ZLIB=False
export BUILD_BZIP2=0



sh Configure -des -Dprefix=/usr \
    -Dvendorprefix=/usr \
    -Dman1dir=/usr/share/man/man1 \
    -Dman3dir=/usr/share/man/man3 \
    -Dpager="/usr/bin/less -isR" \
    -Duseshrplib


make


##make -k test | tee result.txt || echo > FAILED


make install
unset BUILD_ZLIB BUILD_BZIP2


cd ..


# 6.41

zcat XML-Parser-2.44.tar.gz | tar x
cd XML-Parser-2.44/


perl Makefile.PL 


make


##make test | tee result.txt || echo > FAILED


make install


cd ..


# 6.42

zcat intltool-0.51.0.tar.gz | tar x
cd intltool-0.51.0/


sed -i 's:\\\${:\\\$\\{:' intltool-update.in


./configure --prefix=/usr


make


##make check | tee result.txt || echo > FAILED


make install
install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO


cd ..


# 6.43

xzcat autoconf-2.69.tar.xz | tar x
cd autoconf-2.69/


./configure --prefix=/usr


make


##make check | tee result.txt || echo > FAILED


make install


cd ..


# 6.44

xzcat automake-1.15.tar.xz | tar x
cd automake-1.15/


sed -i 's:/\\\${:/\\\$\\{:' bin/automake.in


./configure --prefix=/usr --docdir=/usr/share/doc/automake-1.15


make


sed -i "s:./configure:LEXLIB=/usr/lib/libfl.a &:" t/lex-{clean,depend}-cxx.sh
##make -j4 check | tee result.txt || echo > FAILED


make install


cd ..


# 6.45

xzcat xz-5.2.3.tar.xz | tar x
cd xz-5.2.3/


./configure --prefix=/usr \
    --disable-static \
    --docdir=/usr/share/doc/xz-5.2.3


make


##make check | tee result.txt || echo > FAILED


make install
mv -v /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
mv -v /usr/lib/liblzma.so.* /lib
ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so


cd ..


# 6.46

xzcat kmod-23.tar.xz | tar x
cd kmod-23/


./configure --prefix=/usr \
    --bindir=/bin \
    --sysconfdir=/etc \
    --with-rootlibdir=/lib \
    --with-xz \
    --with-zlib


make


make install

for target in depmod insmod lsmod modinfo modprobe rmmod
do
   ln -sfv ../bin/kmod /sbin/$target
done

ln -sfv kmod /bin/lsmod


cd ..


# 6.47

xzcat gettext-0.19.8.1.tar.xz | tar x
cd gettext-0.19.8.1/


sed -i '/^TESTS =/d' gettext-runtime/tests/Makefile.in &&
sed -i 's/test-lock..EXEEXT.//' gettext-tools/gnulib-tests/Makefile.in


./configure --prefix=/usr \
    --disable-static \
    --docdir=/usr/share/doc/gettext-0.19.8.1


make


##make check | tee result.txt || echo > FAILED


make install
chmod -v 0755 /usr/lib/preloadable_libintl.so


cd ..


# 6.48

xzcat procps-ng-3.3.12.tar.xz | tar x
cd procps-ng-3.3.12/


./configure --prefix=/usr \
    --exec-prefix= \
    --libdir=/usr/lib \
    --docdir=/usr/share/doc/procps-ng-3.3.12 \
    --disable-static \
    --disable-kill


make


sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp
##make check | tee result.txt || echo > FAILED


make install


mv -v /usr/lib/libprocps.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so


cd ..


# 6.49

zcat e2fsprogs-1.43.4.tar.gz | tar x
cd e2fsprogs-1.43.4/


mkdir -v build
cd build/


LIBS=-L/tools/lib \
CFLAGS=-I/tools/include \
PKG_CONFIG_PATH=/tools/lib/pkgconfig \
../configure --prefix=/usr \
    --bindir=/bin \
    --with-root-prefix="" \
    --enable-elf-shlibs \
    --disable-libblkid \
    --disable-libuuid \
    --disable-uuidd \
    --disable-fsck


make


ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib
##make LD_LIBRARY_PATH=/tools/lib check | tee result.txt || echo > FAILED


make install


make install-libs


chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a


gunzip -v /usr/share/info/libext2fs.info.gz
install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info


# document


cd ../..


# 6.50

xzcat coreutils-8.26.tar.xz | tar x
cd coreutils-8.26/


patch -Np1 -i ../coreutils-8.26-i18n-1.patch


sed -i '/test.lock/s/^/#/' gnulib-tests/gnulib.mk


FORCE_UNSAFE_CONFIGURE=1 ./configure \
    --prefix=/usr \
    --enable-no-install-program=kill,uptime


FORCE_UNSAFE_CONFIGURE=1 make


# test


make install


mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8


mv -v /usr/bin/{head,sleep,nice,test,[} /bin


cd ..


# 6.51
xzcat diffutils-3.5.tar.xz | tar x
cd diffutils-3.5/


sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in


./configure --prefix=/usr


make


##make check | tee result.txt || echo > FAILED


make install


cd ..


# 6.52
xzcat gawk-4.1.4.tar.xz | tar x
cd gawk-4.1.4/


./configure --prefix=/usr


make


##make check | tee result || echo > FAILED


make install


# document


cd ..


# 6.53

zcat findutils-4.6.0.tar.gz | tar x
cd findutils-4.6.0/


sed -i 's/test-lock..EXEEXT.//' tests/Makefile.in


./configure --prefix=/usr --localstatedir=/var/lib/locate


make


##make check | tee result.txt || echo > FAILED


make install


mv -v /usr/bin/find /bin
sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb


cd ..


# 6.54

zcat groff-1.22.3.tar.gz | tar x
cd groff-1.22.3/


PAGE=A4 ./configure --prefix=/usr


make


make install


cd ..


# 6.55
xzcat grub-2.02~beta3.tar.xz | tar x
cd grub-2.02~beta3/


./configure --prefix=/usr \
    --sbindir=/sbin \
    --sysconfdir=/etc \
    --disable-efiemu \
    --disable-werror


make


make install


cd ..


# 6.56

zcat less-481.tar.gz | tar x
cd less-481/


./configure --prefix=/usr --sysconfdir=/etc


make


make install


cd ..


# 6.57

xzcat gzip-1.8.tar.xz | tar x
cd gzip-1.8/


./configure --prefix=/usr


make


##make check | tee result.txt || echo > FAILED


make install


mv -v /usr/bin/gzip /bin


cd ..


# 6.58

xzcat iproute2-4.9.0.tar.xz | tar x
cd iproute2-4.9.0/


sed -i /ARPD/d Makefile
sed -i 's/arpd.8//' man/man8/Makefile
rm -v doc/arpd.sgml


sed -i 's/m_ipt.o//' tc/Makefile


make


make DOCDIR=/usr/share/doc/iproute2-4.9.0 install


cd ..


# 6.59

xzcat kbd-2.0.4.tar.xz | tar x
cd kbd-2.0.4/


patch -Np1 -i ../kbd-2.0.4-backspace-1.patch


sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in


PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock


make


##make check | tee result.txt || echo > FAILED


make install


# document


cd ..


# 6.60

zcat libpipeline-1.4.1.tar.gz | tar x
cd libpipeline-1.4.1/


PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr


make


##make check | tee result.txt || echo > FAILED


make install


cd ..


# 6.61

bzcat make-4.2.1.tar.bz2 | tar x
cd make-4.2.1/


./configure --prefix=/usr


make


##make check | tee result.txt || echo > FAILED


make install


cd ..


# 6.62
xzcat patch-2.7.5.tar.xz | tar x
cd patch-2.7.5


./configure --prefix=/usr


make


##make check | tee result || echo > FAILED


make install


cd ..


# 6.63
zcat sysklogd-1.5.1.tar.gz | tar x
cd sysklogd-1.5.1/


sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
sed -i 's/union wait/int/' syslogd.c


make


make BINDIR=/sbin install


cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF


cd ..


# 6.64

bzcat sysvinit-2.88dsf.tar.bz2 | tar x
cd sysvinit-2.88dsf/


patch -Np1 -i ../sysvinit-2.88dsf-consolidated-1.patch


make -C src


make -C src install


cd ..


# 6.65

zcat eudev-3.2.1.tar.gz | tar x
cd eudev-3.2.1/


sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl


sed -i '/keyboard_lookup_key/d' src/udev/udev-builtin-keyboard.c


cat > config.cache << "EOF"
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include"
EOF


./configure --prefix=/usr \
    --bindir=/sbin \
    --sbindir=/sbin \
    --libdir=/usr/lib \
    --sysconfdir=/etc \
    --libexecdir=/lib \
    --with-rootprefix= \
    --with-rootlibdir=/lib \
    --enable-manpages \
    --disable-static \
    --config-cache


LIBRARY_PATH=/tools/lib make


mkdir -pv /lib/udev/rules.d
mkdir -pv /etc/udev/rules.d


make LD_LIBRARY_PATH=/tools/lib check | tee result.txt || echo > FAILED


make LD_LIBRARY_PATH=/tools/lib install


tar -xvf ../udev-lfs-20140408.tar.bz2
make -f udev-lfs-20140408/Makefile.lfs install


LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update


cd ..


# 6.66

xzcat util-linux-2.29.1.tar.xz | tar x
cd util-linux-2.29.1/


mkdir -pv /var/lib/hwclock


./configure ADJTIME_PATH=/var/lib/hwclock/adjtime \
    --docdir=/usr/share/doc/util-linux-2.29.1 \
    --disable-chfn-chsh \
    --disable-login \
    --disable-nologin \
    --disable-su \
    --disable-setpriv \
    --disable-runuser \
    --disable-pylibmount \
    --disable-static \
    --without-python \
    --without-systemd \
    --without-systemdsystemunitdir


make


# test


make install


cd ..


# 6.67

xzcat man-db-2.7.6.1.tar.xz | tar x
cd man-db-2.7.6.1/


./configure --prefix=/usr \
    --docdir=/usr/share/doc/man-db-2.7.6.1 \
    --sysconfdir=/etc \
    --disable-setuid \
    --enable-cache-owner=bin \
    --with-browser=/usr/bin/lynx \
    --with-vgrind=/usr/bin/vgrind \
    --with-grap=/usr/bin/grap \
    --with-systemdtmpfilesdir=


make


##make check | tee result.txt || echo > FAILED


make install


cd ..


# 6.68

xzcat tar-1.29.tar.xz | tar x
cd tar-1.29/


FORCE_UNSAFE_CONFIGURE=1 \
./configure --prefix=/usr \
    --bindir=/bin


make


##make check | tee result.txt || echo > FAILED


make install
make -C doc install-html docdir=/usr/share/doc/tar-1.29
cd ..


# 6.69

xzcat texinfo-6.3.tar.xz | tar x
cd texinfo-6.3/


./configure --prefix=/usr --disable-static


make


##make check | tee result.txt || echo > FAILED


make install


make TEXMF=/usr/share/texmf install-tex
# really needed?


pushd /usr/share/info
rm -v dir
for f in *
  do install-info $f dir 2>/dev/null
done
popd
# really needed?


cd ..


# 6.70

bzcat vim-8.0.069.tar.bz2 | tar x
cd vim80/


echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h


./configure --prefix=/usr


make


##make -j1 test | tee result.txt || echo > FAILED


make install


ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
    ln -sv vim.1 $(dirname $L)/vi.1
done


ln -sv ../vim/vim80/doc /usr/share/doc/vim-8.0.069


cd ..


