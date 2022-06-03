# Workstation

**tl;dr** - start [here](docs/01-FreshInstall.md).

My workstation is running Fedora Silverblue.

## Notes

File and folder layout:

- `~/.local/bin` for standalone terminal apps.
- `~/Applications` for standalone GUI apps (e.g. `.AppImage` files).
- `~/Documents/Projects` for all git repositories & dev projects

In general, the home folder (`~`) should be kept clean and most files should go into `~/.local` or `~/.config`.

**All tasks requiring a terminal must be done inside of a toolbox container**. The exception to this is administrative work that can only be done in the host terminal, e.g. operations involving OSTree and Flatpak.
