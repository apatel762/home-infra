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

## Other stuff

There are some things that aren't configurable at the moment via Ansible (or I am too lazy to add it to the playbook). I will write down those things below.

### VPS as VPN

To get easy access to the VPN setup, I need to add my VPS as a VPN (Network Manager applet) via the GNOME network settings. First copy the secrets to a local folder from the VPS:

```bash
mkdir -p ~/Documents/Secrets/VPN
rsync -avzh user@host:/media/sd_[0-9]/user/private/vpn/* ~/Documents/Secrets/VPN
```

...and once you have the settings, follow these steps to set up the NM applet:

- Go to 'Settings > Network > VPN' and click '+'.
- Click 'Import from file...'.
- Select the `client.ovpn` file.

### Add profile picture for user

Couldn't figure out a way to do this via dconf settings, like I did with the desktop wallpaper. So, have to do it manually:

- Adding a profile picture to my user.
  - Go to 'Settings > Users'.
  - Click on the profile picture and change it to an actual picture of me.

### Install GNOME extensions

Currently managed via `Extension Manager` Flatpak, which was installed by the playbook.

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

### Download `nb` notes folder

This is the CLI app that I use for note-taking. The playbook will get this onto the workstation, but I need to pull my notes down from GitHub:

```bash
git clone git@github.com:apatel762/notes.git ~/Documents/Notes
```

### Install `pipx` apps

I've got some Python apps that I've installed via `pipx` (might add this to the playbook at some point, but for now it's a manual process):

- `ranger-fm`
- `yt-dlp`

### Install `ghq`

This is for managing `git` repos. I literally just use this to stay organised and make sure that the repos I clone aren't spread across my system.

```bash
mkdir -p /tmp/download-ghq && cd /tmp/download-ghq
wget https://github.com/x-motemen/ghq/releases/download/v1.2.1/ghq_linux_amd64.zip
wget https://github.com/x-motemen/ghq/releases/download/v1.2.1/SHASUMS
grep linux SHASUMS | sha1sum --check

# ...if the checksum is OK
unzip -j ghq_linux_amd64.zip ghq_linux_amd64/ghq -d ~/.local/bin/
```

### Install `fzf`

I basically use this all the time when I'm in the terminal. It can be installed using the `install` script in the `fzf` repo, which makes things really easy.

```bash
ghq get https://github.com/junegunn/fzf.git
"$(ghq list -p | grep "github.com/junegunn/fzf")"/install --xdg --all --no-update-rc
```

We want to use `--no-update-rc` because my dotfiles already have the relevant snippets in them.