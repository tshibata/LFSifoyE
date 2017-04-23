# cd doesn't matter

# sudo /bin/sh ./init3.sh

# 4.2
mkdir -v $LFS/tools
ln -sv $LFS/tools /

# 4.3
groupadd lfs
useradd -s /bin/bash -g lfs -m -k /dev/null lfs
#passwd lfs
# passwd really needed?

