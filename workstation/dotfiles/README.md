# dotfiles

These are my dotfiles. They are intended for use on Linux and probably won't work on MacOS or WSL2 (Windows).

## Installation

Use the provided `install.sh` script to copy all of the files over and read the below informatin to make sure that everything is set up properly (because you may need to manually add stuff to `.bashrc` to make it all work).

## `.bashrc`

The `.bashrc.d/` folder holds all of the parts of what would be my `.bashrc`. To use it, copy the entire folder to `$HOME` and ensure that the below snippet is in the default `.bashrc` somewhere:

```bash
# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc
```

## `.inputrc`

This should be copied to wherever the `.bashrc.d/05-INPUTRC` file assumes that it will be. By default this is: `"$HOME/.config/.inputrc"`.
