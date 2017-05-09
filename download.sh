
set -e

# To avoid bothering the file servers, you can put the files in prepared.souces/
if [ -e prepared.sources ]; then cp prepared.sources/* $LFS/sources; fi;

pushd $LFS/sources

wget --no-clobber http://www.linuxfromscratch.org/lfs/view/stable/wget-list
wget --no-clobber --input-file=wget-list --continue

wget --no-clobber http://www.linuxfromscratch.org/lfs/view/stable/md5sums

md5sum -c md5sums

popd

