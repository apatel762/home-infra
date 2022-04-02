# Workstation

**tl;dr** - start [here](docs/01-FreshInstall.md).

My workstation is running Fedora Silverblue. Why?

- It's really hard to brick the system thanks to OSTree and automatic rollbacks.
- ...this means that automatic updates are really easy and stable.
- ...this means that I can have the latest software without worrying about it.

Also the `toolbx` containers are really handy for installing one-time stuff without polluting the system.

## Notes

File and folder layout:

- `~/.local/bin` for standalone terminal apps.
- `~/Applications` for standalone GUI apps (e.g. `.AppImage` files).
- `~/Documents/Projects` for all git repositories & dev projects

In general, the home folder (`~`) should be really clean and most stuff should go into `~/.local` or `~/.config`.
