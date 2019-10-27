# Dotfiles

## Installation
To install this repo, go to your home directory and do a `git clone`:
```Bash
cd ~
git clone https://github.com/apatel762/dotfiles.git
```
It's important that this dotfiles directory is in your home directory
so that the install script functions correctly.

When the repository has finished downloading, do:
```Bash
cd ~/dotfiles
chmod +x install.sh && ./install.sh
```
The `chmod +x` is giving permission for `install.sh` to be executed.
Alternatively - read through the installer script and do what it's doing
manually.

### A note about VIM
You will need to install Vundle if you want Vim to not throw errors at you
whenever you try to run it. You may also need to install vim (instead of vi)
if it isn't on your machine.

The install script should handle this part for you.

## Troubleshooting
Normally when I install linux from scratch I get some issues. The fixes
are documented here.

#### My NTFS hard drive is stuck in read-only mode
If the hard drive was being used by Windows, a hibernate file would have
locked the hard drive into read-only mode so that Windows can boot up quickly
again and resume your files from where they were.

There are two fixes for this, the first one is to boot up in Windows again
and hold '_Shift_' while you shut down. This should fully shut down the 
computer and leave the hard drive in a mode where linux can read and write.

The alternative is to delete the `hiberfile` when you mount the drive in
Linux. This should only be done if you're not going to use the drive on that
same copy of Windows again (maybe you wiped Windows and installed Linux over 
it).
```Bash
sudo apt-get install ntfs-3g
sudo mount -t ntfs-3g -o remove_hiberfile /dev/sdb1 /mnt/OldHDD

# replace /dev/sdb1/ with the name of your disk
# you can use this command to see the names of your disks
sudo fdisk -l

# replace /mnt/OldHDD with whatever folder you want your disk
# to be mounted to. Make the folder if it doesn't exist.
sudo mkdir /mnt/OldHDD
```

#### My 4K screen won't run in 60fps
This was a tough one to fix. The issue in the end was that I needed the 
nvidia drivers (and they weren't included in the debian version that I 
had installed).

I used this guide: https://linoxide.com/debian/install-nvidia-driver-debian/
```Bash
# Do I need these driver/do I have an nvidia GPU?
lspci | grep -E "VGA|3D"

# Add the 'contrib' and 'non-free' repository components to 
# your /etc/apt/sources.list file
# e.g.
# deb http://deb.debian.org/debian/ buster main contrib non-free
# deb-src http://deb.debian.org/debian/ buster main contrib non-free

# After that, use this command to get all of the nvidia packages
sudo apt-get install \
  linux-headers-$(uname -r | sed 's/[^-]*-[^-]*-//') \
  nvidia-driver \
  nvidia-kernel-dkms \
```

If the above instructions don't work, you'll have to try using something 
like `cvt -r 3840 2160 60` to generate a new mode and then add that new mode
using `xrandr --newmode`.

I don't remember that working for me, but maybe the change would only take
place after downloading the nvidia drivers? (So in other words, it did work
but it wasn't a complete solution).
