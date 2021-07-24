# Dotfiles

All of my dotfiles and workstation config. These dotfiles are built for
Debian but they might also work on Ubuntu (or other downstream distros).

## Installation
To install this repo, go to your home directory and do a `git clone`:

```Bash
cd ~
git clone --recursive https://github.com/apatel762/dotfiles.git

# some submodules are used to track dependencies, so you need to
# clone the repo using `--recursive` or else the submodule folders
# will be empty.

# you can use the below command to init the submodules if you forgot
# to use the `--recursive` flag when you cloned the repo
git submodule update --init --recursive
```

Most of the configuration is managed by Ansible. Use the `run.sh` in the
`ansible` folder to install Ansible and run the playbooks for configuring
`localhost`.

Don't forget to `chmod 744 run.sh` if you can't run it.

Resources to help understand Ansible:

- [Ansible for DevOps (Jeff Geerling)](https://www.ansiblefordevops.com/)
- [Ansible role directory structure](https://www.golinuxcloud.com/ansible-roles-directory-structure-tutorial)
- [Managing Dotfiles with Ansible](https://thebroken.link/managing-dotfiles-with-ansible/)

### Beautifying the desktop
Gnome looks pretty plain by default, so it's nice to customise it a bit.
https://www.ubuntupit.com/customize-gnome-shell-tips-beautify-gnome-desktop/

Get the gnome tweak tool
```Bash
sudo apt-get install gnome-tweak-tool
```

Other settings
```
Icons: Papirus
https://github.com/PapirusDevelopmentTeam/papirus-icon-theme

GTK theme: Adapta-Eta
Shell Theme: Adapta
sudo apt-get install adapta-gtk-theme

Dash to Dock (gnome shell extension) to get the iOS style bottom dock

Font: iosevka (https://typeof.net/Iosevka/)
To install fonts:
* Move all of the .ttf files to '/usr/local/share/fonts' (will require sudo)
* Manually rebuild font cache using 'fc-cache -f -v'
* Optional: confirm their installation using 'fc-list | grep "font-name"'

Terminal themes: https://github.com/Mayccoll/Gogh
Installation:
* sudo apt-get install dconf-cli uuid-runtime
* bash -c "$(wget -qO- https://git.io/vQgMr)" # verify the script first!
* options: 05 07 11 13 24 48 55 84 93 102 137 139
* Currently using Azu theme
```

You can also play around with all of the other settings in the gnome tweak tool 
by pressing the Windows key (to browse all of your apps) and typing 'Tweaks' to 
find the tweaks window.

## Troubleshooting
Normally when I install linux from scratch I get some issues. The fixes
are documented here.

### My NTFS hard drive is stuck in read-only mode
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
# become root somehow
sudo su

apt-get install ntfs-3g

# replace /dev/sdb1/ with the name of your disk
# you can use this command to see the names of your disks
fdisk -l

# replace /mnt/OldHDD with whatever folder you want your disk
# to be mounted to. Make the folder if it doesn't exist.
mkdir /mnt/OldHDD

mount -t ntfs-3g -o remove_hiberfile /dev/sdb1 /mnt/OldHDD
```

### My 4K screen won't run in 60fps
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
