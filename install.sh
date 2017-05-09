#!/bin/bash

set -e

./check.sh

# 2.6
export LFS=/mnt/lfs


# 2.7
mkdir -pv $LFS
mount -v -t ext4 /dev/sdb2 $LFS
mkdir -pv $LFS/boot
mount -v -t ext2 /dev/sdb1 $LFS/boot


# 3.1
mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources

source ./download.sh


# 4.2
mkdir -v $LFS/tools
ln -sv $LFS/tools /


# 4.3
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
#passwd lfs

chown -v lfs $LFS/tools
chown -v lfs $LFS/sources



cp as_a_new_user*.sh /home/lfs

sudo -u lfs env HOME=/home/lfs /bin/bash ./as_a_new_user1.sh

sudo -u lfs env -i HOME=/home/lfs TERM=$TERM PS1='\u:\w\$ ' /bin/bash ./as_a_new_user2.sh


# 5.37
chown -R root:root $LFS/tools

# 6.2
mkdir -pv $LFS/{dev,proc,sys,run}

mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

mount -v --bind /dev $LFS/dev

mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]; then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

# Copy scripts. This is not in original LFS.
cp in_a_new_root*.sh /mnt/lfs/sources/

# 6.4
chroot "$LFS" /tools/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h /sources/in_a_new_root1.sh

# /etc/passwd and /etc/group are now ready

chroot "$LFS" /tools/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h /sources/in_a_new_root2.sh

# use /bin/bash insread of /tools/bin/bash

chroot "$LFS" /tools/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /bin/bash --login +h /sources/in_a_new_root3.sh

# /tools/bin/bash again
# without +h

chroot "$LFS" /tools/bin/env -i            \
    HOME=/root TERM=$TERM PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin   \
    /tools/bin/bash --login /sources/in_a_new_root4.sh

# /bin/bash

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash --login /sources/in_a_new_root5.sh

# LFS is done.
# Install extra programs.

wget --no-clobber --directory-prefix=$LFS/sources http://roy.marples.name/downloads/dhcpcd/dhcpcd-6.11.5.tar.xz
wget --no-clobber --directory-prefix=$LFS/sources https://openssl.org/source/openssl-1.0.2k.tar.gz
wget --no-clobber --directory-prefix=$LFS/sources http://anduin.linuxfromscratch.org/BLFS/other/make-ca.sh-20170119
wget --no-clobber --directory-prefix=$LFS/sources http://anduin.linuxfromscratch.org/BLFS/other/certdata.txt
wget --no-clobber --directory-prefix=$LFS/sources http://ftp.gnu.org/gnu/wget/wget-1.19.1.tar.xz

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash --login /sources/in_a_new_rootX.sh

# Set password for root
chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/passwd root

