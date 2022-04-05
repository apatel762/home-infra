# Step 4: Ansible to the rescue!

Links:

- [Previous](./03-SetupLocalPython.md)
- Next

---

## Installing Ansible

There is no need to install Ansible globally (unless you'll be using it for stuff other outside of what's in this repo), so it's easiest, for now, to do it all inside of a virtual environment, which is what the `Makefile` does for you.

```bash
cd ~/Documents/Projects/github.com/apatel762/home-infra
cd workstation/configuration-playbook
make install
```

**NOTE**: This creates `~/.ansible` even though Ansible is in the virtual environment... Just something to note as I may need to add `make clean` target at some point to ensure that this is cleaned up?

## Running the playbook

This bit is simple. First, double-check all of the `group_vars` in the playbook, as that's what the playbook will be configuring. If everything looks OK, then just run:

```bash
make apply
```

And the machine should be configured when it's all done. The only thing you will have to do is to reboot so that it can finalise the package overlays & other system-level stuff that might have been modified.

## Caveats

There are some things that aren't configurable at the moment via Ansible (or I am too lazy to add it to the playbook). I will write down those things below.

- Adding VPS as a VPN (Network Manager applet) via the GNOME network settings.
  - Create a folder: `mkdir -p ~/Documents/Secrets/VPN`.
  - Copy files: `rsync -avzh user@host:/media/sd_[0-9]/user/private/vpn/* ~/Documents/Secrets/VPN`.
  - Go to 'Settings > Network > VPN' and click '+'.
  - Click 'Import from file...'.
  - Select the `client.ovpn` file.
- Adding a profile picture to my user.
  - Go to 'Settings > Users'.
  - Click on the profile picture and change it to an actual picture of me.
- GNOME extensions (currently managed via `Extension Manager` Flatpak):
  - Disabled extensions:
    - 'window-list@gnome-shell-extensions.gcampax.github.com'
    - 'launch-new-instance@gnome-shell-extensions.gcampax.github.com'
  - Enabled extensions:
    - 'background-logo@fedorahosted.org'
    - 'places-menu@gnome-shell-extensions.gcampax.github.com'
    - 'blur-my-shell@aunetx'
    - 'trayIconsReloaded@selfmade.pl'
    - 'apps-menu@gnome-shell-extensions.gcampax.github.com'
    - 'screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com'
- Installing `nb` (for note taking):
  - The playbook will get `nb` onto the workstation, just need to add the notes folder:
  - `git clone git@github.com:apatel762/notes.git ~/Documents/Notes`
- Stuff installed via `pipx`
  - `ranger-fm`
  - `yt-dlp`
- Install `ghq` for managing git repos
  - `wget https://github.com/x-motemen/ghq/releases/download/v1.2.1/ghq_linux_amd64.zip`
  - `wget https://github.com/x-motemen/ghq/releases/download/v1.2.1/SHASUMS`
  - `grep linux SHASUMS | sha1sum --check`
  - `cp -vu ghq_linux_amd64/ghq -t ~/.local/bin/`