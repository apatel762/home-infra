# Step 5: Manual setup

Links:

- [Previous](./04-AnsiblePlaybook.md)
- Next

---

## Other stuff

There are some things that aren't configurable at the moment via Ansible (or I am too lazy to add it to the playbook). I will write down those things below.

### VPS as VPN

**TODO: this doesn't actually work** - when I try to use the VPN, it won't run.

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

TODO: move this into the playbook

This is the CLI app that I use for note-taking. The playbook will get this onto the workstation, but I need to pull my notes down from GitHub:

```bash
git clone git@github.com:apatel762/notes.git ~/Documents/Notes
```

### Install `pipx` apps

TODO: move this into the playbook

I've got some Python apps that I've installed via `pipx` (might add this to the playbook at some point, but for now it's a manual process):

- `ranger-fm`
- `yt-dlp`
- `poetry`

### Install `ghq`

TODO: move this into the playbook

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

TODO: move this into the playbook

I basically use this all the time when I'm in the terminal. It can be installed using the `install` script in the `fzf` repo, which makes things really easy.

```bash
ghq get https://github.com/junegunn/fzf.git
"$(ghq list -p | grep "github.com/junegunn/fzf")"/install --xdg --all --no-update-rc
```

We want to use `--no-update-rc` because my dotfiles already have the relevant snippets in them.

### Install ripgrep

TODO: move this into the playbook

Had to install this manually:

```bash
mkdir -p /tmp/download-ripgrep && cd /tmp/download-ripgrep
wget https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz
ex ripgrep-13.0.0-x86_64-unknown-linux-musl.tar.gz

cp -vu ripgrep-13.0.0-x86_64-unknown-linux-musl/rg -t ~/.local/bin
```

### Install `sk`

TODO: move this into the playbook

More complex alternative to `fzf` that I'm using to manage my notes.

```bash
mkdir -p /tmp/download-skim && cd /tmp/download-skim
wget https://github.com/lotabout/skim/releases/download/v0.9.4/skim-v0.9.4-x86_64-unknown-linux-musl.tar.gz
ex skim-v0.9.4-x86_64-unknown-linux-musl.tar.gz

cp -vu sk -t ~/.local/bin
```

### Install `bat`

TODO: move this into the playbook

Nicer alternative to `cat` (with lots of colours).

```bash
mkdir -p /tmp/download-bat && cd /tmp/download-bat
wget https://github.com/sharkdp/bat/releases/download/v0.20.0/bat-v0.20.0-x86_64-unknown-linux-musl.tar.gz
ex bat-v0.20.0-x86_64-unknown-linux-musl.tar.gz

cp -vu bat-v0.20.0-x86_64-unknown-linux-musl/bat -t ~/.local/bin
```

### Install PWAs via Brave

I've got some apps installed as PWAs through Brave:

- Jellyfin
- Fastmail
- GitHub
- Reddit

This is so that I can launch these are separate apps and still have the ad-block and other stuff available.

For my usual browsing, I use incognito mode so that the cookies don't stick around. Any site where I might want to sign in, I add to the desktop as a PWA.

### Restore Reddit Enhancement Suite backup

Should be on Nextcloud somewhere.

This is so that I can use Reddit more effectively without signing in.

### Install TamperMonkey scripts

Only using one script at the moment: [Bring Back Old Reddit](https://greasyfork.org/en/scripts/44669-bring-back-old-reddit). If the script isn't available, source code is below:

```javascript
window.location.replace("https://old.reddit.com" + window.location.pathname + window.location.search);
```
