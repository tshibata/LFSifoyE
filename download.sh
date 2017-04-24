
set -e

pushd $LFS/sources

wget http://www.linuxfromscratch.org/lfs/view/stable/wget-list
wget --input-file=wget-list --continue

wget http://www.linuxfromscratch.org/lfs/view/stable/md5sums
md5sum -c md5sums

popd

