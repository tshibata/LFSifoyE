# after in_a_new_root2.txt

#exec /bin/bash --login +h

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
# some of them fails


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


#make -j1 check | tee result.txt || echo > FAILED


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
# some of them fail


make install


cd ..


