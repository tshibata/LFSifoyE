# su
# export LFS=/mnt/lfs

# 6.72

#chroot $LFS /tools/bin/env -i            \
#    HOME=/root TERM=$TERM PS1='\u:\w\$ ' \
#    PATH=/bin:/usr/bin:/sbin:/usr/sbin   \
#    /tools/bin/bash --login


/tools/bin/find /usr/lib -type f -name \*.a \
   -exec /tools/bin/strip --strip-debug {} ';'

/tools/bin/find /lib /usr/lib -type f -name \*.so* \
   -exec /tools/bin/strip --strip-unneeded {} ';'

/tools/bin/find /{bin,sbin} /usr/{bin,sbin,libexec} -type f \
    -exec /tools/bin/strip --strip-all {} ';'


# 6.73

rm -rf /tmp/*

