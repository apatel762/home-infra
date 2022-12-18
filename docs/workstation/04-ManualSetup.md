# Step 4: Manual setup

Links:

- [Previous](./03-AnsiblePlaybook.md)
- Next

## Note-taking

Install Rust: https://doc.rust-lang.org/book/ch01-01-installation.html

```bash
curl --proto '=https' --tlsv1.3 https://sh.rustup.rs -sSf | sh
# don't install PATH variables, they are already in the dotfiles
```

Install NoteExplorer: https://github.com/cdaven/noteexplorer

```bash
ghq get https://github.com/cdaven/noteexplorer.git
# go to cloned repo folder
cargo build --release
cp -vu target/release/noteexplorer -t ~/.local/bin
```

## Nextcloud

The playbook will put an AppImage onto the machine in the Applications folder.

Run the AppImage and follow the instructions to set everything up.

## VPS as VPN

Copy the secrets to a local folder from the VPS:

```bash
mkdir -p ~/Documents/Secrets/VPN
rsync -avzh user@host:/media/sd_[0-9]/user/private/vpn/* ~/Documents/Secrets/VPN
```

When you have the settings on your machine, set up the NetworkManager applet:

- Go to 'Settings > Network > VPN' and click '+'.
- Click 'Import from file...'.
- Select the `client.ovpn` file.

You may also need to change the SELinux permissions on the OpenVPN config files in the folder to make the VPN connection work.

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

```diff
-  -rw-------. 1 apatel apatel unconfined_u:object_r:user_home_t:s0 1095 Mar 22  2020 client.ovpn
+  -rw-------. 1 apatel apatel unconfined_u:object_r:home_cert_t:s0 1095 Mar 22  2020 client.ovpn
```

References:

- <https://ask.fedoraproject.org/t/nm-openvpn-cannot-pre-load-keyfile/19532/2>
- <https://unix.stackexchange.com/questions/166807/selinux-and-openvpn>

## Install GNOME extensions

GNOME Extensions are currently managed via the Extension Manager Flatpak, which is installed for you by the playbook.

Disabled extensions:

- 'window-list@gnome-shell-extensions.gcampax.github.com'
- 'launch-new-instance@gnome-shell-extensions.gcampax.github.com'

Enabled extensions:

- User-installed
    - 'blur-my-shell@aunetx'
    - 'trayIconsReloaded@selfmade.pl'
    - 'rounded-window-corners@yilozt'
- System
    - 'apps-menu@gnome-shell-extensions.gcampax.github.com'
    - 'background-logo@fedorahosted.org'
    - 'places-menu@gnome-shell-extensions.gcampax.github.com'

## Download `nb` notes folder

TODO: automate this via the bash init scripts (as done with `pipx` and `bin`)

The playbook will get `nb` onto the workstation, but to actually use it, the notes folder needs to be pulled down from GitHub:

```bash
git clone git@github.com:apatel762/notes.git ~/Documents/Notes
```

## Restore Reddit Enhancement Suite backup

Should be on Nextcloud somewhere.

This is so that I can use Reddit more effectively without signing in.

## Install TamperMonkey scripts

Only using one script at the moment: [Bring Back Old Reddit](https://greasyfork.org/en/scripts/44669-bring-back-old-reddit). If the script isn't available, source code is below:

```javascript
window.location.replace("https://old.reddit.com" + window.location.pathname + window.location.search);
```

## Jetbrains Toolbox

You install it once and it will manage itself.

```bash
cd "$(mktemp --directory)"

# go to https://www.jetbrains.com/toolbox-app/ for the links to the latest version
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.24.12080.tar.gz
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.24.12080.tar.gz.sha256

sha256sum --check jetbrains-toolbox-*.tar.gz.sha256

# if the checksum is OK...
ex jetbrains-toolbox-*.tar.gz
cd jetbrains-toolbox-*/
cp -vu jetbrains-toolbox -t "$HOME/.local/bin"
```

Once you've installed it, run the `jetbrains-toolbox` command in your host terminal to start it up. **Make sure that you turn off the setting that keeps it running in the background and upon startup**.

Install the IDEs that you need and they will be put into the `~/.local/share` folder by default.

The `.desktop` files are created automatically, so you don't need to worry about those.
