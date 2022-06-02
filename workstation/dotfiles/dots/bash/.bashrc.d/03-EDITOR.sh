#!/usr/bin/env bash

function _ensure_neovim_appimage_extracted() {
	local LOCAL_BIN
	LOCAL_BIN="$HOME/.local/bin"
	mkdir -p "$LOCAL_BIN"

	local EXPECTED_NEOVIM_BINARY
	EXPECTED_NEOVIM_BINARY="$LOCAL_BIN/nvim" 

	local EXPECTED_NEOVIM_APPIMAGE
	EXPECTED_NEOVIM_APPIMAGE="$LOCAL_BIN/nvim.AppImage" 

	# ensure that we re-extract the Neovim AppImage if AppImage version is
	# different to the extracted binary. We make sure of this by deleting
	# the extracted binary if there's a difference in the version output,
	# and the code down below should detect that it needs to re-extract
	# stuff.
	#
	# version mismatch checking is disabled when you are in a toolbox
	# because we can't check the .AppImage version without having FUSE
	# installed, and it isn't installed in a container.
	if [ -e "$EXPECTED_NEOVIM_BINARY" ] && [ -e "$EXPECTED_NEOVIM_APPIMAGE" ] \
		&& [ ! -f /run/.containerenv ] && [ ! -f /run/.toolboxenv ] ; then
		local NEOVIM_APPIMAGE_VERSION
		NEOVIM_APPIMAGE_VERSION="$("$EXPECTED_NEOVIM_APPIMAGE" --version)"
		local NEOVIM_BINARY_VERSION
		NEOVIM_BINARY_VERSION="$("$EXPECTED_NEOVIM_BINARY" --version)"

		if [[ "$NEOVIM_APPIMAGE_VERSION" != "$NEOVIM_BINARY_VERSION" ]]; then
			echo "Detected mismatch between nvim.AppImage and nvim binary; deleting the binary."
			rm -f "$EXPECTED_NEOVIM_BINARY" 
		fi
	fi

	# if the symlink is broken, ensure that the target is removed
	# ...and remove the squashfs root while we're at it (if it's there)
	if [ ! -e "$EXPECTED_NEOVIM_BINARY" ]; then
		rm -f "$EXPECTED_NEOVIM_BINARY" 
		rm -rf "$LOCAL_BIN/nvim-root"
	fi 

	if ! command -v nvim &>/dev/null \
		&& [ -f "$EXPECTED_NEOVIM_APPIMAGE" ]; then
		# if we are in here, we have the AppImage in the local bin and
		# we DON'T have the plain Neovim binary, so here, we need to
		# extract it from the AppImage and create a symlink
		(
			echo "Creating physical nvim.AppImage alias"
			cd "$LOCAL_BIN" || return 1
			./nvim.AppImage --appimage-extract &>/dev/null

			# rename the fs root folder
			mv squashfs-root nvim-root

			# create symlink
			ln -s nvim-root/usr/bin/nvim nvim
		)
	fi
}

# if we've got 'nvim' then prioritise that over the other stuff
if command -v nvim &>/dev/null; then
	export VISUAL=nvim
	export EDITOR=nvim
	alias vi='vim'
	alias vim='nvim'
	[[ $(type -t nvim) == "alias" ]] && unalias nvim

	# using the Neovim AppImage on my workstation, so if it's present, this
	# init script will extract the AppImage and create the relevant
	# symlinks to make it all work (even when inside of a toolbox, where
	# you can't use FUSE mounts).
	_ensure_neovim_appimage_extracted


# if we've got 'vim', then use that over 'vi' to make things a little
# bit easier to use
elif command -v vim &>/dev/null; then
	export VISUAL=vim
	export EDITOR=vim
	alias vi='vim'
	[[ $(type -t vim) == "alias" ]] && unalias vim
	alias nvim='vim'

# we definitely should have 'vi' installed at the very least, so use
# that in the aliases...
else
	export VISUAL=vi
	export EDITOR=vi
	[[ $(type -t vi) == "alias" ]] && unalias vi
	alias vim='vi'
	alias nvim='vi'

fi
