# cd doesn't matter

# 8.4

grub-install /dev/sdb


cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd0,1)

menuentry "GNU/Linux, Linux 4.9.9-lfs-8.0" {
        linux   /vmlinuz-4.9.9-lfs-8.0 root=/dev/sda2 ro
}
EOF


echo 8.0 > /etc/lfs-release


cat > /etc/lsb-release << "EOF"
DISTRIB_ID="Linux From Scratch"
DISTRIB_RELEASE="8.0"
DISTRIB_CODENAME="tshibata@boutem.com"
DISTRIB_DESCRIPTION="Linux From Scratch"
EOF


# Set password for root
passwd root

