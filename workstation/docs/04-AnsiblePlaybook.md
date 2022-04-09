# Step 4: Ansible to the rescue!

Links:

- [Previous](./03-SetupLocalPython.md)
- [Next](./05-ManualSetup.md)

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
