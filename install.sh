
# su

set -e

./check.sh

export LFS=/mnt/lfs

source ./init1.sh
source ./init2.sh
source ./init3.sh
source ./init4.sh

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

