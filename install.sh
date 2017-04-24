
# su

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

source ./in_a_new_root0.sh

cp in_a_new_root*.sh /mnt/lfs/

# 6.4
chroot "$LFS" /tools/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h /in_a_new_root1.sh

chroot "$LFS" /tools/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /tools/bin/bash --login +h /in_a_new_root2.sh

# /tools/bin/bash -> /bin/bash
#exec /bin/bash --login +h

chroot "$LFS" /tools/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /bin/bash --login +h /in_a_new_root3.sh

# go ahead

chroot "$LFS" /tools/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin \
    /bin/bash --login +h /in_a_new_root4.sh

# /tools/bin/bash again
# without +h

chroot $LFS /tools/bin/env -i            \
    HOME=/root TERM=$TERM PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin   \
    /tools/bin/bash --login /in_a_new_root5.sh

# /bin/bash

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash --login /in_a_new_root6.sh

# go ahead

chroot "$LFS" /usr/bin/env -i              \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin     \
    /bin/bash --login /in_a_new_root7.sh

