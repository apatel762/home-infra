# Step 5: Manual setup

Links:

- [Previous](./04-AnsiblePlaybook.md)
- Next

---

## Other stuff

There are some things that aren't configurable at the moment via Ansible (or I am too lazy to add it to the playbook). I will write down those things below.

### VPS as VPN

To get easy access to the VPN setup, I need to add my VPS as a VPN (Network Manager applet) via the GNOME network settings. First copy the secrets to a local folder from the VPS:

```bash
mkdir -p ~/Documents/Secrets/VPN
rsync -avzh user@host:/media/sd_[0-9]/user/private/vpn/* ~/Documents/Secrets/VPN
```

...and once you have the settings, follow these steps to set up the NetworkManager applet:

- Go to 'Settings > Network > VPN' and click '+'.
- Click 'Import from file...'.
- Select the `client.ovpn` file.

You may also need to change the SELinux permissions on the OpenVPN config files in the folder or else the VPN connection won't work.

```bash
# change the SELinux context type of everything in the folder
su root
chcon -R -t home_cert_t /var/home/apatel/Documents/Secrets/VPN/
```

Using the below command:

```bash
\ls -al -d -Z client.ovpn
```

you can see the SELinux permissions on a file. The before & after of the above `ls` command will look something like this:

```
# before
-rw-------. 1 apatel apatel unconfined_u:object_r:user_home_t:s0 1095 Mar 22  2020 client.ovpn

#after
-rw-------. 1 apatel apatel unconfined_u:object_r:home_cert_t:s0 1095 Mar 22  2020 client.ovpn
```

References:

- https://ask.fedoraproject.org/t/nm-openvpn-cannot-pre-load-keyfile/19532/2
- https://unix.stackexchange.com/questions/166807/selinux-and-openvpn

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

TODO: automate this via the bash init scripts (as done with `pipx` and `bin`)

This is the CLI app that I use for note-taking. The playbook will get this onto the workstation, but I need to pull my notes down from GitHub:

```bash
git clone git@github.com:apatel762/notes.git ~/Documents/Notes
```

### Install PWAs via Brave

I've got some apps installed as PWAs through Brave:

- Jellyfin
- Komga
- Fastmail
- GitHub
- Reddit
- YouTube

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
