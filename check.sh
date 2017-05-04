#/bin/bash

# Stop when it has gone wrong.
set -e

# Currently it is only for i686.
test `uname -m` = i686

# You must be root user.
test $(id -u) = 0

# You must have build tools, for example...
which g++

# /dev/sdb1 must be ext2 with boot flag.
parted -m /dev/sdb print | grep '^1:.*:ext2::boot;$'

# /dev/sdb2 must be ext4.
parted -m /dev/sdb print | grep '^2:.*:ext4::;$'

# /dev/sdb3 must be swap.
parted -m /dev/sdb print | grep '^3:.*:linux-swap(v1)::;$'

# /dev/sdb1 and /dev/sdb2 must not have anything except for 'lost+found'.
TMPDIR=`mktemp -d`
mount /dev/sdb1 $TMPDIR
ls $TMPDIR | grep -v lost+found | diff /dev/null -
sleep 1 # Sometimes the device is still busy and umount fails.
umount /dev/sdb1
mount /dev/sdb2 $TMPDIR
ls $TMPDIR | grep -v lost+found | diff /dev/null -
sleep 1 # Sometimes the device is still busy and umount fails.
umount /dev/sdb2
rmdir $TMPDIR

# /mnt/lfs must not yet exist.
test ! -e /mnt/lfs

# User 'lfs' must not yet exist.
cat /etc/passwd | grep '^lfs:' | diff /dev/null -

# Group 'lfs' must not yet exist.
cat /etc/group | grep "^lfs:" | diff /dev/null -

# It seems to be ok.
echo ok

