# hs_bootstrap_ssh

This role is intended for use **immediately** after installing the OS on your server.

Before running this role, you should modify the inventory file ([here](../../../hosts.ini)) and set the `ansible_user` for `broadwater` to whatever default user you created during the OS install.

Then, you should start an SSH session with that user, just to make sure you have access to the server if something goes wrong while running this role.

Then, you can run this role.

It will:

- Create a new user, called `admin`.
- Allow the `admin` user unrestricted `sudo` access (with no password).
- Add my public key to the authorised keys list.
- Harden SSH

Once this role is done, you should test that you can connect using the `admin` user and that you **cannot** connect using your default user.

Once you have confirmed this, you may exit the 'emergency' SSH session and revert the changes that you made to the Ansible inventory file.

You should also remove your default user.

```bash
sudo pkill -KILL -u amigo
sudo userdel amigo
```
