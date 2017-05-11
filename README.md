# LFSifoyE
A set of scripts to build Linux from scratch in front of your eyes

LFS (http://www.linuxfromscratch.org/) is a very cool project. But description in natural language is not always clear. And sometimes it is boring while lengthy build. (Sometimes I have read ahead and forgotten what I was doing)

So I leave a set of scripts that do essentially the same as I did.

## Assumptions
* You have linux on i686 PC. (You can use VirtualBox on x86_64 PC just like I did)
* Your PC uses IP address from DHCP instead of fixed IP address.
* You have a new disk formatted as follows.
    * sdb1: ext2 with boot flag (about 100M)
    * sdb2: ext4 (more than 16G)
    * sdb3: swap (about twice of the RAM)

After installation you must reorder your disks so that it is recognized as sda. (And you can switch back by reordering again)

## How to install
Just run ./install.sh as root user.
