
cd /sources

xzcat dhcpcd-6.11.5.tar.xz | tar x
cd dhcpcd-6.11.5/

./configure --libexecdir=/lib/dhcpcd \
            --dbdir=/var/lib/dhcpcd  &&
make


make install


cd ..

# This is not in LFS.
cat > /etc/init.d/network << "EOF"
#!/bin/sh

case "${1}" in
   start)
      /sbin/dhcpcd # eth0 or wlan0 or whatever!
      ;;

   stop)
      /sbin/dhcpcd -k
      ;;

   restart)
      ${0} stop
      sleep 1
      ${0} start
      ;;

   *)
      echo "Usage: ${0} {start|stop|restart}"
      exit 1
      ;;
esac

exit 0
EOF




zcat openssl-1.0.2k.tar.gz | tar x
cd openssl-1.0.2k/


./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic &&
make depend           &&
make -j1


make MANDIR=/usr/share/man MANSUFFIX=ssl install &&
install -dv -m755 /usr/share/doc/openssl-1.0.2k  &&
cp -vfr doc/*     /usr/share/doc/openssl-1.0.2k


cd ..



install -vm755 make-ca.sh-20170119 /usr/sbin/make-ca.sh


/usr/sbin/make-ca.sh



xzcat wget-1.19.1.tar.xz | tar x
cd wget-1.19.1/


./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl &&
make


make install


cd ..

