
# 2.6
export LFS=/mnt/lfs

# 2.7
mkdir -pv $LFS
mount -v -t ext4 /dev/sdb2 $LFS
mkdir -pv $LFS/boot
mount -v -t ext2 /dev/sdb1 $LFS/boot

