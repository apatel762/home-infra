# Step 1: Manual setup

Links:

- [Previous](../README.md)
- [Next](./02-AcquireRepo.md)

---

As I was installing the operating system there were a few things that needed to be done manually. I don't see any way of automating this stuff so I've written it all down here:

- Hard drive partitioning; let the installer handle it.
- Create a user.
- Connect the keyboard via Bluetooth in the Settings app.
- Change the hostname
- Install updates

## GNOME Terminal

This may be out of date soon as it appears that GNOME itself will be moving from Terminal to Console, but here are some manual bits of config that I did:

- Renamed default profile to 'Main'
- Changed initial terminal size to '140 columns' and '40 rows'
- Disabled the 'Terminal bell' setting

Download [Mayccoll/Gogh](https://github.com/Mayccoll/Gogh) via the one-line command and select theme number 203 (Tokyo Night)

```bash
bash -c "$(wget -qO- https://git.io/vQgMr)"
```
